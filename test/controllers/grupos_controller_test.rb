require "test_helper"

class GruposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grupo = FactoryBot.create(:grupo)
    @admin = create(:admin)
  end

  test "should not get index" do
    get grupos_url
    assert_redirected_to root_url
  end

  # test "should get index" do
  #   sign_in @admin
  #   get grupos_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_grupo_url
  #   assert_response :success
  # end

  # test "should create grupo" do
  #   assert_difference("Grupo.count") do
  #     post grupos_url, params: { grupo: { end_time: @grupo.end_time, nombre: @grupo.nombre, start_time: @grupo.start_time } }
  #   end

  #   assert_redirected_to grupo_url(Grupo.last)
  # end

  # test "should show grupo" do
  #   get grupo_url(@grupo)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_grupo_url(@grupo)
  #   assert_response :success
  # end

  # test "should update grupo" do
  #   patch grupo_url(@grupo), params: { grupo: { end_time: @grupo.end_time, nombre: @grupo.nombre, start_time: @grupo.start_time } }
  #   assert_redirected_to grupo_url(@grupo)
  # end

  # test "should destroy grupo" do
  #   assert_difference("Grupo.count", -1) do
  #     delete grupo_url(@grupo)
  #   end

  #   assert_redirected_to grupos_url
  # end
end
