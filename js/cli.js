// Generated by CoffeeScript 1.9.0
var arg, argv, check, group, help, next_is_pw, password, read, unipassman, username, version, write, _i, _len,
  __slice = [].slice;

unipassman = require('./unipassman');

check = function() {
  return unipassman.getManager(function(err, name) {
    if (err) {
      console.error(err.message);
      process.exit(1);
    }
    return console.log(name);
  });
};

help = function() {
  return console.error("Read:\n  unipassman [passwordgroup] username\n\nWrite:\n  unipassman [passwordgroup] username --password password\n\nCheck password manager availability:\n  unipassman --check\n");
};

version = function() {
  return console.log('v' + require('../package.json').version);
};

read = function() {
  return unipassman.read(group, username, function(err, password) {
    if (err) {
      console.error(err.message);
      process.exit(1);
    }
    return console.log(password);
  });
};

write = function() {
  return unipassman.write(group, username, password, function(err) {
    if (err) {
      console.error(err.message);
      return process.exit(1);
    }
  });
};

argv = process.argv.slice(2);

for (_i = 0, _len = argv.length; _i < _len; _i++) {
  arg = argv[_i];
  if (arg === '-c' || arg === '--check') {
    return check();
  }
  if (arg === '-h' || arg === '--help') {
    return help();
  }
  if (arg === '-v' || arg === '--ver' || arg === '--version') {
    return version();
  }
  if (arg === '-p' || arg === '--pw' || arg === '--pass' || arg === '--password') {
    if ((typeof password !== "undefined" && password !== null) || next_is_pw) {
      console.error.apply(console, ['Password ambiguity: unipassman '].concat(__slice.call(argv)));
      process.exit(1);
    }
    next_is_pw = true;
    continue;
  }
  if (arg.substr(0, 3) === '-p=' || arg.substr(0, 5) === '--pw=' || arg.substr(0, 7) === '--pass=' || arg.substr(0, 11) === '--password=') {
    password = arg.substr(arg.indexOf('=') + 1);
    continue;
  }
  if (arg.substr(0, 1) === '-') {
    console.error('Unknown option:', arg);
    console.log('');
    help();
    process.exit(1);
  }
  if (next_is_pw) {
    password = arg;
    next_is_pw = false;
  } else if (typeof username === "undefined" || username === null) {
    username = arg;
  } else if (typeof group === "undefined" || group === null) {
    group = username;
    username = arg;
  } else {
    console.error.apply(console, ['Too many directives: unipassman '].concat(__slice.call(argv)));
    console.log('');
    help();
    process.exit(1);
  }
}

if (username == null) {
  console.error('Missing username');
  console.log('');
  help();
  process.exit(1);
}

if (next_is_pw) {
  console.error.apply(console, ['Password is not defined: unipassman '].concat(__slice.call(argv)));
  console.log('');
  help();
  process.exit(1);
}

if (group == null) {
  group = '';
}

if (!((username != null) || (username === '--help' || username === '-h'))) {
  process.exit(username != null ? 0 : 1);
}

if (password != null) {
  return write();
}

read();
