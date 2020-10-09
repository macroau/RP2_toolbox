#!/system/bin/sh

flag_file=/nvdata/VIRTUAL_INTERNAL_STORAGE.FLG

data_dev=/dev/block/platform/mtk-msdc.0/11120000.msdc0/by-name/userdata

loop_dev=/dev/block/loop1
sd_dev=/dev/block/mmcblk1p1
sd_mnt=/rsdcard
ext4_file=$sd_mnt/data.ext4

flag_file=/rsdcard/VIRTUAL_INTERNAL_STORAGE_EXT4.FLG
ext4_part=/dev/block/mmcblk1p2

setenforce 0

if [ -b $sd_dev ];then
	# mount sdcard
	mkdir $sd_mnt
	mount -o rw,uid=1000,gid=1000,umask=0000 -t exfat $sd_dev $sd_mnt
	# check flag, mount to /data
	if [ -f $flag_file ];then
		umount data
		#losetup $loop_dev $ext4_file
		#mount -o rw -t ext4 $loop_dev /data
		mount -o rw -t ext4 $ext4_part /data
		if [ $? -ne 0 ];then
			rm $flag_file
			mount -o rw,noatime,nosuid,nodev -t ext4 $data_dev /data
			if [ $? -ne 0 ];then
				reboot
			fi
		fi
	else
		echo "normal mode"
	fi
else
	echo "sdcard not found"
fi

#EOF