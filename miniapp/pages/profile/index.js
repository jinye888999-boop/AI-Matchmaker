Page({
  data: {
    profile: {
      nickname: '',
      age: '',
      city: '',
      education: ''
    }
  },

  onFieldChange(e) {
    const { key } = e.currentTarget.dataset
    this.setData({ [`profile.${key}`]: e.detail.value })
  },

  saveProfile() {
    wx.setStorageSync('profile', this.data.profile)
    wx.showToast({ title: '保存成功', icon: 'success' })
  }
})
