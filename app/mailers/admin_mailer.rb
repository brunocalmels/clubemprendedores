class AdminMailer < ApplicationMailer

  # Envía un mail a los administradores ante notificaciones
  def email_notificacion
    # admin_emails = User.admins.pluck(:email).join ", "
    # admin_emails = 'brunocalmels@gmail.com'
    admin_emails = 'brunocalmels@gmail.com, mgrande@cpymeadeneu.com.ar'
    subject = params[:subject]
    @text = params[:text]
    @link = params[:link]
    mail(to: admin_emails, subject: subject)
  end
end
