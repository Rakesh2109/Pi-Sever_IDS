##! Local site policy for Zeek - Enhanced for real-time monitoring
##! Compatible with Zeek 4.1.1

# Installation-wide salt value
redef digest_salt = "pi_server_monitor";

# This script logs which scripts were loaded during each run.
@load misc/loaded-scripts

# Apply the default tuning scripts for common tuning settings.
@load tuning/defaults

# Estimate and log capture loss.
@load misc/capture-loss

# Define local network (wlan0 hotspot)
redef Site::local_nets += { 192.168.4.0/24 };

# Protocol analyzers for normal traffic detection
@load protocols/conn/known-hosts
@load protocols/conn/known-services
@load protocols/http/main
@load protocols/http/software
@load protocols/dns/main
@load protocols/ssl
@load protocols/ssh/detect-bruteforcing
@load protocols/ftp/detect
@load protocols/ftp/software
@load protocols/smtp/main

# Attack/Security detection
@load policy/protocols/http/detect-sqli
@load policy/protocols/ftp/detect-bruteforcing
@load policy/protocols/ssh/detect-bruteforcing
@load policy/misc/scan

# Files framework
@load frameworks/files/hash-all-files

# Enable logging
@load frameworks/files/detect-MHR
@load policy/frameworks/files/detect-MHR

# Enable JSON logging (if available)
@load policy/tuning/json-logs

# Notice framework configuration
redef Notice::mail_dest = "";

# Enable packet capture with checksum verification disabled
redef ignore_checksums = T;

# Increase logging detail for passwords (for testing)
redef HTTP::default_capture_password = T;
redef FTP::default_capture_password = T;

