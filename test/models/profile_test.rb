require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "perfil@example.com",
      password: "12345678",
      password_confirmation: "12345678",
      confirmed_at: Time.current
    )
    @profile = @user.build_profile(valid_profile_attributes)
  end

  test "is valid with complete brazilian personal data" do
    assert @profile.valid?
  end

  test "requires unique cpf" do
  another_user = User.create!(
      email: "outro@example.com",
      password: "12345678",
      password_confirmation: "12345678",
      confirmed_at: Time.current
    )
    @profile.save!
    duplicate = another_user.build_profile(valid_profile_attributes)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:cpf], "já está em uso"
  end

  test "rejects invalid cpf" do
    @profile.cpf = "11111111111"

    assert_not @profile.valid?
    assert_includes @profile.errors[:cpf], "não é válido"
  end

  test "user can have only one profile" do
    @profile.save!
    second_profile = Profile.new(valid_profile_attributes.merge(user: @user, cpf: "39053344705"))

    assert_not second_profile.valid?
    assert_includes second_profile.errors[:user], "já está em uso"
  end

  private

  def valid_profile_attributes
    {
      full_name: "Maria da Silva",
      cpf: "52998224725",
      rg: "123456789",
      rg_issuer: "SSP/SP",
      birth_date: Date.new(1990, 5, 20),
      gender: :female,
      marital_status: :single,
      phone: "1133334444",
      mobile_phone: "11999998888",
      mother_name: "Ana da Silva",
      nationality: "Brasileira",
      cep: "01310100",
      street: "Avenida Paulista",
      number: "1000",
      complement: "Apto 12",
      neighborhood: "Bela Vista",
      city: "São Paulo",
      state: "SP"
    }
  end
end
