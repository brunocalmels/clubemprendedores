require 'test_helper'

class ReservasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reserva = build(:reserva)
    @admin = create(:admin)
    @user = create(:user)
    @invitado = {
      nombre: 'Jorge',
      apellido: 'Perez',
      dni: '321654879',
      email: 'algun@email.com'
    }
  end

  test "should get new" do
    sign_in @admin
    get new_reserva_url
    assert_response :success
  end


  test "se puede crear reservas con invitados y después repetirlos en otra reserva" do
    sign_in @user
    @invitados = Hash.new
    [MAX_OCUPACIONES-1, 3].min.times do |i|
      @invitados[i.to_s] = @invitado
    end
    assert_difference('Reserva.count', 1) do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time, finalidad: FINALIDADES.sample, invitados_attributes: @invitados } }, as: @user
    end
    assert_response :redirect

    @reserva_repe = assigns :reserva
    assert_difference('Reserva.count', 1) do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time + 3.hours, start_time: @reserva.start_time + 3.hours, finalidad: FINALIDADES.sample }, invitados_grupo_reserva_id: @reserva_repe.id }, as: @user
    end
    assert_response :redirect
    @reserva2 = assigns :reserva
    # Chequea que los invitados sean iguales en todos sus atributos (aunque no en ids)
    @reserva2.invitados.each do |invitado|
      assert @reserva_repe.invitados.where(nombre: invitado.nombre, apellido: invitado.apellido, email: invitado.email, dni: invitado.dni).count > 0
    end

  end

  test "no se puede hacer una reserva si se juntan más de #{MAX_OCUPACIONES} personas (coinciden exactamente)" do
    @reserva = create(:reserva, user: @admin, start_time: DateTime.now.middle_of_day, end_time: DateTime.now.middle_of_day + 3.hours)
    MAX_OCUPACIONES.times do |i|
      @reserva.invitados.create(nombre: "Invitado #{i}")
    end
    sign_in @user

    # Tiempos idénticos
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time, finalidad: FINALIDADES.sample } }, as: @admin
    end
    assert_response :unprocessable_entity

    # Solapa por izquierda
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time - 1.hour, finalidad: FINALIDADES.sample } }, as: @admin
    end
    assert_response :unprocessable_entity

    # Solapa por derecha
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time + 2.hours, start_time: @reserva.start_time, finalidad: FINALIDADES.sample } }, as: @admin
    end
    assert_response :unprocessable_entity

    # Contiene
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time + 1.hour, start_time: @reserva.start_time - 2.hours, finalidad: FINALIDADES.sample } }, as: @admin
    end
    assert_response :unprocessable_entity

    # Es contenido
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time - 1.hour, start_time: @reserva.start_time + 1.hour, finalidad: FINALIDADES.sample } }, as: @admin
    end
    assert_response :unprocessable_entity
  end

  test "se crea una reserva con invitaciones anónimas" do
    sign_in @admin
    assert_difference('Reserva.count', 1) do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time, finalidad: FINALIDADES.sample }, invitados_anon: 10 }, as: @admin
    end
    assert_response :redirect
  end

  test "no puede haber más ocupaciones anónimas que las máximas" do
    sign_in @admin
    assert_difference('Reserva.count') do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time, finalidad: FINALIDADES.sample }, invitados_anon: MAX_OCUPACIONES + 1 }, as: @admin
    end
    assert_response :redirect
  end

  test "no se puede reservas con más ocupaciones que las máximas" do
    sign_in @user
    @invitados = Hash.new
    (MAX_OCUPACIONES+1).times do |i|
      @invitados[i.to_s] = @invitado
    end
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time, finalidad: FINALIDADES.sample, invitados_attributes: @invitados  } }, as: @user
    end
    assert_response :unprocessable_entity
  end

  test "no se puede editar un turno para que tenga más invitados que los max" do
    sign_in @user
    @reserva = create(:reserva, user: @user)
    @invitados = Hash.new
    (MAX_OCUPACIONES+1).times do |i|
      @invitados[i.to_s] = @invitado
    end
    assert_no_difference('@reserva.invitados.count') do
      patch reserva_url(@reserva), params: { reserva: { invitados_attributes: @invitados } }
    end
    assert_response :unprocessable_entity
  end

  test "no se puede crear un turno que se pise con uno bloqueante" do
    sign_in @user
    comienzo_bloq = DateTime.now.middle_of_day
    fin_bloq = comienzo_bloq + 4.hour
    create(:reserva_bloqueante, start_time: comienzo_bloq, end_time: fin_bloq, user: @admin)

    # Pasa porque se hace antes
    comienzo = comienzo_bloq - 3.hour
    fin = comienzo + 2.hour
    assert_difference('Reserva.count', 1) do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample } }
    end
    assert_response :redirect

    # Pasa porque se hace después
    comienzo = fin_bloq + 1.hour
    fin = comienzo + 1.hour
    assert_difference('Reserva.count', 1) do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample } }
    end
    assert_response :redirect

    # Exactamente la misma hora
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { start_time: comienzo_bloq, end_time: fin_bloq, user: @user, finalidad: FINALIDADES.sample } }
    end
    assert_response :unprocessable_entity

    # Empieza antes y termina en el medio
    comienzo = comienzo_bloq - 1.hour
    fin = comienzo + 2.hour
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample } }
    end
    assert_response :unprocessable_entity

    # Empieza y termina en el medio
    comienzo = comienzo_bloq + 1.hour
    fin = comienzo + 1.hour
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample } }
    end
    assert_response :unprocessable_entity

    # Empieza en el medio y termina después
    comienzo = comienzo_bloq + 1.hour
    fin = comienzo + 4.hour
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample } }
    end
    assert_response :unprocessable_entity

    # Empieza en el medio y termina justo igual
    comienzo = comienzo_bloq + 1.hour
    fin = fin_bloq
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample } }
    end
    assert_response :unprocessable_entity

    # Empieza justo igual y termina en el medio
    comienzo = comienzo_bloq
    fin = comienzo + 1.hour
    assert_no_difference('Reserva.count') do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample } }
    end
    assert_response :unprocessable_entity
  end

  #
  # test "should create reserva" do
  #   assert_difference('Reserva.count') do
  #     post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time } }, as: @admin
  #   end
  #
  #   assert_redirected_to reserva_url(Reserva.last)
  # end
  #
  # test "should show reserva" do
  #   get reserva_url(@reserva)
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get edit_reserva_url(@reserva)
  #   assert_response :success
  # end
  #
  # test "should update reserva" do
  #   patch reserva_url(@reserva), params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time } }
  #   assert_redirected_to reserva_url(@reserva)
  # end
  #
  # test "should destroy reserva" do
  #   assert_difference('Reserva.count', -1) do
  #     delete reserva_url(@reserva)
  #   end
  #
  #   assert_redirected_to reservas_url
  # end
end
