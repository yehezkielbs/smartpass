module PasswordsHelper
  def error_for object, attribute
    result = ''

    errors = object.errors[attribute]
    if errors && errors.length > 0
      errors = [errors] unless errors.is_a?(Array)
      result = '[ ' + errors.join(', ') + ' ]'
    end

    result
  end
end
