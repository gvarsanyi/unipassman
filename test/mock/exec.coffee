
reqres = null

module.exports.mockComm = (_reqres) ->
  reqres = _reqres

spy = (cmd, opts, cb) ->
  [next_expected, response...] = (reqres.shift() or [])
  unless next_expected?
    console.error 'Unexpected exec request:', cmd
    process.exit 1
  if next_expected isnt cmd
    console.error 'Exec request mismatch. Got:', cmd, 'VS expected:',
                  next_expected
    process.exit 1

  setTimeout ->
    cb response...
  , 10


ChildProcess = require 'child_process'
ChildProcess.exec = (cmd, opts, cb) ->
  if not cb and typeof opts is 'function'
    [cb, opts] = [opts, {}]

  spy cmd, opts, cb


