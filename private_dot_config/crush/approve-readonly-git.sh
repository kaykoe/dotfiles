#!/usr/bin/env bash

command="${CRUSH_TOOL_INPUT_COMMAND:-}"

case "$command" in
	*';'*|*'|'*|*'&'*|*'`'*|*'$'*|*'('*|*')'*|*'<'*|*'>'*|*$'\n'*)
		exit 0
		;;
esac

case "$command" in
	git\ status|git\ status\ *|git\ diff|git\ diff\ *|git\ log|git\ log\ *|git\ show|git\ show\ *|git\ describe|git\ describe\ *|git\ branch|git\ branch\ *|git\ rev-parse|git\ rev-parse\ *|git\ remote|git\ remote\ *|git\ ls-files|git\ ls-files\ *|git\ ls-tree|git\ ls-tree\ *|git\ tag|git\ tag\ *)
		printf '%s\n' '{"decision":"allow"}'
		;;
esac
