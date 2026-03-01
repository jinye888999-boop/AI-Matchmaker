Page({
  data: { user: {} },
  onLoad(query) {
    this.setData({
      user: { id: query.id || 'u001', age: 26, city: '深圳', tags: ['电影', '健身', '旅行'] }
    })
  },
  like() { wx.navigateTo({ url: '/pages/match-success/index' }) }
})
