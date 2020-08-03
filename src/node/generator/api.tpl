import { merge } from 'lodash'
import axios from 'axios'
import qs from 'qs'

function createHttp() {
  const http = axios.create(
    merge(
      {
        baseURL: baseURL,
        timeout: 30000,
        paramsSerializer: function (params) {
          return qs.stringify(params, { arrayFormat: 'repeat' })
        },
        transformRequest: [
          (data, headers) => {
            if (
              data &&
              headers['Content-Type'] &&
              ~headers['Content-Type'].indexOf('x-www-form-urlencoded')
            ) {
              return qs.stringify(data)
            } else if (
              data &&
              headers['Content-Type'] &&
              ~headers['Content-Type'].indexOf('application/json')
            ) {
              return JSON.stringify(data)
            }
            return data
          }
        ]
      },
      request ? request.config : {}
    )
  )
  if (request?.interceptors) {
    request?.interceptors.request?.forEach(r=> {
      http.interceptors.request.use(r)
    })
    request?.interceptors.response?.forEach(r=> {
      http.interceptors.response.use(r)
    })
  }
  return http
}

const http = createHttp()
const apiMap = {}
const apiPaths = []
let apis = {{apis}}
apis.forEach((v) => {
  if (apiMap[v.name]) throw new Error(`${v.name}的API名称重复`)
  if (apiPaths.find((ap) => ap === v.url)) {
    throw new Error(`${v.url}接口路径重复`)
  }
  apiMap[v.name] = {}
  apiPaths.push(v.url)
  if (!Array.isArray(v.methods)) {
    throw new Error(`${v.name}的methods不是数组`)
  }
  v.methods.forEach((m) => {
    apiMap[v.name][m] = (data, config) => {
      const configObj = {}
      if (v.proxy) configObj.params = { _proxy: v.proxy }
      if (v.transformResponse)
        configObj.transformResponse = [v.transformResponse]

      return m === 'get' || m === 'delete'
        ? http[m](v.url, merge({ params: data }, configObj, config))
        : http[m](v.url, data, merge(configObj, config))
    }
  })
})

export default apiMap
