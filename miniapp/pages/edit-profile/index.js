const PROFILE_STORAGE_KEY = 'profile'

Page({
  data: {
    profile: {
      nickname: '',
      age: '',
      city: '',
      education: ''
    }
  },

  onLoad() {
    const cachedProfile = wx.getStorageSync(PROFILE_STORAGE_KEY)
    if (cachedProfile && typeof cachedProfile === 'object') {
      this.setData({ profile: { ...this.data.profile, ...cachedProfile } })
    }
  },

  onFieldChange(e) {
    const { key } = e.currentTarget.dataset
    const rawValue = String(e.detail.value || '')
    const value = key === 'age' ? rawValue.replace(/[^\d]/g, '').slice(0, 2) : rawValue.trim()
    this.setData({ [`profile.${key}`]: value })
  },

  saveProfile() {
    const profile = {
      nickname: this.data.profile.nickname.trim(),
      age: this.data.profile.age.trim(),
      city: this.data.profile.city.trim(),
      education: this.data.profile.education.trim()
    }

    if (!profile.nickname) {
      wx.showToast({ title: '请输入昵称', icon: 'none' })
      return
    }

    const age = Number(profile.age)
    if (!Number.isInteger(age) || age < 18 || age > 80) {
      wx.showToast({ title: '年龄需在18-80岁', icon: 'none' })
      return
    }

    wx.setStorageSync(PROFILE_STORAGE_KEY, profile)
    wx.showToast({ title: '保存成功', icon: 'success' })
  }
})
