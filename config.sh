#!/bin/sh

FILE_EXIT="torrc.exit"
FILE_BRIDGE="torrc.bridge"
FILE_MIDDLE="torrc.middle"
FILE_VPN="torrc.vpn"
CFG_DIR="/etc/tor"

if [ !-f "${CFG_DIR}/${FILE_EXIT}" ]; then
  echo "Create ${CFG_DIR}/${FILE_EXIT}."
  cp "/data/${FILE_EXIT}" "${CFG_DIR}/${FILE_EXIT}"
fi
if [ !-f "${CFG_DIR}/${FILE_BRIDGE}" ]; then
  echo "Create ${CFG_DIR}/${FILE_BRIDGE}."
  cp "/data/${FILE_BRIDGE}" "${CFG_DIR}/${FILE_BRIDGE}"
fi
if [ !-f "${CFG_DIR}/${FILE_MIDDLE}" ]; then
  echo "Create ${CFG_DIR}/${FILE_MIDDLE}."
  cp "/data/${FILE_MIDDLE}" "${CFG_DIR}/${FILE_MIDDLE}"
fi
if [ !-f "${CFG_DIR}/${FILE_VPN}" ]; then
  echo "Create ${CFG_DIR}/${FILE_VPN}."
  cp "/data/${FILE_VPN}" "${CFG_DIR}/${FILE_VPN}"
fi

if [ -z "$TORRC" ]; then
  echo "Please provide a valid TORRC parameter!"
  echo "TORRC: $TORRC"
  exit
fi

echo "Using template $TORRC"
chown -Rv debian-tor:debian-tor /home/debian-tor/
chown -Rv debian-tor:debian-tor /etc/tor/
chown -Rv debian-tor:debian-tor /var/log/tor/

# Assumes a key-value'ish pair
# $1 is the key and $2 is the value
function update_or_add {
  FINDINFILE=$(grep -e "^$1.*$" $TORRC)

  echo "Adding $1 $2 to Torrc"

  # Append if missing.
  # Update if exist.
  if [ -z "$FINDINFILE" ]; then
    echo "$1 $2" >> $TORRC
  else
    sed -i "s/^$1.*/$1 $2/g" $TORRC
  fi
}

# Set $NICKNAME to the node nickname
if [ -n "$NICKNAME" ]; then
  update_or_add 'Nickname' "$NICKNAME"
else
  update_or_add 'Nickname' 'DockerTorRelay'
fi

# Set $CONTACTINFO to your contact info
if [ -n "$CONTACTINFO" ]; then
  update_or_add 'ContactInfo' "$CONTACTINFO"
else
  update_or_add 'ContactInfo' 'Anonymous'
fi

cp $TORRC /etc/tor/torrc -f

cat /etc/tor/torrc

echo "tor -f /etc/tor/torrc $@"
tor -f /etc/tor/torrc $@
