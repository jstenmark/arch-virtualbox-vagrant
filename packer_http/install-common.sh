#!/bin/bash
NEWUSER="vagrant"
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
sed -i -e 's/^#\(en_US.UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' >/etc/locale.conf

# setting the user credentials
echo -e "${NEWUSER}\n${NEWUSER}" | passwd
useradd -m -U "${NEWUSER}"
echo -e "${NEWUSER}\n${NEWUSER}" | passwd "$NEWUSER"

# setting automatic authentication for any action requiring admin rights via Polkit
cat <<EOF >/etc/polkit-1/rules.d/49-nopasswd_global.rules
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("${NEWUSER}")) {
        return polkit.Result.YES;
    }
});
EOF

# setting sudo for the user
cat <<EOF >"/etc/sudoers.d/$NEWUSER"
Defaults:$NEWUSER !requiretty
$NEWUSER ALL=(ALL) NOPASSWD: ALL
EOF
chmod 440 "/etc/sudoers.d/$NEWUSER"

# setup network
cat <<EOF >/etc/systemd/network/eth0.network
[Match]
Name=eth0

[Network]
DHCP=ipv4
EOF

# Setup pacman-init.service for clean pacman keyring initialization
cat <<EOF >/etc/systemd/system/pacman-init.service
[Unit]
Description=Initializes Pacman keyring
Wants=haveged.service
After=haveged.service
Before=sshd.service
ConditionFirstBoot=yes

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/pacman-key --init
ExecStart=/usr/bin/pacman-key --populate archlinux

[Install]
WantedBy=multi-user.target
EOF

# Add service for running reflector on first boot
cat <<EOF >/etc/systemd/system/reflector-init.service
[Unit]
Description=Initializes mirrors for the VM
After=network-online.target
Wants=network-online.target
Before=sshd.service
ConditionFirstBoot=yes
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=reflector --age 12 --protocol https -c Sweden --sort rate --save /etc/pacman.d/mirrorlist
[Install]
WantedBy=multi-user.target
EOF

# root fixes
usermod --password root root
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >>/etc/ssh/sshd_config

# enabling important services
systemctl daemon-reload
systemctl enable sshd
systemctl enable haveged
systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable pacman-init.service
systemctl enable reflector-init.service

# install grub
grub-install "$DISK"
sed -i -e 's/^GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=1/' /etc/default/grub

# setup unpredictable kernel names
sed -i 's/^GRUB_CMDLINE_LINUX=.*$/GRUB_CMDLINE_LINUX="net.ifnames=0"/' /etc/default/grub
#sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"rootflags=compress-force=zstd\"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# install chroot
install_user "$NEWUSER"
