class UsersController < ApplicationController

    def index

    end

    def new 
        @current_user =  User.find_by(google_id: params[:googleId])
        if @current_user.present?
            session[:user_id]=@current_user.id
            render json: "already exist"
            return
        else
            @current_user =  User.new(user_params)
            @current_user.save
            session[:user_id]=@current_user.id
            render json: "New created"
            return
        end
    end

    def show
        if (params[:google_id].present?)
            @current_user =  User.find_by(google_id: params[:google_id])
        elsif params[:userId].present?
            @current_user =  User.find(params[:userId])
        end
        render json: {user:@current_user}
    end
    private
    def user_params
        data = Hash.new
        data['google_id'] = params[:googleId]
        data['name'] = params[:name]
        data['image_url'] = params[:imageUrl]
        data

    end
end
