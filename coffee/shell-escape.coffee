
# --- module code ---


module.exports = (cmd) ->
  '\'' + cmd.replace(/\'/g, "'\\''") + '\''
