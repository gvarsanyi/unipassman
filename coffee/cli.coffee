
unipassman = require './unipassman'


check = ->
  unipassman.getManager (err, name) ->
    if err
      console.error err.message
      process.exit 1
    console.log name


help = ->
  console.error """
    Read:
      unipassman [passwordgroup] username

    Write:
      unipassman [passwordgroup] username --password password

    Check password manager availability:
      unipassman --check

  """

version = ->
  console.log 'v' + require('../package.json').version


read = ->
  unipassman.read group, username, (err, password) ->
    if err
      console.error err.message
      process.exit 1
    console.log password


write = ->
  unipassman.write group, username, password, (err) ->
    if err
      console.error err.message
      process.exit 1

argv = process.argv[2 ..]
for arg in argv
  if arg in ['-c', '--check']
    return check()
  if arg in ['-h', '--help']
    return help()
  if arg in ['-v', '--ver', '--version']
    return version()
  if arg in ['-p', '--pw', '--pass', '--password']
    if password? or next_is_pw
      console.error 'Password ambiguity: unipassman ', argv...
      process.exit 1
    next_is_pw = true
    continue
  if arg.substr(0, 3) is '-p=' or arg.substr(0, 5) is '--pw=' or
  arg.substr(0, 7) is '--pass=' or arg.substr(0, 11) is '--password='
    password = arg.substr arg.indexOf('=') + 1
    continue
  if arg.substr(0, 1) is '-'
    console.error 'Unknown option:', arg
    console.log ''
    help()
    process.exit 1

  if next_is_pw
    password = arg
    next_is_pw = false
  else unless username?
    username = arg
  else unless group?
    group = username
    username = arg
  else
    console.error 'Too many directives: unipassman ', argv...
    console.log ''
    help()
    process.exit 1

unless username?
  console.error 'Missing username'
  console.log ''
  help()
  process.exit 1

if next_is_pw
  console.error 'Password is not defined: unipassman ', argv...
  console.log ''
  help()
  process.exit 1

unless group?
  group = ''

unless username? or username in ['--help', '-h']
  process.exit if username? then 0 else 1

if password?
  return write()

read()
