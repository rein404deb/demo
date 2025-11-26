mdadm --create --verbose /dev/md0 -l 0 -n 2 /dev/sdb1 /dev/sdc1
mkfs.ext4 /dev/md0
mkdir /raid
chmod 777 /raid
mount -t ext4 /dev/md0 /raid
echo "/dev/md0  /raid  ext4  defaults  0  0" >> /etc/fstab
mount -av

echo "/raid/nfs 192.168.0.0/23(rw,sync,subtree_check)" >> /etc/exports
systemctl enable --now nfs
mkdir /raid/nfs
chmod 777 /raid/nfs
systemctl enable --now nfs-server
exportfs -a
touch /raid/nfs/test.txt
