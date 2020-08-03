import chalk from 'chalk'

export function error(msg, ...ret) {
  console.log(chalk.red(msg), ...ret)
}

export function info(msg, ...ret) {
  console.log(chalk.cyan(msg), ...ret)
}

export function warn(msg, ...ret) {
  console.log(chalk.magenta(msg), ...ret)
}

export function success(msg, ...ret) {
  console.log(chalk.green(msg), ...ret)
}

export function log(msg, ...ret) {
  console.log(msg, ...ret)
}
