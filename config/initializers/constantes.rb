TIPOS_ID = %w[DNI CUIL CUIT].freeze
FINALIDADES = ["Co-Working", "Evento/capacitación/reunión"].freeze

# DIAS                 = [ D,  L,  M,  M,  J,  V,  S]
HORAS_APERTURA         = [0, 8, 8, 8, 8, 8, 8].freeze
HORAS_CIERRE           = [24, 19, 16, 19, 16, 19, 14].freeze
HORAS_APERTURA_ADENEU  = [0, 8, 8, 8, 8, 8, 8].freeze
HORAS_CIERRE_ADENEU    = [24, 20, 20, 20, 20, 20, 17].freeze
DIAS_PERMITIDOS        = [0,  1,  1,  1,  1,  1,  0].freeze
DIAS_PERMITIDOS_ADENEU = [0,  1,  1,  1,  1,  1,  1].freeze

MAX_OCUPACIONES = 30
RESERVA_NOMBRE_MIN = 4
RESERVA_NOMBRE_MAX = 40
RESERVA_DESCRIPCION_MIN = 10
RESERVA_DESCRIPCION_MAX = 200
CERRADO = [{
  inicio: Time.zone.parse("2018-12-23"),
  fin: Time.zone.parse("2019-01-01")
}].freeze
