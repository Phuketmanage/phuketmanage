module LogsHelper
  def format_roles(role)
    text = ""
    role.each do |role|
      text += "#{role.capitalize}<br>\n"
    end
    text.html_safe
  end

  def format_logs(logs)
    text = ""
    logs.each do |key, value|
      text += "<b>#{key.capitalize}:</b> #{value}<br>\n"
    end
    text.html_safe
  end
end
