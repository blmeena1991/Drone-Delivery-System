class BaseService

  attr_reader :errors

  def initialize
    @ran_validation = false
    @errors = []
  end

  def to_mash(context)
    Hashie::Mash.new context
  end

  # This public api can be used to check if service request is valid or not
  def valid?
    validate unless @ran_validation
    @errors.blank?
  end

  # This public api is similar to _valid?_ but forces a fresh run of validations
  def fresh_valid?
    reset_validation_state
    valid?
  end

  # This public api would have the core execution logic and returns a boolean indicating success
  def execute
     valid?      # Validate if the validation is not run.
  end

  # This public api is similar to _execute if there are any validation errors
  def execute!
    raise BatchValidationError.new(@errors), @errors unless execute
    true
  end

  protected

  # This private api can be used to run validation checks
  def validate
    @ran_validation = true
  end

  def error(error)
    if error.instance_of?(Array)
      @errors.concat(error.select{|e| e.instance_of?(String)})
    elsif error.instance_of?(String)
      @errors << error
    end
  end

  private

  def reset_validation_state
    @ran_validation = false
  end
end
