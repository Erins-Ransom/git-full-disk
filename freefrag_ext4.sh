#!/bin/bash
################################################################################
# freefrag_ext4.sh
################################################################################
# performs aged and unaged grep tests on ext4
#
# usage:
# ./freefrag_ext4.sh path_to_aged aged_blk_device path_to_unaged unaged_blk_device
################################################################################


FULL_PATH=$1
FULL_BLKDEV=$2
UNFULL_PATH=$3
UNFULL_BLKDEV=$4
CLEAN_PATH=$5
CLEAN_BLKDEV=$6

# remount aged and time a recursive grep
umount $FULL_PATH &>> log.txt
mount -t ext4 $FULL_BLKDEV $FULL_PATH &>> log.txt
FULL=$(e2freefrag $FULL_BLKDEV)

umount $UNFULL_PATH &>> log.txt
mount -t ext4 $UNFULL_BLKDEV $UNFULL_PATH
UNFULL=$(e2freefrag $UNFULL_BLKDEV)

# create a new ext4 filesystem, mount it, time a recursive grep and dismount it
mkfs.ext4 -F $CLEAN_BLKDEV &>> log.txt
mount -t ext4 $CLEAN_BLKDEV $CLEAN_PATH &>> log.txt
cp -a $FULL_PATH/* $CLEAN_PATH/.
umount $CLEAN_PATH &>> log.txt
mount -t ext4 $CLEAN_BLKDEV $CLEAN_PATH
CLEAN=$(e2freefrag $CLEAN_BLKDEV)
umount $CLEAN_PATH &>> log.txt

# return the frag data
echo "$FULL"
echo "$UNFULL"
echo "$CLEAN"

