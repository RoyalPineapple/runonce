#!/bin/sh

set -euo pipefail

dirname=$(dirname "$0")
timestamp=$(date +%Y%m%dT%H%M%S)

for file in ${dirname}/*
do
	#ignore non files and this script itself. 
	if [[ ! -f "$file" || "$file" = "$0"  ]]; then 
		continue
	fi

	if [[ -x "$file" ]]; then 
		"$file"
	else
		logger -t runonce "Found a file that was not executable: $file"
	fi

	dest_path="$dirname/ran/"
	dest_name="$(basename "$file").$timestamp"

	mkdir -p "$dest_path"
	mv "$file" "$dest_path/$dest_name"
	logger -t runonce -p local3.info "$file"
done