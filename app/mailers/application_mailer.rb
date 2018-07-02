class ApplicationMailer < ActionMailer::Base
  # include Roadie::Rails::Automatic

  default from: 'hubemprendedor@gmail.com'
  layout 'mailer'
end
