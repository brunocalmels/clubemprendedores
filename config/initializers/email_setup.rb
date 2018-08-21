if Rails.env.development?

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'clubemprendedor.herokuapp.com',
  user_name:            ENV["GMAIL_USERNAME"],
  password:             ENV["GMAIL_PASSWORD"],
  authentication:       'plain',
  enable_starttls_auto: true
}

elsif Rails.env.production?

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:              'lxqz-hn2h.accessdomain.com',
  port:                 465,
  domain:               'clubemprendedor.adeneu.com',
  user_name:            ENV["MAIL_ADENEU_USERNAME"],
  password:             ENV["MAIL_ADENEU_PASSWORD"],
  # address:              'smtp.sendgrid.net',
  # port:                 587,
  # domain:               'clubemprendedor.adeneu.com',
  # user_name:            ENV["SENDGRID_USERNAME"],
  # password:             ENV["SENDGRID_PASSWORD"],
  authentication:       'plain',
  enable_starttls_auto: true
}

end
