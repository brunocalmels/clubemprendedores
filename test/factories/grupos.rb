# == Schema Information
#
# Table name: grupos
#
#  id          :bigint(8)        not null, primary key
#  end_times   :integer          default([]), is an Array
#  nombre      :string           not null
#  start_times :integer          default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :grupo do
    nombre "MyString"
    start_times "2019-03-26 16:50:00"
    end_times "2019-03-26 16:50:00"
  end
end
