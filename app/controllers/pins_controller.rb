class PinsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_user, :set_pin, except: [:index, :search] 
  def index
    if params[:status].present?
      pins =  Pin.where('? = any (saved)',params[:user_id]).includes(:user).map{|a| a.as_json.merge({user_info:a.user,path:a.get_url})}
    elsif params[:user_id].present?
        user = User.find(params[:user_id])
        pins =  Pin.where('user_id = ? ',user.id).map{|a| a.as_json.merge({user_info:user,path:a.get_url})}
    elsif params[:searchTerm].present?
      pins = Pin.search(params[:searchTerm])
    else
      pins =  Pin.includes(:user).map{|a| a.as_json.merge({user_info:a.user,path:a.get_url})}
    end
    render json: {pins:pins}
    return
  end

  def search
    text = params[:text]
    pins = []
    if(text)
      pins = Pin.search(text)
    end
    render json: {pins:pins}
    return
  end

  def search_by_category
    pins =  Pin.where(category:@current_pin.category).where.not(id:@current_pin.id).includes(:user).map{|a| a.as_json.merge({user_info:a.user,path:a.get_url})}
    render json: {pins:pins}
    return
  end

  def show
    render json: {pin:@current_pin.as_json.merge({user_info:@current_pin.user,path:@current_pin.get_url})}
    return
  end

  def create
    @pin = @current_user.pins.new(pin_params)
    if(@pin.save)
      image = params[:image]
      main_path  ="/"+@current_user.id.to_s+"/"+@pin.id.to_s+"/"
      path = Rails.public_path.to_s+main_path
      FileUtils.mkdir_p (path)
      file_name = image.original_filename.gsub(' ','_')
      path = File.join(path+file_name)
      File.open(path,"wb"){|f| f.write(image.read)}
      @pin.upload_pin(main_path,path,file_name)
      @pin.update(path:"images"+main_path+file_name)
      FileUtils.rm_rf(path)
      render json: "Saved Successfully"
      return
    else

    end
  end
  
  def checked_saved
    saved = @current_pin.saved.include?(@current_user.id)
    render json: {saved:saved}
    return
  end

  def save_pin
   saved =  @current_pin.saved
   if !saved.include?(@current_user.id)
    saved.push(@current_user.id)
    @current_pin.update(saved:saved)
   end
   render json: {saved:saved}
   return
  end

  def destroy
    if @current_pin.user_id == @current_user.id 
      @current_pin.destroy
      render json: {deleted:true}
      return
    end
  end

  def pin_params
    pin = Hash.new
    pin['name']  = params[:title]
    pin['category'] = params[:category]
    pin['about'] = params[:about]
    pin['destination'] = params[:destination]
    pin

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