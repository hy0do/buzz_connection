class BusinessSupplyElement < ApplicationRecord
  belongs_to :business
  belongs_to :industry
  belongs_to :occupation

  delegate :name, to: :occupation, prefix: true
  delegate :name, to: :industry, prefix: true
end
