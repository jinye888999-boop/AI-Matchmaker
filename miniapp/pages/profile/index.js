Page({
  data: {
    menus: [
      { name: '编辑资料', path: '/pages/edit-profile/index' },
      { name: '实名认证', path: '/pages/verification/index' },
      { name: '会员中心', path: '/pages/vip-center/index' },
      { name: '订单记录', path: '/pages/orders/index' },
      { name: '喜欢我的', path: '/pages/likes-me/index' },
      { name: '黑名单', path: '/pages/blacklist/index' },
      { name: '设置', path: '/pages/settings/index' },
      { name: '举报', path: '/pages/report/index' }
    ]
  },

  go(e) {
    wx.navigateTo({ url: e.currentTarget.dataset.path })
  }
})
