class DownloadMailer < ApplicationMailer
  def new_download_email
    @download_url = params[:download_url]
    user_email = params[:user_email]

    mail(to: user_email, subject: I18n.t('new_file'))
  end

  def new_error_email
    user_email = params[:user_email]

    mail(to: user_email, subject: I18n.t('error_with_file'))
  end
end
