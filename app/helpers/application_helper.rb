module ApplicationHelper
  def image_tag_s3(file, options = {})
    image_tag("https://phuketmanage.s3.amazonaws.com/images/#{file}", options)
  end

  def full_title(page_title = '')
    base_title = "Phuket Manage - #{t('app.tagline')}"
    full_title = "Phuket Manage"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{full_title}"
    end
  end

  def root_locale
    if I18n.locale == :en
      nil
    else
      I18n.locale
    end
  end

  def active_link(link_path)
    "active" if current_page?(link_path)
  end
end
