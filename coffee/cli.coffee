
unipassman = require './unipassman'

[username, password] = process.argv[2 ..]

unless username? or username in ['--help', '-h']
  console.error """
    Username is required. Usage:

    Read:
      unipassman username

    Write:
      unipassman username password

    Check password manager availability:
      unipassman --check

  """
  process.exit if username? then 0 else 1


# get pm
if username is '--check'
  return unipassman.getManager (err, name) ->
    if err
      console.error err.message
      process.exit 1
    console.log name

# write
if password?
  return unipassman.write username, password, (err) ->
    if err
      console.error err
      process.exit 1

# read
  unipassman.read username, (err, password) ->
    if err
      console.error err
      process.exit 1
    console.log password
