class AvatarImageUploader < ApplicationUploader
  storage :fog

  process resize_to_fill: [300, 300, "Center"]
  version :message do
    process resize_to_fit: [100, 100]
  end

  def store_dir
    'uploads/avatar_image'
  end
end
