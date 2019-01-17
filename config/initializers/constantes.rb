TIPOS_ID = %w[DNI CUIL CUIT].freeze
FINALIDADES = ["Co-Working", "Eventos/capacitaciones"].freeze
# HORA_APERTURA = 8
# HORA_CIERRE = 19
# DIAS         = [D,  L,  M,  M,  J,  V, S]
HORAS_APERTURA = [0, 8, 8, 8, 8, 8, 0].freeze
HORAS_CIERRE   = [0, 19, 16, 19, 16, 19, 0].freeze

# FRANJAS_HORARIAS = (HORA_APERTURA..(HORA_CIERRE - 1)).map { |p| [p, p + 1] }
MAX_OCUPACIONES = 30
RESERVA_NOMBRE_MIN = 4
RESERVA_NOMBRE_MAX = 40
RESERVA_DESCRIPCION_MIN = 10
RESERVA_DESCRIPCION_MAX = 200
CERRADO = [{
  inicio: Time.zone.parse("2018-12-23"),
  fin: Time.zone.parse("2019-01-01")
}].freeze
