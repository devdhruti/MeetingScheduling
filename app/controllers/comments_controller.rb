class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    comment = Comment.new(comment_params)
    meeting = Meeting.find(params[:comment][:meeting_id].to_i)
    if comment.save
      flash[:notice] = "Comments added successfully!"
      redirect_to meeting_path(meeting)
    else
      flash[:alert] = "Error adding Comments!"
      redirect_to meeting_path(meeting)
    end
  end


  def destroy
    comment = Comment.find(params[:id])
    meeting = Meeting.find(comment.meeting_id)
    if comment.destroy
      flash[:notice] = "Successfully deleted comment!"
      redirect_to meeting_path(meeting)
    else
      flash[:alert] = "Error deleting comment!"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:comment, :user_id, :meeting_id)
  end
end
