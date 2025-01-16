class AddressesController < ApplicationController
  def index
    @addresses = Address.order(created_at: :desc)
  end

  def show
    @address = Address.find(params[:id])
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)

    if @address.save
      redirect_to addresses_path, notice: '住所を登録しました'
    else
      Rails.logger.debug "Validation errors: #{@address.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to addresses_path, notice: '住所を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to addresses_path, notice: '住所を削除しました', status: :see_other
  end

  private

  def address_params
    params.require(:address).permit(
      :zipcode,
      :prefecture,
      :city,
      :street,
      :building
    )
  end
end
