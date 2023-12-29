#!/bin/bash

directory="$1"

if [[ -z $directory ]]; then 
	echo "Please provide a directory of scripts to run."
	exit 1
fi

if [[ ! -d $directory ]];  then 
	echo "Provuded argument is not a directory: $directory"
	exit 1
fi

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

	dest_path="$directory/completed/"
	timestamp=$(date +%Y%m%dT%H%M%S)
	dest_name="$(basename "$file").$timestamp"

	mkdir -p "$dest_path"
	mv "$file" "$dest_path/$dest_name"
	logger -t runonce -p local3.info "$file"
done