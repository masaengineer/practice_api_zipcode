class ZipcodeApiClient
  BASE_URL = 'https://zipcloud.ibsnet.co.jp/api/search'

  # 郵便番号から住所情報を取得
  def self.fetch_address(zipcode)
    # ハイフンを除去して7桁の数字のみにする
    normalized_zipcode = zipcode.to_s.gsub(/[-ー]/, '')

    # APIリクエストを実行
    response = Faraday.get(BASE_URL, { zipcode: normalized_zipcode })

    # レスポンスをパース
    result = JSON.parse(response.body)

    # エラーチェック
    return { error: result['message'] } if result['status'] != 200

    # 結果を整形して返す
    format_response(result['results']&.first)
  rescue => e
    { error: '通信エラーが発生しました' }
  end

  private

  def self.format_response(result)
    return { error: '該当する住所が見つかりません' } unless result

    {
      zipcode: result['zipcode'],
      prefecture_code: result['prefcode'],
      prefecture: result['address1'],
      city: result['address2'],
      street: result['address3'],
      prefecture_kana: result['kana1'],
      city_kana: result['kana2'],
      street_kana: result['kana3']
    }
  end
end
