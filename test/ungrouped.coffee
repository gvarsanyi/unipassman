
(require './mock/exec').mockComm [
  ['which kwalletcli']
  ['kwalletcli -q -f \'UNGROUPED\' -e \'yyy1\' -p \'xpw\'']
  ['kwalletcli -q -f \'UNGROUPED\' -e \'yyy2\' -p \'xpw\'']
  ['kwalletcli -q -f \'UNGROUPED\' -e \'yyy3\' -p \'xpw\'']
  ['kwalletcli -q -f \'UNGROUPED\' -e \'yyy4\' -p \'xpw\'']
  ['kwalletcli -q -f \'UNGROUPED\' -e \'yyy5\' -p \'xpw\'']
  ['kwalletcli -q -f \'UNGROUPED\' -e \'yyy6\' -p \'xpw\'']
  ['kwalletcli -q -f \'UNGROUPED\' -e \'yyy7\' -p \'xpw\'']
  ['kwalletcli -q -f \'UNGROUPED\' -e \'yyy8\'']
  ['kwalletcli -q -f \'UNGROUPED\' -e \'yyy9\'']
  ['kwalletcli -q -f \'UNGROUPED\' -e \'yyy10\'']
]

unipassman = require '../js/unipassman'


unipassman.write null, 'yyy1', 'xpw', ->
  unipassman.write 0, 'yyy2', 'xpw', ->
    unipassman.write 1, 'yyy3', 'xpw', ->
      unipassman.write false, 'yyy4', 'xpw', ->
        unipassman.write true, 'yyy5', 'xpw', ->
          unipassman.write {}, 'yyy6', 'xpw', ->
            unipassman.write (->), 'yyy7', 'xpw', ->
              unipassman.read null, 'yyy8', ->
                unipassman.read 1, 'yyy9', ->
                  unipassman.read {}, 'yyy10', ->
