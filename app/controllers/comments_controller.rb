class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_user, :set_pin

  before_action :find_commentable, only: :create
  
  def index
    comments = @current_pin.comments.includes(:user).map{|c| c.as_json.merge({posted_by:c.user})}
    render json: {comments:comments}
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.update(user_id:@current_user.id)
    @comment.save
    render json: {comment:@comment.as_json.merge({posted_by:@current_user})}

  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_commentable
    if params[:comment_id]
      @commentable = Comment.find_by_id(params[:comment_id]) 
    elsif params[:pin_id]
      @commentable = Pin.find_by_id(params[:pin_id])
    end
  end
  
  def set_pin 
    if(params[:pin_id].present?)
      @current_pin =  Pin.find(params[:pin_id])
    end
  end

  def set_user
    @current_user =  User.find_by(google_id: params[:googleId])

  end 
end
  