module InicioHelper
  def esta_cerrado?(date)
    CERRADO.each do |cerrado|
      return true if date.between?(cerrado[:inicio], cerrado[:fin])
    end
    false
  end
end
