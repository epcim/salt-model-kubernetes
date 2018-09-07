# Dynamically creates reclass/nodes/_generated/* node specification
# - it should only be run on salt-master
# - expects reclass:storage:class_mapping to be configurednne

{%- set mapping   = salt.pillar.get('reclass:storage:class_mapping') %}
{%- set minion    = salt.pillar.get('tgt') %} # req. on cli: id or pcre

Sync states:
  salt.runner:
    - name: saltutil.sync_states

Sync modules:
  salt.runner:
    - name: saltutil.sync_modules


{%- for minion,grains in salt['saltutil.runner']('ssh.cmd', tgt=minion, fun='grains.items').items() %}

# TODO, Pillar data overridden by grains or vice versa? Do we need pillar data returned during class mapping?
# by raw pillar (at minion, cli, in-memory)
{#- set node_data = grains['return'] #}
{#- do  node_data.update(salt.pillar.raw()) #}
# by grains
{%- set node_data = salt.pillar.raw() %}
{%- do  node_data.update(grains['return']) %}
{%- do salt.log.info("Node data for '{}' minion passed to reclass.dynamic_node_present state: {}".format(minion, node_data)) %}

Generate reclass node {{ minion }}:
  reclass.dynamic_node_present:
    - name: {{ minion }}
    - node_data: {{ node_data }}
    - class_mapping: {{ mapping }}
    {%- if loop.first %}
    - require:
      - salt: Sync states
      - salt: Sync modules
    {%- endif %}
{%- endfor %}
