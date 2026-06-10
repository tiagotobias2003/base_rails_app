class Profile < ApplicationRecord
  BRAZILIAN_STATES = %w[
    AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO
  ].freeze

  belongs_to :user

  has_one_attached :avatar

  validates :user, uniqueness: true

  enum :gender, {
    male: 0,
    female: 1,
    other: 2,
    prefer_not_to_say: 3
  }, validate: true

  enum :marital_status, {
    single: 0,
    married: 1,
    divorced: 2,
    widowed: 3,
    domestic_partnership: 4
  }, validate: true

  before_validation :normalize_document_fields

  validates :full_name, :cpf, :birth_date, :gender, :marital_status, :mobile_phone,
            :mother_name, :cep, :street, :number, :neighborhood, :city, :state,
            presence: true
  validates :cpf, uniqueness: true, cpf: true
  validates :state, inclusion: { in: BRAZILIAN_STATES }
  validates :cep, format: { with: /\A\d{8}\z/, message: "deve conter 8 dígitos" }
  validates :mobile_phone, format: { with: /\A\d{10,11}\z/, message: "deve conter 10 ou 11 dígitos" }
  validates :phone, format: { with: /\A\d{10,11}\z/, message: "deve conter 10 ou 11 dígitos" }, allow_blank: true
  validate :acceptable_avatar
  validate :birth_date_in_the_past

  def formatted_cpf
    return if cpf.blank?

    cpf.gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4')
  end

  def formatted_cep
    return if cep.blank?

    cep.gsub(/(\d{5})(\d{3})/, '\1-\2')
  end

  private

  def normalize_document_fields
    self.cpf = cpf.to_s.gsub(/\D/, "") if cpf.present?
    self.cep = cep.to_s.gsub(/\D/, "") if cep.present?
    self.phone = phone.to_s.gsub(/\D/, "") if phone.present?
    self.mobile_phone = mobile_phone.to_s.gsub(/\D/, "") if mobile_phone.present?
    self.nationality = "Brasileira" if nationality.blank?
  end

  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.blob.content_type.in?(%w[image/png image/jpeg image/gif image/webp])
      errors.add(:avatar, "deve ser PNG, JPEG, GIF ou WebP")
    end

    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, "deve ter menos de 5 MB")
    end
  end

  def birth_date_in_the_past
    return if birth_date.blank?
    return if birth_date < Date.current

    errors.add(:birth_date, "deve ser anterior à data atual")
  end
end
