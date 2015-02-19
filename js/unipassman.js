// Generated by CoffeeScript 1.9.0
var ArgumentError, NoPasswordForUserError, NoPasswordManagerError, PasswordManager, plugins,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __hasProp = {}.hasOwnProperty,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

plugins = ['kwallet'];

ArgumentError = (function(_super) {
  __extends(ArgumentError, _super);

  function ArgumentError(msg) {
    this.status = 'ARGUMENT_MISMATCH';
    ArgumentError.__super__.constructor.call(this, msg);
  }

  return ArgumentError;

})(Error);

NoPasswordManagerError = (function(_super) {
  __extends(NoPasswordManagerError, _super);

  function NoPasswordManagerError() {
    this.status = 'NO_PASSWORD_MANAGER';
    NoPasswordManagerError.__super__.constructor.call(this, this.message = 'No password manager was found');
  }

  return NoPasswordManagerError;

})(Error);

NoPasswordForUserError = (function(_super) {
  __extends(NoPasswordForUserError, _super);

  function NoPasswordForUserError(group, username) {
    this.status = 'NO_PASSWORD_FOR_USER';
    NoPasswordForUserError.__super__.constructor.call(this, this.message = 'No password was found for ' + username + (group ? ' (group: ' + group + ')' : ''));
  }

  return NoPasswordForUserError;

})(Error);

PasswordManager = (function() {
  PasswordManager.prototype.manager = null;

  PasswordManager.prototype.managerName = null;

  PasswordManager.prototype.ready = false;

  PasswordManager.prototype.readyCue = [];

  function PasswordManager() {
    this.write = __bind(this.write, this);
    this.read = __bind(this.read, this);
    this.getManager = __bind(this.getManager, this);
    var check_next;
    check_next = (function(_this) {
      return function() {
        var manager, plugin;
        if (plugin = plugins.pop()) {
          manager = require('./plugin/' + plugin);
          return manager.check(function(err) {
            var item, _i, _len, _ref;
            if (!err) {
              _this.manager = manager;
              _this.managerName = plugin;
              _this.ready = true;
              _ref = _this.readyCue;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                item = _ref[_i];
                item();
              }
              return;
            }
            return check_next();
          });
        }
      };
    })(this);
    check_next();
  }

  PasswordManager.prototype.getManager = function(cb) {
    var process;
    if (typeof cb !== 'function') {
      throw new ArgumentError('Callback must be a function: ' + 'PasswordManager::getManager(callback)');
    }
    process = (function(_this) {
      return function() {
        if (_this.managerName) {
          return cb(null, _this.managerName);
        }
        return cb(new NoPasswordManagerError);
      };
    })(this);
    if (this.ready) {
      return process();
    }
    this.readyCue.push(process);
  };

  PasswordManager.prototype.read = function(group, username, cb) {
    var process, signiture;
    signiture = 'PasswordManager::read(group, username, callback)';
    if (typeof cb !== 'function') {
      throw new ArgumentError('Callback must be a function: ' + signiture);
    }
    if (typeof username !== 'string') {
      return cb(new ArgumentError('Username must be a string: ' + signiture));
    }
    if (!(username && username !== ':')) {
      return cb(new ArgumentError('Username must have a value: ' + signiture));
    }
    if (typeof group !== 'string' || !group) {
      group = 'UNGROUPED';
    }
    process = (function(_this) {
      return function(group, username) {
        if (_this.manager) {
          return _this.manager.read(group, username, function(err, password) {
            if (err || typeof password !== 'string') {
              return cb(new NoPasswordForUserError(group, username));
            }
            return cb(null, password);
          });
        }
        return cb(new NoPasswordManagerError);
      };
    })(this);
    if (this.ready) {
      return process(group, username);
    }
    (function(_this) {
      return (function(group, username) {
        return _this.readyCue.push(function() {
          return process(group, username);
        });
      });
    })(this)(group, username);
  };

  PasswordManager.prototype.write = function(group, username, password, cb) {
    var process, signiture;
    signiture = 'PasswordManager::write(username, password, callback)';
    if (typeof cb !== 'function') {
      throw new ArgumentError('Callback must be a function: ' + signiture);
    }
    if (typeof username !== 'string') {
      return cb(new ArgumentError('Username must be a string: ' + signiture));
    }
    if (!(username && username !== ':')) {
      return cb(new ArgumentError('Username must have a value: ' + signiture));
    }
    if (typeof password !== 'string') {
      return cb(new ArgumentError('Password must be a string: ' + signiture));
    }
    if (typeof group !== 'string' || !group) {
      group = 'UNGROUPED';
    }
    process = (function(_this) {
      return function(group, username, password) {
        if (_this.manager) {
          return _this.manager.write(group, username, password, function(err) {
            if (err) {
              return cb(err);
            }
            return cb();
          });
        }
        return cb(new NoPasswordManagerError);
      };
    })(this);
    if (this.ready) {
      return process(group, username, password);
    }
    (function(_this) {
      return (function(group, username, password) {
        return _this.readyCue.push(function() {
          return process(group, username, password);
        });
      });
    })(this)(group, username, password);
  };

  return PasswordManager;

})();

module.exports = new PasswordManager;
