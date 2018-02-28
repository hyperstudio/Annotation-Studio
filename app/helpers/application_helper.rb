module ApplicationHelper

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
          concat content_tag(:span, 'Close', class: 'sr-only')
        end)
        concat message
      end)
    end
    nil
  end

  def render_brand
    if ENV['BRAND_RIBBON'] != ""
      render partial: ENV['BRAND_RIBBON']
    else
      render partial: "shared/default_brand"
    end
  end

  def home_banner
    if ENV['HOME_BANNER'] != ""
      return ENV['HOME_BANNER']
    else
      return "home.png"
    end
  end

  def render_footer
    if ENV['FOOTER'] != ""
      render partial: ENV['FOOTER']
    else
      render partial: "shared/default_footer"
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
