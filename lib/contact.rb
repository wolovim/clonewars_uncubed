class Email
  def initialize(params)
    Pony.mail(
        :to      => "clonewars.uncubed@gmail.com",
        :from    => "Name: #{params[:firstname]} #{params[:lastname]}, Email: #{params[:email]}",
        :subject => "Subject: #{params[:subject]}",
        :body    => "#{params[:message]}"
        )
  end
end