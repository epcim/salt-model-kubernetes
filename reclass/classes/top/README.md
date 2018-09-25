
TODO:
- move salt.master and salt.virt related to salt/ directory
- relocate from folders all storage specific setup under infra/storage/[<component>]\*.yml
- relocate from folders all network specific setup under infra/networking/[<component>]\*.yml
- for any record under top/, follow the structure:
  - top/<role>/default/
  - top/<role>/init.yml
- consolidate uninitialized \_params, possibly highlight with comments in top/<role>/default/init.yml what is exp. to override
- consolidate all credentials under top/<role>/default/secret.yml
