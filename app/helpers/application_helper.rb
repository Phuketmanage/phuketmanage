module ApplicationHelper

  def full_title(page_title = '')
    base_title = "Phuket Manage - #{t('app.tagline')}"
    full_title = "Phuket Manage"
    if page_title.empty?
      base_title
    else
      page_title + " | " + full_title
    end
  end

end
