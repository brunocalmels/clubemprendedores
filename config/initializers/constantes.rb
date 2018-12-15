TIPOS_ID = %w[DNI CUIL CUIT].freeze
FINALIDADES = ["Co-Working", "Eventos/capacitaciones"].freeze
HORA_APERTURA = 8
HORA_CIERRE = 19
FRANJAS_HORARIAS = (HORA_APERTURA..(HORA_CIERRE - 1)).map { |p| [p, p + 1] }
MAX_OCUPACIONES = 30
