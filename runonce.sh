#!/bin/sh

set -euo pipefail

directory="$1"

if [[ -z $directory ]]; then 
	echo "no directory specified"
	exit 1
fi

timestamp=$(date +%Y%m%dT%H%M%S)

for file in ${directory}/*
do
	#ignore non files and this script itself. 
	if [[ ! -f "$file" || "$file" = "$0"  ]]; then 
		continue
	fi

	if [[ -x "$file" ]]; then 
		# run the script
		"$file"
	else
		logger -t runonce "Found a file that was not executable: $file"
	fi

	dest_path="$directory/ran/"
	dest_name="$(basename "$file").$timestamp"

	chmod -x "$file"
	mkdir -p "$dest_path"
	mv "$file" "$dest_path/$dest_name"
	logger -t runonce -p local3.info "$file"
done