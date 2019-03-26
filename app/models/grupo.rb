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

class Grupo < ApplicationRecord
  validates :nombre, presence: true
end
