class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :admins, -> { where(admin: true) }

  has_many :reservas, dependent: :destroy

  validates :nombre, presence: true
  validates :apellido, presence: true
  validates :id_tipo, presence: true, numericality: { inclusion: [0..2] }
  validates :id_num, presence: true
  validates :institucion, presence: true

  def nombre_completo
    nombre + " " + apellido
  end

end
