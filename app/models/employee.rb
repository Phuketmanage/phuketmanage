class Employee < ApplicationRecord
  belongs_to :type, class_name: 'EmplType'
  has_and_belongs_to_many :houses
end
