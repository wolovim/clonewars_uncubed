class Email # uses Pony gem to configure and send email for contact-us
  def initialize(params)
    Pony.mail(
        :to      => "clonewars.uncubed@gmail.com",
        :from    => "Name: #{params[:firstname]} #{params[:lastname]}, Email: #{params[:email]}",
        :subject => "Subject: #{params[:subject]}",
        :body    => "#{params[:message]}"
        )
  end
end