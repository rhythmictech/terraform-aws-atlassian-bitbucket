#!/bin/bash

exec > >(tee /var/log/user-data.log  2>/dev/console) 2>&1

/usr/bin/systemctl stop bitbucket

INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`

# wait for ebs volume to be attached
while true
do
    # attach EBS (run multiple times in case the volume was still detaching elsewhere)
    aws --region ${region} ec2 attach-volume --volume-id ${volume_id} --instance-id $INSTANCE_ID --device /dev/xvdg

    # see if the volume is mounted before proceeding
    lsblk |grep nvme1n1
    if [ $? -eq 0 ]
    then
        break
    else
        sleep 5
    fi
done

# volume may present to lsblk before the os has fully processed it, so give it a chance
sleep 20

# create fs if needed
/sbin/parted /dev/nvme1n1 print 2>/dev/null |grep xfs
if [ $? -eq 0 ]
then
  echo "Data partition found, ensuring it is mounted"

  mount | grep ${mount_point}

  if [ $? -eq 1 ]
  then
    echo "Data partition not mounted, mounting and adding to fstab"
    echo "/dev/nvme1n1p1 ${mount_point}         xfs     defaults,noatime   1 1" >> /etc/fstab
    mount ${mount_point}
  fi

else
  echo "Data partition not initialized. Initializing and moving base data volume"
  parted -s /dev/nvme1n1 mklabel gpt
  parted -s /dev/nvme1n1 mkpart primary xfs 0% 100%
  while true
  do
    lsblk |grep nvme1n1p1
    if [ $? -eq 0 ]
    then
        break
    else
        sleep 5
    fi
  done

  mkfs.xfs /dev/nvme1n1p1
  mount /dev/nvme1n1p1 /mnt
  rsync -a ${mount_point}/ /mnt
  umount /mnt

  echo "Data partition initialized, mounting and adding to fstab"
  echo "Data partition initialized, mounting and adding to fstab" > /dev/console
  echo "/dev/nvme1n1p1 ${mount_point}         xfs     defaults,noatime   1 1" >> /etc/fstab
  mount ${mount_point}
fi

sed -ie 's/^9-:-Xlog:gc.*$/# Removed GC settings that break Java 11/' /opt/atlassian/data/bitbucket/shared/search/jvm.options
cat <<END > /opt/atlassian/data/bitbucket/shared/bitbucket.properties
setup.displayName: ${site_name}
setup.baseUrl: https://${base_hostname}
setup.license: ${license_key}
setup.sysadmin.username: admin
setup.sysadmin.password: ${admin_password}
setup.sysadmin.displayName: Backup Admin
setup.sysadmin.emailAddress: ${admin_email}

jdbc.driver: org.postgresql.Driver
jdbc.url: ${db_url}
jdbc.user: ${db_username}
jdbc.password: ${db_password}

server.address: 0.0.0.0
server.proxy-name: ${base_hostname}
server.proxy-port: 443
server.scheme: https
server.secure: true
END

chown bitbucket /opt/atlassian/data/bitbucket/shared/bitbucket.properties

/usr/bin/systemctl restart bitbucket
/usr/bin/systemctl enable bitbucket
