class ProfilesController < ApplicationController
  before_action :set_profile

  def show
  end

  def edit
  end

  def update
    @profile.user = current_user if @profile.new_record?

    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Perfil atualizado com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = current_user.profile || current_user.build_profile
  end

  def profile_params
    params.expect(
      profile: [
        :full_name, :cpf, :rg, :rg_issuer, :birth_date, :gender,
        :phone, :mobile_phone, :mother_name, :nationality, :marital_status,
        :cep, :street, :number, :complement, :neighborhood, :city, :state, :avatar
      ]
    )
  end
end
