bootstrap:
	ansible-playbook site.yml -i inventory/ --connection=local --ask-become-pass

run:
	ansible-playbook site.yml -i inventory/hosts.yml --ask-become-pass

run-pc:
	ansible-playbook site.yml -i inventory/hosts.yml --limit main-pc --ask-become-pass

run-laptop:
	ansible-playbook site.yml -i inventory/hosts.yml --limit laptop --ask-become-pass

run-pi:
	ansible-playbook site.yml -i inventory/hosts.yml --limit raspberrypi --ask-become-pass

snapshot-ii:
	ansible-playbook site.yml -i "localhost," --connection=local --tags snapshot-ii --ask-become-pass

update-ii:
	ansible-playbook site.yml -i "localhost," --connection=local \
	  --tags update-ii --ask-become-pass
	  