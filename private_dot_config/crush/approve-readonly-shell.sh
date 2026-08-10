#!/usr/bin/env bash

command="${CRUSH_TOOL_INPUT_COMMAND:-}"

case "$command" in
*';'* | *'|'* | *'&'* | *'`'* | *'$'* | *'('* | *')'* | *'>'* | *'<'* | *$'\n'*)
	exit 0
	;;
chezmoi\ diff | chezmoi\ diff\ * | chezmoi\ execute-template\ * | shellcheck\ \* | *\ --help | pwd | ls | ls\ * | tree | tree\ * | which\ * | command\ -v\ * | type\ * | test\ * | printf\ * | print\ * | echo\ * | date | date\ * | basename\ * | dirname\ * | realpath\ * | readlink\ * | cat\ * | head\ * | tail\ * | grep\ * | rg\ * | find\ * | file\ * | stat\ * | wc\ * | diff\ * | sed\ -n\ * | bash\ -n\ * | zsh\ -n\ * | npm\ list | npm\ list\ * | npm\ info\ * | pdftotext\ * | notify-send\ * | kubectl\ auth\ can-i\ *)
	printf '%s\n' '{"decision":"allow"}'
	;;
esac
