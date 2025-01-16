class Api::AddressesController < ApplicationController
  def search
    unless request.xhr?
      render json: { error: '不正なリクエストです' }, status: :bad_request
      return
    end

    result = ZipcodeApiClient.fetch_address(params[:zipcode])

    if result[:error].present?
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: result.transform_values(&:presence)
    end
  rescue => e
    Rails.logger.error "郵便番号検索エラー: #{e.message}"
    render json: { error: '住所の取得に失敗しました' }, status: :internal_server_error
  end
end
