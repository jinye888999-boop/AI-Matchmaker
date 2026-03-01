const DEFAULT_BASE_URL = 'http://localhost:8000/api/v1'
const REQUEST_TIMEOUT = 10000

const safeString = (value = '') => String(value).trim()

const getBaseUrl = () => {
  const customBaseUrl = safeString(wx.getStorageSync('apiBaseUrl'))
  const baseUrl = customBaseUrl || DEFAULT_BASE_URL

  // 生产环境默认要求 HTTPS，本地调试允许 HTTP localhost
  if (!/^https:\/\//.test(baseUrl) && !/^http:\/\/(localhost|127\.0\.0\.1)/.test(baseUrl)) {
    throw new Error('不安全的 API 地址，请使用 HTTPS。')
  }

  return baseUrl.replace(/\/$/, '')
}

const getAuthHeader = () => {
  const app = typeof getApp === 'function' ? getApp() : null
  const token = safeString(app?.globalData?.token || wx.getStorageSync('token'))
  return token ? { Authorization: `Bearer ${token}` } : {}
}

const request = (url, method = 'GET', data = {}) => {
  return new Promise((resolve, reject) => {
    let baseUrl = ''

    try {
      baseUrl = getBaseUrl()
    } catch (error) {
      reject(error)
      return
    }

    wx.request({
      url: `${baseUrl}${url}`,
      method,
      data,
      timeout: REQUEST_TIMEOUT,
      header: {
        'content-type': 'application/json',
        ...getAuthHeader()
      },
      success: (res) => {
        const { statusCode, data: responseData } = res

        if (statusCode >= 200 && statusCode < 300) {
          resolve(responseData)
          return
        }

        const message = safeString(responseData?.detail || responseData?.message) || '请求失败'
        reject(new Error(message))
      },
      fail: () => {
        reject(new Error('网络异常，请检查连接后重试。'))
      }
    })
  })
}

module.exports = {
  request
}
