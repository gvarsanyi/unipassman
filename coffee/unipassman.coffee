
plugins = [
  'kwallet'
]


class ArgumentError extends Error
  constructor: (msg) ->
    @status = 'ARGUMENT_MISMATCH'
    super msg

class NoPasswordManagerError extends Error
  constructor: ->
    @status = 'NO_PASSWORD_MANAGER'
    super @message = 'No password manager was found'

class NoPasswordForUserError extends Error
  constructor: (group, username) ->
    @status = 'NO_PASSWORD_FOR_USER'
    super @message = 'No password was found for ' + username +
                     (if group then ' (group: ' + group + ')' else '')


class PasswordManager

  manager:     null # e.g. 'kwallet'
  managerName: null
  ready:       false
  readyCue:    []


  constructor: ->
    check_next = =>
      if plugin = plugins.pop()
        manager = require './plugin/' + plugin
        return manager.check (err) =>
          unless err
            @manager = manager
            @managerName = plugin
            @ready = true
            for item in @readyCue
              item()
            return
          check_next()
    check_next()


  getManager: (cb) =>
    unless typeof cb is 'function'
      throw new ArgumentError 'Callback must be a function: ' +
                              'PasswordManager::getManager(callback)'

    process = =>
      if @managerName
        return cb null, @managerName
      cb new NoPasswordManagerError

    if @ready
      return process()

    @readyCue.push process
    return


  read: (group, username, cb) =>
    signiture = 'PasswordManager::read(group, username, callback)'
    unless typeof cb is 'function'
      throw new ArgumentError 'Callback must be a function: ' + signiture
    unless typeof username is 'string'
      return cb new ArgumentError 'Username must be a string: ' + signiture
    unless username and username isnt ':'
      return cb new ArgumentError 'Username must have a value: ' + signiture

    if typeof group isnt 'string' or not group
      group = 'UNGROUPED'

    process = (group, username) =>
      if @manager
        return @manager.read group, username, (err, password) ->
          if err or typeof password isnt 'string'
            return cb new NoPasswordForUserError group, username
          cb null, password
      cb new NoPasswordManagerError

    if @ready
      return process group, username

    do (group, username) =>
      @readyCue.push ->
        process group, username
    return


  write: (group, username, password, cb) =>
    signiture = 'PasswordManager::write(username, password, callback)'
    unless typeof cb is 'function'
      throw new ArgumentError 'Callback must be a function: ' + signiture
    unless typeof username is 'string'
      return cb new ArgumentError 'Username must be a string: ' + signiture
    unless username and username isnt ':'
      return cb new ArgumentError 'Username must have a value: ' + signiture
    unless typeof password is 'string'
      return cb new ArgumentError 'Password must be a string: ' + signiture

    if typeof group isnt 'string' or not group
      group = 'UNGROUPED'

    process = (group, username, password) =>
      if @manager
        return @manager.write group, username, password, (err) ->
          if err
            return cb err
          cb()
      cb new NoPasswordManagerError

    if @ready
      return process group, username, password

    do (group, username, password) =>
      @readyCue.push ->
        process group, username, password
    return


module.exports = new PasswordManager
