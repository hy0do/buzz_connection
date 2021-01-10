module ApplicationHelper
  def user_login?
    @current_user.present?
  end

  def user_link_tag(user)
    link_to user_path(user), class: 'user-link' do
      if user.avatar_image.present?
        image_tag user.avatar_image.to_s, class: 'user-image'
      else
        content_tag(:span, '', class: 'user-image blank')
        # user.name
      end
    end
  end

  def current_user
    @current_user
  end

  # turbolinkを無効化したため
  def form_with(**args, &block)
    args[:local] = true
    super(**args, &block)
  end
end
