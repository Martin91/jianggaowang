class UserPasswordMailer < ActionMailer::Base
  default from: "jianggaowang@163.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_password.reset_password.subject
  #
  def reset_password(receiver)
    mail to: 'hongzeqin@gmail.com'
  end
end
