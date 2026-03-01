const { request } = require('../../utils/api')

Page({
  data: {
    result: '点击下方按钮，生成你的恋爱分析报告。',
    loading: false
  },

  async analyze() {
    if (this.data.loading) {
      return
    }

    this.setData({ loading: true })

    try {
      const data = await request('/portrait', 'POST', {
        current_user: {
          user_id: 'u1',
          age: 26,
          city: '深圳',
          gender: 1,
          education: '本科',
          tags: ['旅行'],
          personality_vector: [0.5, 0.3, 0.2]
        },
        candidates: []
      })

      const summary = (data?.summary || '').trim()
      const suggestion = (data?.suggestion || '').trim()

      this.setData({
        result: [summary, suggestion].filter(Boolean).join('\n') || '分析完成，但暂无可展示内容。'
      })
    } catch (e) {
      this.setData({ result: e.message || '分析失败，请稍后重试。' })
    } finally {
      this.setData({ loading: false })
    }
  }
})
