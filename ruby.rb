def save_registration_input
  if @temp_user
    if @temp_user.weight_pounds
      @temp_user.target_weight_pounds = self.body
      @user = User.create(name: @temp_user.name, phone_number: @temp_user.phone_number, age: @temp_user.age, weight_pounds: @temp_user.weight_pounds, height_inches: @temp_user.height_inches, target_weight_pounds: @temp_user.target_weight_pounds, sex: @temp_user.sex)
      @temp_user.destroy
      @temp_user = nil
      message = "Your profile has been created"
    elsif @temp_user.height_inches
      @temp_user.weight_pounds = self.body
      message = "What is your target weight?"
    elsif @temp_user.sex
      @temp_user.height_inches = self.body
      message = "What is your current weight?"
    elsif @temp_user.age
      @temp_user.sex = self.body
      message = "How tall are you in inches?"
    elsif @temp_user.name
      @temp_user.age = self.body
      message = "What is your sex?"
    elsif @temp_user
      @temp_user.name = self.body
      message = "How old are you?"
    end
    @temp_user.save if @temp_user
  else
    @temp_user = TempUser.create(phone_number: self.phone_number)
    message = "Hey There!\nWhat is your name?\nYou can also say 'reset' or 'start over' at anytime to restart."
  end
end