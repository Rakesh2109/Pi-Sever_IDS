#!/bin/sh
set -e

# Get capture interface from environment variable, default to wlan0
CAPTURE_INTERFACE=${CAPTURE_INTERFACE:-wlan0}

echo "Starting Zeek to capture on $CAPTURE_INTERFACE (hotspot network) for IDS"
echo "Creating log directory..."
mkdir -p /data/zeek/logs/current
cd /data/zeek/logs/current

# Overwrite site local.zeek with our custom config
if [ -f /usr/local/zeek/etc/local.zeek ]; then
    echo "Installing custom local.zeek configuration"
    cp /usr/local/zeek/etc/local.zeek /usr/local/zeek/share/zeek/site/local.zeek
    echo "Configuration loaded:"
    head -4 /usr/local/zeek/share/zeek/site/local.zeek
fi

echo "Running Zeek on interface: $CAPTURE_INTERFACE"
# Run Zeek - it will auto-load site/local.zeek
exec /usr/local/zeek/bin/zeek -i "$CAPTURE_INTERFACE" local

