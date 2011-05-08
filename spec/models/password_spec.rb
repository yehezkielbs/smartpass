require 'spec_helper'

describe Password do
  before(:each) do
    @password = Password.new(
      :private_password => 'password 1',
      :private_password_confirmation => 'password 1',
      :domain => 'domain 1',
      :username => 'username 1',
      :max_length => '20',
      :use_alphabet => '1',
      :use_number => '1',
      :use_symbol => '1'
    )
  end

  it 'should be valid and have correct attributes' do
    @password.should be_valid
  end

  it 'should have correct attributes' do
    @password.private_password.should == 'password 1'
    @password.private_password_confirmation.should == 'password 1'
    @password.domain.should == 'domain 1'
    @password.username.should == 'username 1'
    @password.use_alphabet.should == '1'
    @password.use_number.should == '1'
    @password.use_symbol.should == '1'
    @password.max_length.should == '20'
  end

  it 'should not be persisted' do
    @password.should_not be_persisted
  end

  it 'should have nil generated_password when it is not generated yet' do
    @password.generated_password.should == nil
  end

  it 'should not be valid without private password' do
    @password.private_password = ''
    @password.should_not be_valid
  end

  it 'should not be valid if private password does not match confirmation' do
    @password.private_password_confirmation = 'different thing'
    @password.should_not be_valid
  end

  it 'should not be valid without domain' do
    @password.domain = ''
    @password.should_not be_valid
  end

  it 'should not be valid if all use_alphabet, use_number and use_symbol are 0' do
    @password.use_alphabet = '0'
    @password.use_number = '0'
    @password.use_symbol = '0'
    @password.should_not be_valid
  end

  it 'should generate password if valid' do
    locksmith = mock(Locksmith)
    Locksmith.should_receive(:new).with(
      'password 1',
      'domain 1',
      'username 1',
      {
        :use_alphabet => true,
        :use_number => true,
        :use_symbol => true,
        :max_length => 20
      }
    ).and_return(locksmith)
    locksmith.should_receive(:generated_password).and_return('the generated password')
    @password.generate_password
    @password.generated_password.should == 'the generated password'
  end

  it 'should not limit the length of generated password if max_length is 0' do
    ['0', 0, nil, ''].each do |max_length_case|
      @password.max_length = max_length_case

      locksmith = mock(Locksmith)
      Locksmith.should_receive(:new).with(
        'password 1',
        'domain 1',
        'username 1',
        {
          :use_alphabet => true,
          :use_number => true,
          :use_symbol => true,
          :max_length => nil
        }
      ).and_return(locksmith)
      locksmith.should_receive(:generated_password).and_return('the generated password')
      @password.generate_password
      @password.generated_password.should == 'the generated password'
    end
  end

  it 'should not generate password if not valid' do
    @password.domain = ''
    @password.generate_password
    @password.generated_password.should == nil
  end
end
