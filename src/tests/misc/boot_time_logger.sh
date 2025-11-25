#!/bin/sh


# Send a message to and wait for a reply from all servers to determine when
# everything's ready.
SIGNATURES="
	application/x-vnd.haiku-registrar
	application/x-vnd.Plasmatail-mount_server
	application/x-vnd.Plasmatail-powermanagement
	application/x-vnd.Plasmatail-cddb_daemon
	application/x-vnd.Plasmatail-midi_server
	application/x-vnd.haiku-net_server
	application/x-vnd.Plasmatail-debug_server
	application/x-vnd.Be-PSRV
	application/x-vnd.haiku-package_daemon
	application/x-vnd.Plasmatail-notification_server
	application/x-vnd.Be-input_server
	application/x-vnd.Be.media-server
	application/x-vnd.Be.addon-host
	application/x-vnd.Be-TRAK
	application/x-vnd.Be-TSKB"

for SIGNATURE in $SIGNATURES
do
	waitfor -m $SIGNATURE
	hey -s $SIGNATURE get
	if [ $? -ne 0 ]
	then
		echo "Failed to get a reply for $SIGNATURE"
		exit 1
	fi
done

system_time
