unipassman
==========

Coverage for different password managers/wallets.

# Usage

## API

### Check availability
    var unipassman = require('unipassman');

    unipassman.check(function (err, manager_name) {
      if (err) {
        if (err.status === 'NO_PASSWORD_MANAGER') {
          console.error('No password manager was found');
        } else {
          // other error
          console.error(err);
        }
      } else {
        console.log('Password manager is available:', manager_name);
      }
    });


### Read
    var unipassman = require('unipassman');

    unipassman.read('username', function (err, password) {
      if (err) {
        if (err.status === 'NO_PASSWORD_MANAGER') {
          console.error('No password manager was found');
        } else if (err.status === 'NO_PASSWORD_FOR_USER') {
          console.error('No password manager was found');
        } else {
          // other error
          console.error(err);
        }
      } else {
        console.log('Retrieved password is', password.length, 'character(s)');
      }
    });

### Store
    var unipassman = require('unipassman');

    unipassman.write('username', 'my_secret', function (err) {
      if (err) {
        if (err.status === 'NO_PASSWORD_MANAGER') {
          console.error('No password manager was found');
        } else {
          // other error
          console.error(err);
        }
      } else {
        console.log('Password stored');
      }
    });

## CLI

### Check availability
    unipassman --check
    # will return the password wallet plugin name (with exit code 0) or error message (with exit code 1)

### Read
On your console:
    unipassman username
    # will return password for username (with exit code 0) or appropriate error message (with exit code 1)

### Store
    unipassman username password
    # will return password for username (with exit code 0) or appropriate error message (with exit code 1)


# List of supported password managers (0.0.1)
- KDE Wallet

Support for more password managers will be added incrementally
