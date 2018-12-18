require "test_helper"

class ReservasControllerTest < ActionDispatch::IntegrationTest
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

  test "should get new" do
    sign_in @admin
    get new_reserva_url
    assert_response :success
  end

  test "un usuario puede crear una capacitación con invitados anónimos" do
    sign_in @user
    assert_difference("Reserva.count", 1) do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion }, invitados_anon: 10 }, as: @user
    end
    assert_response :redirect
  end

  test "se puede crear reservas con invitados y después repetirlos en otra reserva" do
    sign_in @user
    @invitados = {}
    [MAX_OCUPACIONES - 1, 3].min.times do |i|
      @invitados[i.to_s] = @invitado
    end
    @start_time = Time.zone.parse("#{HORA_APERTURA + 1}:00:00")
    assert_difference("Reserva.count", 1) do
      post reservas_url, params: { reserva: { end_time: @start_time + 1.hour, start_time: @start_time, finalidad: "Co-Working", invitados_attributes: @invitados } }, as: @user
    end
    assert_response :redirect

    @reserva_repe = assigns :reserva
    assert_difference("Reserva.count", 1) do
      post reservas_url, params: { reserva: { end_time: @start_time + 3.hours, start_time: @start_time + 2.hours, finalidad: "Co-Working" }, invitados_grupo_reserva_id: @reserva_repe.id }, as: @user
    end
    assert_response :redirect
    @reserva2 = assigns :reserva
    # Chequea que los invitados sean iguales en todos sus atributos (aunque no en ids)
    @reserva2.invitados.each do |invitado|
      assert @reserva_repe.invitados.where(nombre: invitado.nombre, apellido: invitado.apellido, email: invitado.email, dni: invitado.dni).count > 0
    end
  end

  test "no se puede hacer una reserva si se juntan más de #{MAX_OCUPACIONES} personas (coinciden exactamente)" do
    @reserva = create(:reserva, user: @admin, start_time: Time.zone.now.middle_of_day, end_time: Time.zone.now.middle_of_day + 3.hours)
    MAX_OCUPACIONES.times do |i|
      @reserva.invitados.create(nombre: "Invitado", apellido: i.to_s)
    end
    sign_in @user

    # Tiempos idénticos
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time, finalidad: FINALIDADES.sample } }, as: @admin
    end
    assert_response :unprocessable_entity

    # Solapa por izquierda
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time - 1.hour, finalidad: FINALIDADES.sample } }, as: @admin
    end
    assert_response :unprocessable_entity

    # Solapa por derecha
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time + 2.hours, start_time: @reserva.start_time, finalidad: FINALIDADES.sample } }, as: @admin
    end
    assert_response :unprocessable_entity

    # Contiene
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time + 1.hour, start_time: @reserva.start_time - 2.hours, finalidad: FINALIDADES.sample } }, as: @admin
    end
    assert_response :unprocessable_entity

    # Es contenido
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time - 1.hour, start_time: @reserva.start_time + 1.hour, finalidad: FINALIDADES.sample } }, as: @admin
    end
    assert_response :unprocessable_entity
  end

  test "se crea una reserva con invitaciones anónimas" do
    sign_in @admin
    assert_difference("Reserva.count", 1) do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion }, invitados_anon: 10 }, as: @admin
    end
    assert_response :redirect
  end

  test "no puede haber más ocupaciones anónimas que las máximas" do
    sign_in @admin
    assert_difference("Reserva.count") do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion }, invitados_anon: MAX_OCUPACIONES + 1 }, as: @admin
    end
    assert_response :redirect
    # @reserva_creada = assigns :reserva
    # assert_equal MAX_OCUPACIONES, reserva.invitados.count
  end

  test "no se puede reservas con más ocupaciones que las máximas" do
    sign_in @user
    @invitados = {}
    (MAX_OCUPACIONES + 1).times do |i|
      @invitados[i.to_s] = @invitado
    end
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { end_time: @reserva.end_time, start_time: @reserva.start_time, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion, invitados_attributes: @invitados } }, as: @user
    end
    assert_response :unprocessable_entity
  end

  test "no se puede editar un turno para que tenga más invitados que los max" do
    sign_in @user
    @reserva = create(:reserva, user: @user)
    @invitados = {}
    (MAX_OCUPACIONES + 1).times do |i|
      @invitados[i.to_s] = @invitado
    end
    assert_no_difference("@reserva.invitados.count") do
      patch reserva_url(@reserva), params: { reserva: { invitados_attributes: @invitados } }
    end
    assert_response :unprocessable_entity
  end

  test "no se puede crear un turno que se pise con uno bloqueante" do
    sign_in @user
    comienzo_bloq = Time.zone.now.middle_of_day
    fin_bloq = comienzo_bloq + 4.hours
    create(:reserva_bloqueante, start_time: comienzo_bloq, end_time: fin_bloq, user: @admin, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion)

    # Pasa porque se hace antes
    comienzo = comienzo_bloq - 3.hours
    fin = comienzo + 2.hours
    assert_difference("Reserva.count", 1) do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion } }, as: @user
    end
    assert_response :redirect

    # Pasa porque se hace después
    comienzo = fin_bloq + 1.hour
    fin = comienzo + 1.hour
    assert_difference("Reserva.count", 1) do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion } }, as: @user
    end
    assert_response :redirect

    # Exactamente la misma hora
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { start_time: comienzo_bloq, end_time: fin_bloq, user: @user, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion } }, as: @user
    end
    assert_response :unprocessable_entity

    # Empieza antes y termina en el medio
    comienzo = comienzo_bloq - 1.hour
    fin = comienzo + 2.hours
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion } }, as: @user
    end
    assert_response :unprocessable_entity

    # Empieza y termina en el medio
    comienzo = comienzo_bloq + 1.hour
    fin = comienzo + 1.hour
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion } }, as: @user
    end
    assert_response :unprocessable_entity

    # Empieza en el medio y termina después
    comienzo = comienzo_bloq + 1.hour
    fin = comienzo + 4.hours
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion } }, as: @user
    end
    assert_response :unprocessable_entity

    # Empieza en el medio y termina justo igual
    comienzo = comienzo_bloq + 1.hour
    fin = fin_bloq
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion } }, as: @user
    end
    assert_response :unprocessable_entity

    # Empieza justo igual y termina en el medio
    comienzo = comienzo_bloq
    fin = comienzo + 1.hour
    assert_no_difference("Reserva.count") do
      post reservas_url, params: { reserva: { start_time: comienzo, end_time: fin, user: @user, finalidad: FINALIDADES.sample, nombre: @reserva.nombre, descripcion: @reserva.descripcion } }, as: @user
    end
    assert_response :unprocessable_entity
  end
end
