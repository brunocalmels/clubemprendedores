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

  test "un usuario sin grupo no puede crear una reserva un sábado" do
    sabado = Date.parse('Sat')
    hora_apertura = Time.zone.parse(sabado.to_s).change(hour: HORAS_APERTURA[sabado.wday])
    hora_cierre = Time.zone.parse(sabado.to_s).change(hour: HORAS_CIERRE[sabado.wday])
    reserva = FactoryBot.build(:reserva, start_time: hora_apertura, end_time: hora_cierre)
    assert_not reserva.valid?
  end

  test "un usuario del grupo Adeneu no puede crear una reserva un sábado" do
    adeneu = Grupo.create(nombre: "Adeneu",
                          start_times: HORAS_APERTURA_ADENEU,
                          end_times: HORAS_CIERRE_ADENEU,
                          dias_permitidos: DIAS_PERMITIDOS_ADENEU)
    @user.update grupo: adeneu
    sabado = Date.parse('Sat')
    hora_apertura = Time.zone.parse(sabado.to_s).change(hour: HORAS_APERTURA[sabado.wday])
    hora_cierre = Time.zone.parse(sabado.to_s).change(hour: HORAS_CIERRE[sabado.wday])
    reserva = FactoryBot.build(:reserva, user: @user, start_time: hora_apertura, end_time: hora_cierre)
    assert reserva.valid?
  end
end
