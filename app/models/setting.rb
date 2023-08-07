# == Schema Information
#
# Table name: settings
#
#  id          :bigint           not null, primary key
#  description :string
#  value       :string
#  var         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Setting < ApplicationRecord
end
