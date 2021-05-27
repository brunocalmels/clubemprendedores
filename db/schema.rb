# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_190_515_113_550) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'grupos', force: :cascade do |t|
    t.string 'nombre', null: false
    t.integer 'start_times', default: [], array: true
    t.integer 'end_times', default: [], array: true
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'dias_permitidos', default: [], array: true
  end

  create_table 'invitados', force: :cascade do |t|
    t.string 'nombre'
    t.string 'apellido'
    t.bigint 'dni'
    t.string 'email'
    t.bigint 'reserva_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'anonimo', default: false
    t.index ['reserva_id'], name: 'index_invitados_on_reserva_id'
  end

  create_table 'reservas', force: :cascade do |t|
    t.datetime 'end_time'
    t.datetime 'start_time'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'user_id'
    t.boolean 'bloqueo', default: false
    t.string 'finalidad'
    t.boolean 'aprobado', default: true
    t.string 'nombre'
    t.string 'descripcion'
    t.index ['user_id'], name: 'index_reservas_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.inet 'current_sign_in_ip'
    t.inet 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'nombre'
    t.string 'apellido'
    t.integer 'id_tipo', limit: 2
    t.bigint 'id_num'
    t.bigint 'telefono'
    t.string 'institucion'
    t.boolean 'admin', default: false
    t.bigint 'grupo_id'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['grupo_id'], name: 'index_users_on_grupo_id'
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'invitados', 'reservas'
  add_foreign_key 'reservas', 'users'
  add_foreign_key 'users', 'grupos'
end
