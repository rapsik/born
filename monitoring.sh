#!/bin/sh
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vjorma <vjorma@student.hive.fi>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/12/07 14:24:16 by vjorma            #+#    #+#              #
#    Updated: 2023/12/08 13:09:15 by vjorma           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Monitoring sctipt assignment. Designed for Debian 12.
# Run as root with 2> /dev/null
#
FT_ARCH=`uname -a`
echo "   #Architecture: $FT_ARCH"

CPU_PHY=`lscpu | grep "CPU(s):" | head -1 | awk '{print $2}'`
echo "   #CPU physical : $CPU_PHY"

CPU_LOG=`nproc`
echo "   #vCPU : $CPU_LOG"

MEM_TOT=`free -k | grep "Mem:" | awk '{print $2}'`
MEM_TOT_H="$(($MEM_TOT / 1024))"
MEM_USED=`free -k | grep "Mem:" | awk '{print $3}'`
MEM_USED_H="$((MEM_USED / 1024))"
MEM_PERC="$((($MEM_USED * 100) / $MEM_TOT))"
echo "   #Memory Usage: $MEM_USED_H/$MEM_TOT_H MB ($MEM_PERC%)"

DISK_TOT=`df | grep "LVMGroup-root" | awk '{print $2}'`
DISK_TOT_H=`df -h | grep "LVMGroup-root" | awk '{print $2}'`
DISK_USED=`df | grep "LVMGroup-root" | awk '{print $3}'`
DISK_USED_SUB="$(($DISK_USED / 1024))"
DISK_PERC="$((($DISK_USED * 100) / $DISK_TOT))"
echo "   #Disk Usage $DISK_USED_SUB/$DISK_TOT_H ($DISK_PERC%)"

LOAD_IDLE=`vmstat 1 2 | tail -1 | awk '{print $15}'`
echo "   #CPU load : $((100 - $LOAD_IDLE))"

LAST_BOOT=`uptime -s`
echo "   #Last boot: $LAST_BOOT"

LVM_STATUS=`lvscan | head -1 | awk '{print $1}'`
if [ $LVM_STATUS = 'ACTIVE' ]
then
    LVM_BOOL='yes'
else
    LVM_BOOL='no'
fi
echo "   #LVM use: $LVM_BOOL"

NUM_TCP=`ss -t | grep "ESTAB" | wc -l`
echo "   #Connections TCP : $NUM_TCP ESTABLISHED"

NUM_USER=`who | awk '{print $1}' | uniq | wc -l`
echo "   #User log: $NUM_USER"

IP=`ip route show default | awk '{print $3}'`
INTERFACE=`ip route show default | awk '{print $5}'`
MAC=`cat /sys/class/net/$INTERFACE/address`
echo "   #Network: IP $IP ($MAC)"

NUM_SUDOCMD=`grep "COMMAND=" /var/log/sudo/sudo.log | wc -l`
echo "   #Sudo : $NUM_SUDOCMD"
