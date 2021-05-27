# frozen_string_literal: true

# == Schema Information
#
# Table name: invitados
#
#  id         :bigint(8)        not null, primary key
#  anonimo    :boolean          default(FALSE)
#  apellido   :string
#  dni        :bigint(8)
#  email      :string
#  nombre     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reserva_id :bigint(8)
#
# Indexes
#
#  index_invitados_on_reserva_id  (reserva_id)
#
# Foreign Keys
#
#  fk_rails_...  (reserva_id => reservas.id)
#

require 'test_helper'

class InvitadoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
