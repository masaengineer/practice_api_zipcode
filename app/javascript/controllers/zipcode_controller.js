import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['zipcode', 'prefecture', 'city', 'street', 'errorMessage'];

  connect() {
    console.log('Zipcode controller connected');
    // ページがキャッシュから復元された時の処理
    if (document.visibilityState === 'visible') {
      this.resetForm();
    }
  }

  async fetchAddress(event) {
    console.log('fetchAddress called');
    event.preventDefault();

    // ページが非表示の場合は処理をスキップ
    if (document.visibilityState !== 'visible') return;

    const button = event.currentTarget;
    const zipcode = this.zipcodeTarget.value.replace(/[-ー]/g, '');
    console.log('Zipcode:', zipcode);

    if (!zipcode.match(/^\d{7}$/)) {
      console.log('Invalid zipcode format');
      this.showError('郵便番号は7桁の数字で入力してください');
      return;
    }

    try {
      console.log('Fetching address data...');
      button.classList.add('loading');
      const response = await fetch(`/api/addresses/search?zipcode=${zipcode}`, {
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          Accept: 'application/json',
        },
      });

      if (!response.ok) {
        console.error('API response error:', response.status);
        throw new Error('Network response was not ok');
      }

      const data = await response.json();
      console.log('API response data:', data);

      if (data.error) {
        console.error('API error:', data.error);
        this.showError(data.error);
        return;
      }

      this.updateAddressFields(data);
    } catch (error) {
      console.error('Error:', error);
      this.showError('住所の取得に失敗しました');
    } finally {
      button.classList.remove('loading');
    }
  }

  showError(message) {
    this.errorMessageTarget.textContent = message;
    this.errorMessageTarget.classList.remove('hidden');
  }

  updateAddressFields(data) {
    this.prefectureTarget.value = data.prefecture || '';
    this.cityTarget.value = data.city || '';
    this.streetTarget.value = data.street || '';
    this.errorMessageTarget.classList.add('hidden');
  }

  cleanupZipcode() {
    const input = this.zipcodeTarget;
    input.value = input.value.replace(/[^\d-ー]/g, '');
  }

  resetForm() {
    // フォームをリセット
    this.zipcodeTarget.value = '';
    this.prefectureTarget.value = '';
    this.cityTarget.value = '';
    this.streetTarget.value = '';
    this.errorMessageTarget.classList.add('hidden');
  }
}
