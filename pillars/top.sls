base:
  '*':
    #NOTE, the bellow is a two-side knife - on one it prevents non-defined minions to be used
    - minion.{{ grains['id'] }}
  'G@os:Ubuntu':
    - users
    - linux.system.motd
  'G@os:OSX':
    - users

# Examples:
#  'os:Ubuntu':
#    - match: grain
#    - linux.system.repo3
#  '^found*':
#    - match: pcreem.
#    - linux.system.repo
#  'f* and J@role.linux.system':
#    - match: compound
#    - users2
#  '192.0.0.0/16':
#    - match: ipcidr
#    - users


