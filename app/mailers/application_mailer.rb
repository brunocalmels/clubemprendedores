class ApplicationMailer < ActionMailer::Base
  # include Roadie::Rails::Automatic

  default from: 'no-reply-club@adeneu.com.ar'
  layout 'mailer'
end
