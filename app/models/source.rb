class Source < ApplicationRecord
  has_many :connections, dependent: :destroy
end
