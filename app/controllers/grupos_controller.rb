# frozen_string_literal: true

class GruposController < ApplicationController
  before_action :set_grupo, only: %i[show edit update add_user]
  before_action :assure_admin!
  skip_before_action :verify_authenticity_token, only: %i[add_user]

  # GET /grupos
  # GET /grupos.json
  def index
    @grupos = policy_scope(Grupo.all)
  end

  # # GET /grupos/1
  # # GET /grupos/1.json
  # def show
  # end

  # # GET /grupos/new
  # def new
  #   @grupo = Grupo.new
  # end

  # GET /grupos/1/edit
  def edit
    @usuarios = User.where(grupo: @grupo).all.map(&:nombre_completo)
    @otros_usuarios = User.where.not(grupo: @grupo).or(User.where(grupo: [nil, '']))
  end

  # # POST /grupos
  # # POST /grupos.json
  # def create
  #   @grupo = Grupo.new(grupo_params)

  #   respond_to do |format|
  #     if @grupo.save
  #       format.html { redirect_to @grupo, notice: 'Grupo creado  satisfactoriamente.' }
  #       format.json { render :show, status: :created, location: @grupo }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @grupo.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /grupos/:id/add_user/:user_id
  def add_user
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @user.update grupo: @grupo
        format.html { redirect_to edit_grupo_path(@grupo), notice: 'Usuario añadido.' }
      else
        format.html { render :edit }
      end
    end
  end

  # PATCH/PUT /grupos/1
  def update
    respond_to do |format|
      @grupo.nombre = params[:grupo][:nombre]
      grup = params.require(:grupo)
      @grupo.dias_permitidos = grup.require(:dias_permitidos).values
      @grupo.start_times = grup.require(:start_times).values
      @grupo.end_times = grup.require(:end_times).values
      if @grupo.save
        format.html { redirect_to grupos_path, notice: 'Grupo actualizado satisfactoriamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  # # DELETE /grupos/1
  # # DELETE /grupos/1.json
  # def destroy
  #   @grupo.destroy
  #   respond_to do |format|
  #     format.html { redirect_to grupos_url, notice: 'Grupo fue destroyed satisfactoriamente.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grupo
    @grupo = Grupo.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def grupo_params
  #   params.require(:grupo).permit(:nombre, start_times: [], end_times: [], dias_permitidos: [])
  # end
end
