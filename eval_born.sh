#!/usr/bin/bash

USERNAME=vjorma

echo "1. Verify that xorg is not installed"
echo
( set -x; dpkg --list | grep xorg; )
echo ----------------------------------------------------------------------

echo "2. Check that AppArmor is running"
echo
( set -x; cat /sys/kernel/security/apparmor/profiles; )
echo ----------------------------------------------------------------------

echo "3. Check that there are at least 2 encrypted logical volumes"
echo
( set -x; lsblk; )
echo ----------------------------------------------------------------------

echo "4. Check that SSH is listening to port 4242 only"
echo
( set -x; grep -i port /etc/ssh/sshd_config; )
echo
( set -x; ss -tulpn | grep :22; )
echo
( set -x; ss -tulpn | grep :4242; )
echo ----------------------------------------------------------------------

echo "5. Check that root login via ssh is disabled"
echo
( set -x; grep PermitRootLogin /etc/ssh/sshd_config; )
echo ----------------------------------------------------------------------

echo "6. Check that UFW is running"
echo
( set -x; ufw status verbose; )
echo ----------------------------------------------------------------------

echo "7. Check hostname and that /etc/hosts is modified accoringly"
echo
( set -x; hostname; )
( set -x; cat /etc/hostname; )
( set -x; hostnamectl hostname; )
( set -x; grep `hostname` /etc/hosts; )
echo ----------------------------------------------------------------------

echo "8. Check that user $USERNAME is created"
echo
( set -x; grep $USERNAME /etc/passwd; )
echo ----------------------------------------------------------------------

echo "9. Check that $USERNAME belongs to groups user42 and sudo"
( set -x; groups $USERNAME; )
echo ----------------------------------------------------------------------

echo "10. Check that password expiry is correctly set"
( set -x; chage --list root; )
echo ---
( set -x; chage --list $USERNAME; )
echo ----------------------------------------------------------------------

echo "11. Verify that passwords for root and $USERNAME are"
echo "- at least 10 characters long"
echo "- contain an uppercase letter, a lowercase letter, and a number"
echo "- not contain more than 3 consecutive identical characters"
echo "- password must not include the name of the user"
echo
echo ----------------------------------------------------------------------

echo "12. Check that password policy for new users obey the rules in sec 11."
echo
(set -x; apt list --installed | grep pwquality; )
echo Must be 30:
(set -x; grep PASS_MAX_DAYS /etc/login.defs; )
echo
echo Must be 2:
(set -x; grep PASS_MIN_DAYS /etc/login.defs; )
echo
echo Must be 7:
(set -x; grep PASS_WARN_AGE /etc/login.defs; )
echo
echo Must be 10:
(set -x; grep "minlen" /etc/security/pwquality.conf; )
echo
echo Must be 1:
(set -x; grep "gecos" /etc/security/pwquality.conf; )
echo
echo Must be 7:
(set -x; grep "difok" /etc/security/pwquality.conf; )
echo
echo ----------------------------------------------------------------------
echo "13. Check sudo config requirements"
echo "The default is 3 as required, must not be set to something else:"
(set -x; grep passwd_tries /etc/sudo.conf; )
echo
echo "Must be set to something:"
(set -x; grep "badpass_message" /etc/sudoers; )
echo
echo logging must be set to go under /var/log/sudo:
(set -x; grep "logfile" /etc/sudoers; )
echo
echo must be set:
(set -x; grep "requiretty" /etc/sudoers; )
echo ----------------------------------------------------------------------
echo comma-separated list of allowed directories for sudoing must follow
echo ALL=(ALL:ALL)
echo
(set -x; grep "ALL=(ALL:ALL)" /etc/sudoers; )
echo "Both input and output logiing must be set"
(set -x; grep "log_output" /etc/sudoers; )
(set -x; grep "log_input" /etc/sudoers; )
echo "14. Check that the system installed is in fact the latest stable Debian"
(set -x; cat /etc/os-release; )
echo "15. Check that lighttpd is running"
(set -x; systemctl status lighttpd; )
