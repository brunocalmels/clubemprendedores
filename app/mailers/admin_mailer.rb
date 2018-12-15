class AdminMailer < ApplicationMailer
  # Envia un mail a los administradores ante notificaciones
  def email_notificacion
    # admin_emails = User.admins.pluck(:email).join ", "
    # admin_emails = 'brunocalmels@gmail.com'
    to = params[:to] || "brunocalmels@gmail.com, mgrande@adeneu.com.ar"
    subject = params[:subject]
    @text = params[:text]
    @link = params[:link]
    mail(to: to, subject: subject)
  end
end
