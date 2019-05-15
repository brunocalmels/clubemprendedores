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

require 'test_helper'

class GrupoTest < ActiveSupport::TestCase
  setup do
    @reserva = build(:reserva)
    @user_sin_grupo = create(:user)
    @user_sin_grupo.confirm
    @grupo = create(:grupo, start_times: [0] * 7, end_times: [24] * 7)
    @user_con_grupo = create(:user)
    @user_con_grupo.confirm
    @user_con_grupo.update grupo: @grupo
  end

  test "usuario con grupo puede crear un turno en periodos distintos que uno sin grupo" do
    @hoy = Time.zone.today
    @hora_apertura = Time.zone.parse("#{HORAS_APERTURA[@hoy.wday]}:00:00")
    @hora_ini = @hora_apertura - 1.hour
    @hora_fin = @hora_ini + 2.hours
    @reserva = FactoryBot.build(:reserva, start_time: @hora_ini, end_time: @hora_fin, user: @user_sin_grupo)
    assert_not @reserva.valid?
    @reserva = FactoryBot.build(:reserva, start_time: @hora_ini, end_time: @hora_fin, user: @user_con_grupo)
    assert @reserva.valid?
  end
end
