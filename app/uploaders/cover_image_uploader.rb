class CoverImageUploader < ApplicationUploader
  storage :fog

  process resize_to_fill: [768, 432, "Center"]

  version :thumbnail do
    process resize_to_fill: [240, 180, "Center"]
  end

  

  def store_dir
    'uploads/cover_image'
  end
end
