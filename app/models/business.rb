class Business < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture, required: false

  has_many :business_demand_elements
  has_many :business_supply_elements

  accepts_nested_attributes_for :business_demand_elements, allow_destroy: true
  accepts_nested_attributes_for :business_supply_elements, allow_destroy: true

  before_create :reset_code

  enum status: {
    secret: 0,
    published: 1
  }

  with_options if: :published? do
    validates :title, presence: true
    validates :detail, presence: true
  end

  delegate :name, to: :prefecture, prefix: true, allow_nil: true
  mount_uploader :image, CoverImageUploader

  def splited_code
    uuid.scan(/(.{4})(.{4})(.{4})(.{4})/)[0].join("-")
  end

  # override
  def to_param
    code
  end

  private

  def reset_code
    self.code = SecureRandom.hex(8).upcase
  end
end
