#!/bin/sh

MODULE=merlinclash
VERSION=`cat ./merlinclash/version|sed -n 1p`
TITLE=Merlin Clash
DESCRIPTION=Merlin Clash
HOME_URL=Module_merlinclash.asp


do_build() {
	if [ "$VERSION" = "" ]; then
		echo "version not found"
		exit 3
	fi
	
	rm -f ${MODULE}.tar.gz
	rm -f $MODULE/.DS_Store
	rm -f $MODULE/*/.DS_Store
	tar -zcvf ${MODULE}.tar.gz $MODULE
	md5value=`md5sum ${MODULE}.tar.gz|tr " " "\n"|sed -n 1p`
	cat > ./version <<-EOF
	$VERSION
	$md5value
	EOF
	cat version
	
	DATE=`date +%Y-%m-%d_%H:%M:%S`
	cat > ./config.json.js <<-EOF
	{
	"build_date":"$DATE",
	"description":"$DESCRIPTION",
	"home_url":"$HOME_URL",
	"md5":"$md5value",
	"name":"$MODULE",
	"tar_url": "https://raw.githubusercontent.com/hq450/fancyss/master/fancyss_arm384/merlinclash.tar.gz", 
	"title":"$TITLE",
	"version":"$VERSION"
	}
	EOF
}

do_backup(){
	HISTORY_DIR="../../fancyss_history_package/fancyss_arm384"
	# backup latested package after pack
	backup_version=`cat version | sed -n 1p`
	backup_tar_md5=`cat version | sed -n 2p`
	echo backup VERSION $backup_version
	cp ${MODULE}.tar.gz $HISTORY_DIR/${MODULE}_$backup_version.tar.gz
	sed -i "/$backup_version/d" "$HISTORY_DIR"/md5sum.txt
	echo $backup_tar_md5 ${MODULE}_$backup_version.tar.gz >> "$HISTORY_DIR"/md5sum.txt
}


cp_rules
sync_v2ray_binary
do_build
do_backup
