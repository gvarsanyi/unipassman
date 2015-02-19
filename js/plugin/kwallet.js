// Generated by CoffeeScript 1.9.1
var ChildProcess, KWallet, esc,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ChildProcess = require('child_process');

esc = require('../shell-escape');

KWallet = (function() {
  function KWallet() {
    this.write = bind(this.write, this);
    this.read = bind(this.read, this);
    this.check = bind(this.check, this);
  }

  KWallet.prototype.check = function(cb) {
    return ChildProcess.exec('which kwalletcli', (function(_this) {
      return function(err) {
        return cb(err);
      };
    })(this));
  };

  KWallet.prototype.read = function(group, username, cb) {
    var cmd;
    cmd = 'kwalletcli -q -f ' + esc(group) + ' -e ' + esc(username);
    return ChildProcess.exec(cmd, cb);
  };

  KWallet.prototype.write = function(group, username, password, cb) {
    var cmd;
    cmd = 'kwalletcli -q -f ' + esc(group) + ' -e ' + esc(username) + ' -p ' + esc(password);
    return ChildProcess.exec(cmd, cb);
  };

  return KWallet;

})();

module.exports = new KWallet;
