#!/bin/bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vjorma <vjorma@student.hive.fi>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/12/07 14:24:16 by vjorma            #+#    #+#              #
#    Updated: 2023/12/07 14:24:16 by vjorma           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Monitoring sctipt assignment. Designed for Debian 12.
# Run as root with 2> /dev/null
# 
FT_ARCH=`uname -a`
CPU_PHY=`lscpu | grep "CPU(s):" | head -1 | awk '{print $2}'`
CPU_LOG=`nproc`
MEM_TOT=`free -k | grep "Mem:" | awk '{print $2}'`
MEM_TOT_H="$(($MEM_TOT / 1024))"
MEM_USED=`free -k | grep "Mem:" | awk '{print $3}'`
MEM_USED_H="$((MEM_USED / 1024))"
MEM_PERC="$((($MEM_USED * 100) / $MEM_TOT))"
LOAD_IDLE=`vmstat 1 2 | tail -1 |awk '{print $15}'`
DISK_USED=`df | grep "/dev/sda" | awk '{print $3}'`

echo "#Architecture: $FT_ARCH"
echo "#CPU physical : $CPU_PHY"
echo "#vCPU : $CPU_LOG"
echo "#Memory Usage: $MEM_USED_H/$MEM_TOT_H MB ($MEM_PERC%)"
echo "#Disk Usage $(((DISK_USED / 1024)))/X"
echo "CPU load : $((100 - $LOAD_IDLE))
