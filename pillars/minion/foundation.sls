
reclass:
  enabled: true
  storage:
    enabled: true
    data_source:
      engine: local

# FIXME, remove for final version
linux:
  system:
    profile:
      locales: |
        export LANG=C
        export LC_ALL=C
      flavors_editor.sh: |
        export PAGER=view
        export EDITOR=vim
        alias vi=vim
      locales_shell.sh: |
        export LANG=en_US
        export LC_ALL=en_US.UTF-8

