class MessagesController < ApplicationController
    def create
      @current_user = current_user
      encrypted_message = current_user.encrypt(params[:room_id], msg_params[:content])
      @message = @current_user.messages.create(content: encrypted_message, room_id: params[:room_id])
    end
  
    private
  
    def msg_params
      params.require(:message).permit(:content)
    end
  end