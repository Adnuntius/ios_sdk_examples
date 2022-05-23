#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"

dirs=(ObjectiveCExample	SwiftLayoutExample NewsFeedSwiftExample	ObjectiveCLayoutExample	SwiftExample)

if [ -z "$1" ]; then
	echo "Version is required"
	exit 1
fi
version=$1

pushd $CURRENT_DIR > /dev/null

for dir in "${dirs[@]}"; do
	echo "Updating $dir to $version ..."
	pushd $dir > /dev/null
	if [ $? -ne 0 ]; then
		exit 1
	fi
	echo "github \"Adnuntius/ios_sdk\" == $version" > Cartfile
	carthage update --use-xcframeworks
	if [ $? -ne 0 ]; then
		exit 2
	fi
	popd > /dev/null
done
popd > /dev/null
