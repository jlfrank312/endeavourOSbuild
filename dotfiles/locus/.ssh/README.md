# locus SSH public key

`id_ed25519.pub` is not yet present here.

After the first playbook run against locus, the `remote_access` role (section 0c)
will generate a keypair on the machine and print the public key in the Ansible output.

To complete the setup:
1. Copy the printed public key into this file as `id_ed25519.pub`
2. `git add` and commit it
3. Re-run the playbook — section 0b will then distribute the key to all peer hosts

The private key stays on locus and is never committed to the repo.
