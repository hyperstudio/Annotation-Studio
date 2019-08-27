if Rails.env.to_s != 'development'
	AnnotationStudio::Application.config.middleware.use ExceptionNotification::Rack,
		:email => {
		  :email_prefix => ENV['EXCEPTION_PREFIX'],
		  :sender_address => ENV['EXCEPTION_SENDER'],
		  :exception_recipients => ENV['EXCEPTION_RECIPIENTS'].split(' ')
		}
end
