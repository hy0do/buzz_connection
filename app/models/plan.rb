class Plan < ApplicationRecord
  has_many :user_plans
  has_many :users, through: :user_plans

  enum status: {
    archived: 0,
    published: 1
  }

  class << self
    def default
      new(id: 0, name: "フリー", price: 0, list_capacity: 5, status: :published)
    end
  end

  def default?
    id.to_i.zero?
  end
end