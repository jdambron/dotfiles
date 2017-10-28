#!/usr/bin/bash
rsync --exclude ".git/" \
	--exclude ".gitmodules" \
	--exclude "bootstrap.sh" \
	--exclude "README.md" \
	--exclude "LICENSE" \
	-avh --no-perms . ~;
