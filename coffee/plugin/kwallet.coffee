
ChildProcess = require 'child_process'

esc = require '../shell-escape'


class KWallet

  check: (cb) =>
    ChildProcess.exec 'which kwalletcli', (err) =>
      cb err

  read: (username, cb) =>
    cmd = 'kwalletcli -q -f kscd -e ' + esc username
    ChildProcess.exec cmd, cb

  write: (username, password, cb) =>
    cmd = 'kwalletcli -q -f kscd -e ' + esc(username) + ' -p ' + esc password
    ChildProcess.exec cmd, cb


module.exports = new KWallet
