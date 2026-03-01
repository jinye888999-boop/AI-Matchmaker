Page({
  data: {
    steps: [
      '微信授权登录',
      '填写资料',
      'AI生成画像',
      'AI匹配推荐',
      '聊天互动',
      '会员升级'
    ]
  },

  goProfile() {
    wx.switchTab({ url: '/pages/profile/index' })
  }
})
