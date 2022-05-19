class MeetingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @meetings = current_user.meetings.all.order('start_time')
    @todays_meeting = @meetings.select {|x| x.start_time.day == Time.current.day}
    @upcoming_meeting = @meetings.select {|x| x.start_time.day > Time.current.day}
    @completed_meeting = @meetings.select {|x| x.start_time.day < Time.current.day}
  end

  def new 
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.user_id = current_user.id

    token = params[:stripeToken]
    card_brand = params[:user][:card_brand]
    card_exp_month = params[:user][:card_exp_month]
    card_exp_year = params[:user][:card_exp_year]
    card_last4 = params[:user][:card_last4]
    Stripe.api_key = Rails.application.secrets.stripe_api_key

    charge = Stripe::Charge.create(
      amount: 50000,
      currency: "inr",
      description: "Meeting charges",
      source: token
    )

    current_user.stripe_id = charge.id
    current_user.card_brand = card_brand
    current_user.card_exp_month = card_exp_month
    current_user.card_exp_year = card_exp_year
    current_user.card_last4 = card_last4
    current_user.save!

    if @meeting.save
      SendMailWorker.perform_async(current_user.email, 5)
      redirect_to @meeting, notice: 'Meeting was successfully created.'
    else
      flash[:alert] = @meeting.errors.full_messages.first
      render :new
    end

    rescue Stripe::CardError => e
      flash.alert = e.message
      render action: :new
  end
 
  def show
    @meeting = Meeting.find(params[:id])
    @comments = @meeting.comments.all
    @comment = Comment.new
  end

  def destroy
    @meeting = Meeting.find(params[:id])
    if @meeting.destroy
      flash[:notice] = "Successfully deleted meeting!"
      redirect_to meetings_path
    else
      flash[:alert] = "Error deleting meeting!"
      redirect_to meetings_path
    end
  end

  private
  def meeting_params
    params.require(:meeting).permit(:title, :start_time, :end_time, :user_id)
  end
end
