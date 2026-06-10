module ApplicationHelper
  def user_avatar(user, **options)
    default_classes = "h-full w-full object-cover"
    css_class = [ default_classes, options.delete(:class) ].compact.join(" ")

    if user.profile&.avatar&.attached?
      image_tag user.profile.avatar.variant(resize_to_limit: [ 200, 200 ]), **options.merge(class: css_class)
    else
      image_tag "user/owner.jpg", **options.merge(class: css_class, alt: options[:alt] || "Usuário")
    end
  end
end
