#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"
PARENT_DIR=$(dirname $CURRENT_DIR)

version=$(cat $PARENT_DIR/ios_sdk/AdnuntiusSDK/AdnuntiusSDK.swift | grep -o "version = \".*\"" | awk '{print $3}' | tr -d '"')
dirs=(ObjectiveCExample	SwiftLayoutExample NewsFeedSwiftExample	ObjectiveCLayoutExample	SwiftExample)

if [ -z "$version" ]; then
	echo "Version is required"
	exit 1
fi

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
