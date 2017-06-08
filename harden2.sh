#!/bin/sh
set -x
set -e
#
# Docker build calls this script to harden the image during build after the Java assembly has been installed.
#
# Should be added to the application image using the following:
# <configuration>
#   ...
#   <images>
#     <image>
#       ...
#       <build>
#         ...
#           <runCmds>
#             <run>/usr/sbin/harden2.sh</run>
#           </runCmds>

sysdirs="
  /bin
  /etc
  /lib
  /sbin
  /usr
"

# Remove other programs that could be dangerous.
find $sysdirs -xdev \( \
  -name chown -o \
  \) -delete

# Remove unnecessary user accounts, including root.
sed -i -r '/^(user)/!d' /etc/group
sed -i -r '/^(user)/!d' /etc/passwd

rm -f /usr/sbin/harden2.sh