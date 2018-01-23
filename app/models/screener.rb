class Screener < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, allow_blank: false

end
