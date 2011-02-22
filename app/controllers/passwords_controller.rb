class PasswordsController < ApplicationController
  def new
    @password = Password.new(:use_alphabet => 1, :use_number => 1, :use_symbol => 1)
  end

  def create
    @password = Password.new(params[:password])
    @password.generate_password if @password.valid?
    render(:action => 'new')
  end
end
