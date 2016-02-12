module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success" # Green
      when :error
        "alert-danger" # Red
      when :alert
        "alert-warning" # Yellow
      when :notice
        "alert-info" # Blue
      else
        flash_type.to_s
    end
  end

  def self_removing(notice)
    # This is a hack to get the devise messages to disappear on their own after a little while. If it is a normal
    # devise message, then we add a class.
    if notice == t("devise.sessions.signed_in") || notice == t("devise.sessions.signed_out")
      return "self_removing"
    end
      return ""
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.env["HTTP_USER_AGENT"] =~ /Mobile|webOS/
    end
    false
  end
end
