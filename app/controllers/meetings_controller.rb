class MeetingsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      meeting = Meeting.all
    else
      meeting = current_user.meetings
    end
    @meetings = meeting.order('start_time')
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
    card_brand = params[:payment_card][:card_brand]
    card_exp_month = params[:payment_card][:card_exp_month]
    card_exp_year = params[:payment_card][:card_exp_year]
    card_last4 = params[:payment_card][:card_last4]
    Stripe.api_key = Rails.application.secrets.stripe_api_key

    charge = Stripe::Charge.create(
      amount: 50000,
      currency: "inr",
      description: "Meeting charges",
      source: token
    )

    card = PaymentCard.find_or_initialize_by(card_last4: params[:payment_card][:card_last4])
    card.user_id = @meeting.user_id
    card.stripe_id = charge.id
    card.card_brand = card_brand
    card.card_exp_month = card_exp_month
    card.card_exp_year = card_exp_year
    card.card_last4 = card_last4
    # card.save!

    if @meeting.save && card.save
      message = "Hey, you have booked #{@meeting.title} meeting. The meeting is at #{@meeting.start_time.strftime("%I:%M%p")} on #{@meeting.start_time.to_date} date"
      TwilioClient.new.send_text(@meeting.user, message)
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
