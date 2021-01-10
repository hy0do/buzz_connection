class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :image_url

  def image_url
    object.avatar_image.message.url
  end
end
