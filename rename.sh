#!/bin/sh

echo "Alright, let's take a covfefe.."

outputDir=$2

if [ -z "$outputDir" ]
then
	echo "Please specify the outputdir"
	exit -1
fi

mkdir -p "${outputDir}/ArtistNotFound/"

total=`find $1 -maxdepth 3 -type f | wc -l`
counter=1

echo $total" files to move"

for f in `find $1 -maxdepth 3 -type f`
do
	info=`id3v2 -l $f | grep "Artist"`
	IFS=\: read -a fields <<<"$info"
	for x in "${fields[@]}";do
		artistPresent=`echo $x | grep "Artist"`
		if [ -n "$artistPresent" ]
		then
			title="$(echo -e "${artistPresent}" | sed -e 's/Artist//g' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | sed -e 's/\//_/g')"
		fi
		
		titlePresent=`echo $x | grep "Title"`
		if [ -z "$titlePresent" ] && [ -z "$artistPresent" ]
		then
			artist="$(echo -e "${x}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | sed -e 's/\//_/g')"
		fi
	done
	
	filename=$artist" - "$title
	if [ ${#filename} -gt 3 ]
	then	
		mkdir -p "${outputDir}/${artist}" 2>>/dev/null
		mv "${f}" "${outputDir}/${artist}/${filename}.mp3"
	else
		mv "${f}" "${outputDir}/ArtistNotFound/"
	fi
	echo "${counter}/${total}"
	((counter++))
done
