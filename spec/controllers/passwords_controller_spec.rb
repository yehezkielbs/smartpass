require 'spec_helper'

describe PasswordsController do
  it 'should display new password form' do
    password = mock_model(Password)
    Password.should_receive(:new).with(:use_alphabet => 1, :use_number => 1, :use_symbol => 1).and_return(password)

    get('new')

    response.should render_template('new')
    assigns['password'].should == password
  end

  it 'should create new password' do
    password_parameters = mock('password parameters')
    password = mock_model(Password)

    Password.should_receive(:new).with(password_parameters).and_return(password)
    password.should_receive(:valid?).and_return(true)
    password.should_receive(:generate_password)

    post('create', :password => password_parameters)

    response.should render_template('new')
    assigns['password'].should == password
  end
end
