#!/usr/bin/env bash

command="${CRUSH_TOOL_INPUT_COMMAND:-}"

case "$command" in
	*';'*|*'|'*|*'&'*|*'`'*|*'$'*|*'('*|*')'*|*'<'*|*'>'*|*$'\n'*)
		exit 0
		;;
esac

case "$command" in
	pwd|ls|ls\ *|tree|tree\ *|which\ *|command\ -v\ *|type\ *|cat\ *|head\ *|tail\ *|grep\ *|npm\ list|npm\ list\ *|npm\ info\ *|pdftotext\ *|notify-send\ *)
		printf '%s\n' '{"decision":"allow"}'
		;;
esac
