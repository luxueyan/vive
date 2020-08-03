import glob from 'glob'
import { join } from 'path'
import { readFileSync, existsSync } from 'fs'

function getApiCommonSet() {
  const appConfig = join(process.cwd(), `app.${process.env.noTs ? 'j' : 't'}s`)
  let appendString = ''
  if (existsSync(appConfig)) {
    appendString = `import { request } from '@/app'`
  }
  return appendString
}

export default function getApis() {
  let apis = []
  const root = process.cwd()
  const appConfig = getApiCommonSet()
  let files = glob.sync(`${root}/src/**/api.?(j|t)s`)
  files.forEach((f) => {
    const api = require(f)
    apis = apis.concat(api)
  })
  return apis
}
