class Address < ApplicationRecord
  validates :zipcode, presence: true, format: {
    with: /\A\d{7}\z/,
    message: 'は7桁の数字で入力してください',
    allow_blank: true
  }
  validates :prefecture, :city, :street, presence: true

  before_validation :normalize_zipcode

  private

  def normalize_zipcode
    self.zipcode = zipcode.to_s.gsub(/[-ー]/, '') if zipcode.present?
  end
end
