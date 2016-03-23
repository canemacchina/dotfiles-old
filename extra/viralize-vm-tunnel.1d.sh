#!/bin/bash
# <bitbar.title>Viralize virtual machine ssh tunnel</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author.github>canemacchina</bitbar.author.github>
# <bitbar.author>Lorenzo Bugiani</bitbar.author>
# <bitbar.desc>Simple plugin to start and stop an ssh tunnel to the VR virtual machine</bitbar.desc>

# CURRENT_IP="$(awk '/inet / && $2 != "127.0.0.1"{print $2}' <(ifconfig) | tail -n 1)"
# SSH_TUNNEL_COMMAND="ssh -i ${PRIVATE_KEY_PATH} -f -N -L ${CURRENT_IP}:80:${VM_IP}:80 root@${VM_IP}"
# PRIVATE_KEY_PATH="/Users/lorenzobugiani/.vagrant.d/insecure_private_key.tunnel"

PRIVATE_KEY_PATH="/Users/lorenzobugiani/.vagrant.d/insecure_private_key"
VM_IP="10.10.0.100"
IS_ACTIVE_TUNNEL="false"
SSH_TUNNEL_COMMAND="ssh -i ${PRIVATE_KEY_PATH} -f -N -L 443:${VM_IP}:443 -L 80:${VM_IP}:80 -g vagrant@${VM_IP}"

if [ ! -z "$1" ]; then
	if [ "$1" == "activate" ]; then
		/usr/bin/osascript -e "do shell script \"${SSH_TUNNEL_COMMAND} > /dev/null 2>&1 &\" with administrator privileges"
	else
		/usr/bin/osascript -e "do shell script \"pkill -f '${SSH_TUNNEL_COMMAND}' \" with administrator privileges"
	fi
fi

if pgrep -qfx "${SSH_TUNNEL_COMMAND}"; then
    echo ":earth_americas:"
    IS_ACTIVE_TUNNEL="true"
else
    echo ":globe_with_meridians:"
fi
echo "---"

if [[ $IS_ACTIVE_TUNNEL == true ]]; then
	echo "Deactivate tunnel | terminal=false refresh=true bash=$0 param1=deactivate"
else
	echo "Activate tunnel | terminal=false refresh=true bash=$0 param1=activate"
fi