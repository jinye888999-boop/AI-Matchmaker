const { request } = require('../../utils/api')

Page({
  data: {
    matches: []
  },

  onShow() {
    this.fetchMatches()
  },

  goUserDetail(e) {
    const id = e.currentTarget.dataset.id
    wx.navigateTo({ url: `/pages/user-detail/index?id=${id}` })
  },

  async fetchMatches() {
    const mockPayload = {
      current_user: {
        user_id: 'e0d44c11-1111-4444-9999-f2fd7f71d100',
        age: 26,
        city: '深圳',
        gender: 1,
        education: '本科',
        tags: ['旅行', '电影'],
        personality_vector: [0.6, 0.2, 0.3]
      },
      candidates: [
        {
          user_id: 'e0d44c11-1111-4444-9999-f2fd7f71d101',
          age: 25,
          city: '深圳',
          gender: 2,
          education: '本科',
          tags: ['旅行', '音乐'],
          personality_vector: [0.7, 0.2, 0.2]
        },
        {
          user_id: 'e0d44c11-1111-4444-9999-f2fd7f71d102',
          age: 30,
          city: '广州',
          gender: 2,
          education: '硕士',
          tags: ['阅读'],
          personality_vector: [0.1, 0.3, 0.1]
        }
      ],
      top_k: 10
    }

    try {
      const data = await request('/match', 'POST', mockPayload)
      this.setData({ matches: data })
    } catch (e) {
      wx.showToast({ title: '匹配失败', icon: 'none' })
    }
  }
})
