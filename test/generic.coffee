
(require './mock/exec').mockComm [
  ['which kwalletcli', new Error 'No such thing']
]

unipassman = require '../js/unipassman'


error = (msg...) ->
  console.error msg.join ' '
  process.exit 1

# sync tests

# .read(group, username, cb) callback is required and must be a function
try
  unipassman.read 'xxx', 'xxx'
  console.error 'Test error #1a: accepted .read() w/o callback'
  process.exit 1
catch err
  unless err?.status is 'ARGUMENT_MISMATCH'
    error 'Test error #2a: .read() should have returned ArgumentError'
try
  unipassman.read 'xxx', 'xxx', {}
  console.error 'Test error #1b: accepted .read() w/o callback'
  process.exit 1
catch err
  unless err?.status is 'ARGUMENT_MISMATCH'
    error 'Test error #2b: .read() should have returned ArgumentError'

# .write(group, username, pw, cb) callback is required
try
  unipassman.write 'xxx', 'xxx', 'fsd'
  error 'Test error #3a: accepted .write() w/o callback'
catch err
  unless err?.status is 'ARGUMENT_MISMATCH'
    error 'Test error #4a: .write() should have returned ArgumentError'
try
  unipassman.write 'xxx', 'xxx', 'fsd', {}
  error 'Test error #3b: accepted .write() w/o callback'
catch err
  unless err?.status is 'ARGUMENT_MISMATCH'
    error 'Test error #4b: .write() should have returned ArgumentError'


async_tests = [
  (next) -> # username is required: .read(group, username, cb)
    unipassman.read 'xxx', null, (err) ->
      unless err?.status is 'ARGUMENT_MISMATCH'
        error 'Test error #5: .read() should have returned ArgumentError'
      next()

  (next) -> # username must be string: .read(group, username, cb)
    unipassman.read 'xxx', 12, (err) ->
      unless err?.status is 'ARGUMENT_MISMATCH'
        error 'Test error #6: .read() should have returned ArgumentError'
      next()

  (next) -> # username must have length: .read(group, username, cb)
    unipassman.read 'xxx', '', (err) ->
      unless err?.status is 'ARGUMENT_MISMATCH'
        error 'Test error #7: .read() should have returned ArgumentError'
      next()

  (next) -> # username is required: .write(group, username, password, cb)
    unipassman.write 'xxx', null, 'fds', (err) ->
      unless err?.status is 'ARGUMENT_MISMATCH'
        error 'Test error #8: .write() should have returned ArgumentError'
      next()

  (next) -> # username must be string: .write(group, username, password, cb)
    unipassman.write 'xxx', 12, 'fds', (err) ->
      unless err?.status is 'ARGUMENT_MISMATCH'
        error 'Test error #9: .write() should have returned ArgumentError'
      next()

  (next) -> # username must have length: .write(group, username, password, cb)
    unipassman.write 'xxx', '', 'fds', (err) ->
      unless err?.status is 'ARGUMENT_MISMATCH'
        error 'Test error #10: .write() should have returned ArgumentError'
      next()

  (next) -> # password is required: .write(group, username, password, cb)
    unipassman.write 'xxx', 'username', null, (err) ->
      unless err?.status is 'ARGUMENT_MISMATCH'
        error 'Test error #11: .write() should have returned ArgumentError'
      next()

  (next) -> # password must be string: .write(group, username, password, cb)
    unipassman.write 'xxx', 'username', 12, (err) ->
      unless err?.status is 'ARGUMENT_MISMATCH'
        error 'Test error #12: .write() should have returned ArgumentError'
      next()

  (next) -> # returns pm not found
    unipassman.read 'xxx', 'username', (err) ->
      unless err?.status is 'NO_PASSWORD_MANAGER'
        error 'Test error #13: .read() should have returned NoPasswordManagerError'
      next()

  (next) -> # returns pm not found
    unipassman.write 'xxx', 'username', 'fds', (err) ->
      unless err?.status is 'NO_PASSWORD_MANAGER'
        error 'Test error #14: .write() should have returned NoPasswordManagerError'
      next()

  (next) -> # returns .write() accepts empty string for password
    unipassman.write 'xxx', 'username', '', (err) ->
      if err?.status isnt 'NO_PASSWORD_MANAGER'
        error 'Test error #15: .write() should have accepted NoPasswordManagerError'
      next()

  (next) -> # returns .write() accepts empty string for password
    unipassman.getManager (err, manager) ->
      if err?.status isnt 'NO_PASSWORD_MANAGER' or manager?
        error 'Test error #16: .getManager() should have returned NoPasswordManagerError'
      next()
]


# run async tests
next_async = ->
  if fn = async_tests.shift()
    fn next_async
next_async()
