
(require '../__mock-exec').mockComm [
  ['which kwalletcli']
  ['kwalletcli -q -f kscd -e \'xxx\'', null, 'xpw']
  ['kwalletcli -q -f kscd -e \'yyy\'', new Error 'sthg']
  ['kwalletcli -q -f kscd -e \'xxx\' -p \'xpw\'']
  ['kwalletcli -q -f kscd -e \'yyy\' -p \'xpw\'', new Error 'sthg']
]

unipassman = require '../../js/unipassman'


error = (msg...) ->
  console.error msg.join ' '
  process.exit 1


async_tests = [
  (next) -> # returns .write() accepts empty string for password
    unipassman.getManager (err, manager) ->
      if err or manager isnt 'kwallet'
        error 'Test error #0: .getManager() should have returned \'kwallet\''
      next()

  (next) -> # successful read
    unipassman.read 'xxx', (err, pw) ->
      if err? or pw isnt 'xpw'
        error 'Test error #1: .read()'
      next()

  (next) -> # no such password
    unipassman.read 'yyy', (err, pw) ->
      if pw? or err?.status isnt 'NO_PASSWORD_FOR_USER'
        error 'Test error #2: .read() should have NoPasswordForUserError'
      next()

  (next) -> # successful write
    unipassman.write 'xxx', 'xpw', (err) ->
      if err?
        error 'Test error #3: .write()'
      next()

  (next) -> # write error
    unipassman.write 'yyy', 'xpw', (err) ->
      unless err
        error 'Test error #4: .write() should have an Error'
      next()
]


# run async tests
next_async = ->
  if fn = async_tests.shift()
    fn next_async
next_async()
