# frozen_string_literal: true

# == Schema Information
#
# Table name: grupos
#
#  id              :bigint(8)        not null, primary key
#  dias_permitidos :integer          default([]), is an Array
#  end_times       :integer          default([]), is an Array
#  nombre          :string           not null
#  start_times     :integer          default([]), is an Array
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Grupo < ApplicationRecord
  has_many :users, dependent: :nullify
  validates :nombre, presence: true
end
