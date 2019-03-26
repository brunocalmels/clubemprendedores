# == Schema Information
#
# Table name: reservas
#
#  id          :bigint(8)        not null, primary key
#  aprobado    :boolean          default(TRUE)
#  bloqueo     :boolean          default(FALSE)
#  descripcion :string
#  end_time    :datetime
#  finalidad   :string
#  nombre      :string
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint(8)
#
# Indexes
#
#  index_reservas_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class ReservaTest < ActiveSupport::TestCase
  setup do
    @reserva = build(:reserva)
    @admin = create(:admin)
    @admin.confirm
    @user = create(:user)
    @user.confirm
    @invitado = {
      nombre: "Jorge",
      apellido: "Perez",
      dni: "321654879",
      email: "algun@email.com"
    }
  end

  test "no se puede crear un turno antes del horario de apertura del dia" do
    @hoy = Time.zone.today
    @hora_apertura = Time.zone.parse("#{HORAS_APERTURA[@hoy.wday]}:00:00")
    @hora_ini = @hora_apertura - 1.hour
    @hora_fin = @hora_ini + 2.hours
    @reserva = FactoryBot.build(:reserva, start_time: @hora_ini, end_time: @hora_fin)
    assert_not @reserva.valid?
  end

  test "no se puede crear un turno despues del horario de cierre del dia" do
    @hoy = Time.zone.today
    @hora_cierre = Time.zone.parse("#{HORAS_CIERRE[@hoy.wday]}:00:00")
    @hora_fin = @hora_cierre + 1.hour
    @hora_ini = @hora_fin - 1.hour
    @reserva = FactoryBot.build(:reserva, start_time: @hora_ini, end_time: @hora_fin)
    assert_not @reserva.valid?
  end

  test "se puede crear un turno en el horario disponible del dia" do
    @hoy = Time.zone.today
    @hora_cierre = Time.zone.parse("#{HORAS_CIERRE[@hoy.wday]}:00:00")
    @hora_apertura = Time.zone.parse("#{HORAS_APERTURA[@hoy.wday]}:00:00")
    @hora_fin = @hora_cierre
    @hora_ini = @hora_apertura
    @reserva = FactoryBot.build(:reserva, start_time: @hora_ini, end_time: @hora_fin)
    assert @reserva.valid?
  end
end
