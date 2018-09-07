
This directory holds the "role" like specification and through `top.sls` it assign it to given nodes.

## Ideas

Use git branch for different salt/env than base.

Use as regular salt pillars. Nothing to add.

When reclass is used, tend to:

* define `_params` or similar ignition configuration, later used by reclass to add full
  pillar metadata structures.

* use this salt pillar structures to target multiple minions, which reclass can't

* be aware, that gh:salt-formula/reclass allows you to use class_mapping feature, to dynamically
  assign classes to nodes.
