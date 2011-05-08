class OptionsValidator < ActiveModel::Validator
  def validate record
    if record.use_alphabet.to_i == 0 && record.use_number.to_i == 0 && record.use_symbol.to_i == 0
      record.errors[:use_alphabet] = 'Either one of alphabet, number or symbol must be used'
    end
  end
end

class Password
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :private_password, :domain, :username, :use_alphabet, :use_number, :use_symbol, :max_length
  attr_reader :generated_password

  validates :domain, :presence => true
  validates :private_password, :presence => true, :confirmation => true
  validates_with OptionsValidator

  def persisted?
    false
  end

  def initialize(attributes = {})
    @generated_password = nil
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def generate_password
    if valid?
      locksmith = Locksmith.new(
        private_password,
        domain,
        username,
        {
          :use_alphabet => use_alphabet.to_i == 1,
          :use_number => use_number.to_i == 1,
          :use_symbol => use_symbol.to_i == 1,
          :max_length => max_length.to_i == 0 ? nil : max_length.to_i
        }
      )
      @generated_password = locksmith.generated_password
    end
  end
end

