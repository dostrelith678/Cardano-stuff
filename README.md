# Block multiple connections to the node from the same IP Address (possible attacks)
Edit the ufw before.rules file:
```
sudo nano /etc/ufw/before.rules
```
Add the following:
```
# Block too many connections to node from the same IP
-A ufw-before-input -p tcp -m tcp -m connlimit --connlimit-above 3 --connlimit-mask 32 --connlimit-saddr  --dport <NODE_PORT> -j DROP

```
Reload the ufw to apply:
```
sudo ufw reload
```

# ZFS
```
apt update
apt install dpkg-dev linux-headers-generic linux-image-generic
apt install zfs-dkms zfsutils-linux
mkdir /opt/cardano
chown koios:koios /opt/cardano
dd if=/dev/zero of=/opt/cardano/disk.000 bs=1M count=409600 # adjust as required, this is 400GB
zpool create koiosdisk /opt/cardano/disk.000
zfs set mountpoint=/opt/cardano/cnode koiosdisk
zfs set compression=lz4 koiosdisk
zfs set recordsize=32K koiosdisk # default is 128K, this is a postgres optimization
```

If using ZFS for postgres, configure `full_page_writes = off` for PostgreSQL, as ZFS will never commit a partial write
