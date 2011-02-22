require 'spec_helper'

describe PasswordsHelper do
  it 'display the error in a way I want' do
    object = mock('any model')
    errors = {:attribute => ['error 1', 'error 2']}
    object.should_receive(:errors).and_return(errors)
    helper.error_for(object, :attribute).should == '[ error 1, error 2 ]'
  end
end
