#!/usr/bin/bash
rsync --exclude ".git/" \
	--exclude "bootstrap.sh" \
	--exclude "README.md" \
	--exclude "LICENSE" \
	-avh --no-perms . ~;
