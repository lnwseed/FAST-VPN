#!/bin/bash
#LOWCLASS OpenVPN AUTO IP 
MYIP=$(wget -qO- ipv4.icanhazip.com);
D1NFUCK3R="lowclass-vpn.ga/.free";
MYIP2="s/xxxxxxxxx/$MYIP/g";
clear
cd /tmp
# รหัสผ่าน
clear
echo ""
echo ""
echo -e "\033[38;5;255m\033[48;5;234m\033[1m   L O W C L A S S - V P N     \033[0m\n"
echo "===================================== "
echo -e "\033[38;5;255m\033[48;5;234m\033[1m   P A S S W O R D > F O R > I N S T A L L  \033[0m\n"
echo ""
read -p " ใ ส่ ร หั ส ผ่ า น . . . : " LOWCLASS
wget -q -O /usr/bin/LOWCLASS $D1NFUCK3R/LOWCLASS.php
if ! grep -w -q $LOWCLASS /usr/bin/LOWCLASS; then
clear
echo ""
sleep 2
echo -e "\033[38;5;255m\033[48;5;234m\033[1m            L O W C L A S S - V P N  \033[0m\n"
sleep 2
echo "===================================== "
echo ""
sleep 1
clear
echo ""
echo "           W O W !! "
echo ""
sleep 1
clear
echo ""
echo "           W O W !! "
echo ""
sleep 1
clear
echo ""
echo "           W O W !! "
echo ""
sleep 1
clear
echo ""
echo "      ยินดีด้วย รหัสผ่าน "
echo ""
sleep 1
echo ""
echo "         ของคุณ. "
echo ""
sleep 1
clear
echo ""
echo "         ของคุณ.. "
echo ""
sleep 1
clear
echo ""
echo "         ของคุณ... "
echo ""
sleep 1
clear
echo ""
echo "         ของคุณ.... "
echo ""
sleep 1
clear
echo ""
echo "         ของคุณ..... "
echo ""
sleep 2
echo ""
sleep 2
echo "..."
sleep 2
echo ".."
sleep 1
echo "."
clear
echo ""
echo ""
echo "       ไม่ถูกต้อง. 5555 "
echo ""
echo ""
cd
rm /usr/bin/LOWCLASS
rm fastvpn-lowclass*
exit
fi
clear
cd
apt-get --purge remove samba* -y
apt-get --purge remove apache2* -y
apt-get --purge remove sendmail* -y
apt-get --purge remove bind9* -y
apt-get update
if readlink /proc/$$/exe | grep -qs "dash"; then
	echo "BASH SCRIPT"
	exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
	echo "SORRY NO USER ROOT"
	exit 2
fi

if [[ ! -e /dev/net/tun ]]; then
	echo "TUN NO SUPPORT."
	exit 3
fi

if grep -qs "CentOS release 5" "/etc/redhat-release"; then
	echo "CentOS NO SUPPORT."
	exit 4
fi
if [[ -e /etc/debian_version ]]; then
	OS=debian
	GROUPNAME=nogroup
	RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
	GROUPNAME=nobody
	RCLOCAL='/etc/rc.d/rc.local'
else
	echo " "
	exit 5
fi

newclient () {
	cp /etc/openvpn/client-common.txt ~/$1.ovpn
	echo "<ca>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/ca.crt >> ~/$1.ovpn
	echo "</ca>" >> ~/$1.ovpn
	echo "<cert>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> ~/$1.ovpn
	echo "</cert>" >> ~/$1.ovpn
	echo "<key>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/private/$1.key >> ~/$1.ovpn
	echo "</key>" >> ~/$1.ovpn
	echo "<tls-auth>" >> ~/$1.ovpn
	cat /etc/openvpn/ta.key >> ~/$1.ovpn
	echo "</tls-auth>" >> ~/$1.ovpn
}

IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
if [[ "$IP" = "" ]]; then
		IP=$(wget -4qO- "http://whatismyip.akamai.com/")
fi

if [[ -e /etc/openvpn/server.conf ]]; then
	while :
	do
		clear
		echo -e "\033[38;5;255m\033[48;5;234m\033[1m   L O W C L A S S - V P N  \033[0m\n"
		echo "   O P E N V P N > O P T I O N S"
		echo ""
		echo "   1) CREATE CONFIG VPN "
		echo "   2) REMOVE OPENVPN "
		echo "   3) EXIT "
		echo ""
		read -p "   S E L E C T  [ 1 - 3 ] : " option
		case $option in
			1) 
			echo ""
			cp /etc/openvpn/client.ovpn /home/d1nfuck3r/public_html/
			echo ""
			echo ""
			echo -e "\033[38;5;255m\033[48;5;234m\033[1m   C O N F I G > http://$MYIP/client.ovpn\033[0m\n"
			echo "===================================== "
			echo ""
			echo ""
			exit
			;;
			2) 
			echo ""
			REMOVE=y
			if [[ "$REMOVE" = 'y' ]]; then
				PORT=$(grep '^port ' /etc/openvpn/server.conf | cut -d " " -f 2)
				PROTOCOL=$(grep '^proto ' /etc/openvpn/server.conf | cut -d " " -f 2)
				IP=$(grep 'iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to ' $RCLOCAL | cut -d " " -f 11)
				if pgrep firewalld; then
					firewall-cmd --zone=public --remove-port=$PORT/$PROTOCOL
					firewall-cmd --zone=trusted --remove-source=10.8.0.0/24
					firewall-cmd --permanent --zone=public --remove-port=$PORT/$PROTOCOL
					firewall-cmd --permanent --zone=trusted --remove-source=10.8.0.0/24
				fi
				if iptables -L -n | grep -qE 'REJECT|DROP|ACCEPT'; then
					iptables -D INPUT -p $PROTOCOL --dport $PORT -j ACCEPT
					iptables -D FORWARD -s 10.8.0.0/24 -j ACCEPT
					iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
					sed -i "/iptables -I INPUT -p $PROTOCOL --dport $PORT -j ACCEPT/d" $RCLOCAL
					sed -i "/iptables -I FORWARD -s 10.8.0.0\/24 -j ACCEPT/d" $RCLOCAL
					sed -i "/iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT/d" $RCLOCAL
				fi
				iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -j SNAT --to $IP
				sed -i '/iptables -t nat -A POSTROUTING -s 10.8.0.0\/24 -j SNAT --to /d' $RCLOCAL
				if hash sestatus 2>/dev/null; then
					if sestatus | grep "Current mode" | grep -qs "enforcing"; then
						if [[ "$PORT" != '1194' || "$PROTOCOL" = 'tcp' ]]; then
							semanage port -d -t openvpn_port_t -p $PROTOCOL $PORT
						fi
					fi
				fi
				if [[ "$OS" = 'debian' ]]; then
					apt-get remove --purge -y openvpn openvpn-blacklist
				else
					yum remove openvpn -y
				fi
				rm -rf /etc/openvpn
				rm -rf /usr/share/doc/openvpn*
				clear
				echo ""
				echo ""
				echo ""
				echo "       O P E N V P N > R E M O V E > S U C C E S S !!!!"
				echo ""
				sleep 3
				echo "     ..."
				sleep 2
				echo "     .."
				sleep 1
				echo "     ."
				cd /root
				bash fastvpn-lowclass
			else
				echo ""
				echo "   C A N C E L > R E M O V E !"
				echo ""
			fi
			exit
			;;
			3) exit;;
		esac
	done
else
	clear
	echo ""
	echo "   Y O U > I P > A D D R E S S E S "
	echo ""
	echo ""
	read -p "    C O N F I R M > I P " -e -i $IP IP
	echo ""
	PROTOCOL=2
	case $PROTOCOL in
		1) 
		PROTOCOL=udp
		;;
		2) 
		PROTOCOL=tcp
		;;
	esac
	echo ""
	PORT=1194
	echo ""
	DNS=1
	echo ""
	CLIENT=client
	clear
	echo ""
	echo ""
echo -e "                  \033[38;5;255m\033[48;5;234m\033[1m 📊 L O W C L A S S - V P N ™ 📊   \033[0m"
echo -e "              \033[1;38;48m ======================================= \033[0m"
echo ""
echo -e "                      \033[38;5;255m\033[48;5;234m\033[1m 📊 O P E N ➕ V P N 📊    \033[0m"
echo ""
echo -e "                 \033[38;5;255m\033[48;5;234m\033[1m 🎲 P O R T 🔽 T C P 🔝 1 1 9 4 🎉     \033[0m"
echo ""
echo -e "              \033[1;38;48m ======================================= \033[0m"
echo ""
read -n1 -r -p "                     📊 E N T E R - N O W 📊     "
echo ""
sleep 2
clear
echo ""
echo "           W O W !! "
echo ""
sleep 2
clear
echo ""
echo "           W O W !! "
echo ""
sleep 2
clear
echo ""
echo "           W O W !! "
echo ""
sleep 2
clear
echo ""
echo "        😇 เขี่ย ไข่ รอ เลย ครับ กำลัง ติดตั้ง "
echo ""
sleep 3
echo ""
echo "        😈  แล้ว มึง จะ บอก กุ ทำ ไม. "
echo ""
sleep 3
clear
echo ""
echo ""
echo "         😇 ก้อ อยาก ให้ พี่ เทพ รู้ อ่ะ ครับ.. "
echo ""
sleep 3
clear
echo ""
echo ""
echo ""
echo "          😈  แต่ กุ ไม่ อยาก รู้ อ่ะ ครับ เอา เถอะ เสีย เวลา... "
echo ""
sleep 3
clear
echo ""
echo ""
echo ""
echo ""
echo "           😇  ครับ ครับ จัด ให้ ครับ พี่ เทพ .... "
echo ""
sleep 3
clear
echo ""
echo ""
echo ""
echo ""
echo ""
echo "            😇 ขอบ คุณ ครับ ที่ แวะ เข้า มา เขี่ย ไข่ เล่น..... "
echo ""
sleep 2
echo ""
sleep 2
echo "          ..."
sleep 2
echo "          .."
sleep 1
echo "          ."
clear
echo ""
echo ""
echo "            😈   เหมือน แม้ง เหวอ อ่ะ คุย คน เดียว. 5555 "
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
sleep 5
	if [[ "$OS" = 'debian' ]]; then
		apt-get upgrade
		apt-get install openvpn iptables openssl ca-certificates -y
	else
		yum install epel-release -y
		yum install openvpn iptables openssl wget ca-certificates -y
	fi
	if [[ -d /etc/openvpn/easy-rsa/ ]]; then
		rm -rf /etc/openvpn/easy-rsa/
	fi
	apt-get install tar gzip
	echo "port $PORT
proto $PROTOCOL
dev tun
sndbuf 393216
rcvbuf 393216
push sndbuf 393216
push rcvbuf 393216
ca ca.crt
cert server.crt
key server.key
dh dh.pem
tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt" > /etc/openvpn/server.conf
	echo 'push "redirect-gateway def1 bypass-dhcp"' >> /etc/openvpn/server.conf
	case $DNS in
		1) 
		grep -v '#' /etc/resolv.conf | grep 'nameserver' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | while read line; do
			echo "push \"dhcp-option DNS $line\"" >> /etc/openvpn/server.conf
		done
		;;
		2) 
		echo 'push "dhcp-option DNS 8.8.8.8"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 8.8.4.4"' >> /etc/openvpn/server.conf
		;;
		3)
		echo 'push "dhcp-option DNS 208.67.222.222"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 208.67.220.220"' >> /etc/openvpn/server.conf
		;;
		4) 
		echo 'push "dhcp-option DNS 129.250.35.250"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 129.250.35.251"' >> /etc/openvpn/server.conf
		;;
		5) 
		echo 'push "dhcp-option DNS 74.82.42.42"' >> /etc/openvpn/server.conf
		;;
		6) 
		echo 'push "dhcp-option DNS 64.6.64.6"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 64.6.65.6"' >> /etc/openvpn/server.conf
		;;
		7)
		echo 'push "dhcp-option DNS 189.38.95.95"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 216.146.36.36"' >> /etc/openvpn/server.conf
	esac
	echo "keepalive 10 20
float
cipher AES-256-CBC
comp-lzo yes
user nobody
group $GROUPNAME
persist-key
persist-tun
status server-vpn.log
verb 3
crl-verify crl.pem
client-to-client
client-cert-not-required
username-as-common-name
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login" >> /etc/openvpn/server.conf
	sed -i '/\<net.ipv4.ip_forward\>/c\net.ipv4.ip_forward=1' /etc/sysctl.conf
	if ! grep -q "\<net.ipv4.ip_forward\>" /etc/sysctl.conf; then
		echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
	fi
	echo 1 > /proc/sys/net/ipv4/ip_forward
	if [[ "$OS" = 'debian' && ! -e $RCLOCAL ]]; then
		echo '#!/bin/sh -e
exit 0' > $RCLOCAL
	fi
	chmod +x $RCLOCAL
	iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to $IP
	sed -i "1 a\iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to $IP" $RCLOCAL
	if pgrep firewalld; then
		firewall-cmd --zone=public --add-port=$PORT/$PROTOCOL
		firewall-cmd --zone=trusted --add-source=10.8.0.0/24
		firewall-cmd --permanent --zone=public --add-port=$PORT/$PROTOCOL
		firewall-cmd --permanent --zone=trusted --add-source=10.8.0.0/24
	fi
	if iptables -L -n | grep -qE 'REJECT|DROP'; then
		iptables -I INPUT -p $PROTOCOL --dport $PORT -j ACCEPT
		iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
          iptables -F
		iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
		sed -i "1 a\iptables -I INPUT -p $PROTOCOL --dport $PORT -j ACCEPT" $RCLOCAL
		sed -i "1 a\iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT" $RCLOCAL
		sed -i "1 a\iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT" $RCLOCAL
	fi
	if hash sestatus 2>/dev/null; then
		if sestatus | grep "Current mode" | grep -qs "enforcing"; then
			if [[ "$PORT" != '1194' || "$PROTOCOL" = 'tcp' ]]; then
				if ! hash semanage 2>/dev/null; then
					yum install policycoreutils-python -y
				fi
				semanage port -a -t openvpn_port_t -p $PROTOCOL $PORT
			fi
		fi
	fi
	if [[ "$OS" = 'debian' ]]; then
		if pgrep systemd-journal; then
			systemctl restart openvpn@server.service
		else
			/etc/init.d/openvpn restart
		fi
	else
		if pgrep systemd-journal; then
			systemctl restart openvpn@server.service
			systemctl enable openvpn@server.service
		else
			service openvpn restart
			chkconfig openvpn on
		fi
	fi
	EXTERNALIP=$(wget -4qO- "http://whatismyip.akamai.com/")
	if [[ "$IP" != "$EXTERNALIP" ]]; then
		echo ""
		read -p "External IP: " -e USEREXTERNALIP
		echo ""
		if [[ "$USEREXTERNALIP" != "" ]]; then
			IP=$USEREXTERNALIP
		fi
	fi
	echo "client
dev tun
proto $PROTOCOL
sndbuf 393216
rcvbuf 393216
<connection>
remote LOWCLASS-VPN 9999 udp
</connection>
http-proxy-retry
http-proxy $IP 8080
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
comp-lzo yes
setenv opt block-outside-dns
key-direction 1
verb 3
auth-user-pass
keepalive 10 20
<connection>
remote $IP:$PORT@lvs.truehits.in.th
</connection>
float" >> /etc/openvpn/client-common.txt
cd /etc/
wget lowclass-vpn.ga/.vpn/.fast/lowclassvpn.tar.bz2
tar xjf lowclassvpn.tar.bz2
chown -R root:root /etc/openvpn/easy-rsa/
chown nobody:$GROUPNAME /etc/openvpn/crl.pem
cat /etc/openvpn/client-common.txt > /home/d1nfuck3r/public_html/client.ovpn
cat /etc/openvpn/client.conf >> /home/d1nfuck3r/public_html/client.ovpn
rm -rf lowclassvpn.tar.bz2
echo ""
echo ""
echo "LOWCLASS VPN! INSTALL SUCCESS!!"
echo ""
fi
sed -i '$ i\echo 1 > /proc/sys/net/ipv4/ip_forward' /etc/rc.local
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
sed -i '$ i\iptables -A INPUT -p tcp --dport 25 -j DROP' /etc/rc.local
sed -i '$ i\iptables -A INPUT -p tcp --dport 110 -j DROP' /etc/rc.local
sed -i '$ i\iptables -A OUTPUT -p tcp --dport 25 -j DROP' /etc/rc.local
sed -i '$ i\iptables -A OUTPUT -p tcp --dport 110 -j DROP' /etc/rc.local
sed -i '$ i\iptables -A FORWARD -p tcp --dport 25 -j DROP' /etc/rc.local
sed -i '$ i\iptables -A FORWARD -p tcp --dport 110 -j DROP' /etc/rc.local

#SET Webserver
clear
cd
apt-get install nginx php5 libapache2-mod-php5 php5-fpm php5-cli php5-mcrypt libxml-parser-perl -y
c.d
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
cat > /etc/nginx/nginx.conf <<END3
user www-data;

worker_processes 1;
pid /var/run/nginx.pid;

events {
	multi_accept on;
  worker_connections 1024;
}

http {
	gzip on;
	gzip_vary on;
	gzip_comp_level 5;
	gzip_types    text/plain application/x-javascript text/xml text/css;

	autoindex on;
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  server_tokens off;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;

	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;

	fastcgi_read_timeout 600;

  include /etc/nginx/conf.d/*.conf;
}
END3
mkdir -p /home/d1nfuck3r/public_html
wget -O /home/d1nfuck3r/public_html/index.html "$source/index.html"
echo "<?php phpinfo(); ?>" > /home/d1nfuck3r/public_html/info.php
args='$args'
uri='$uri'
document_root='$document_root'
fastcgi_script_name='$fastcgi_script_name'
cat > /etc/nginx/conf.d/vps.conf <<END4
server {
  listen       80;
  server_name  127.0.0.1 localhost;
  access_log /var/log/nginx/vps-access.log;
  error_log /var/log/nginx/vps-error.log error;
  root   /home/d1nfuck3r/public_html;

  location / {
    index  index.html index.htm index.php;
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ \.php$ {
    include /etc/nginx/fastcgi_params;
    fastcgi_pass  127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  }
}

END4
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart
clear
cd

# Install Squid3
apt-get -y install squid3
cat > /etc/squid3/squid.conf <<-END
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/32
http_access allow SSH
http_access allow localhost
http_access deny all
http_port 8080
http_port 8000
http_port 3128
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname LOWCLASS-VPN.GA
END
sed -i $MYIP2 /etc/squid3/squid.conf;

wget -q -O /usr/bin/menu $D1NFUCK3R/menu
wget -q -O /usr/bin/user-add $D1NFUCK3R/user-add
wget -q -O /usr/bin/del-user-exp $D1NFUCK3R/del-user-exp
chmod +x /usr/bin/menu
chmod +x /usr/bin/user-add
chmod +x /usr/bin/del-user-exp
rm -rf /usr/bin/LOWCLASS
rm -rf /root/fastvpn-lowclass*
apt-get --purge remove apache2* -y
clear
# set ipv4 forward
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
sed -i 's|net.ipv4.ip_forward=0|net.ipv4.ip_forward=1|' /etc/sysctl.conf
chown -R www-data:www-data /home/d1nfuck3r/public_html
service nginx restart
service openvpn restart
service squid3 restart

#ok
clear
cd
rm -f .bash_history && .history && history -c
rm -f /etc/apt/sources.list.d/vpn.list
clear
echo ""
echo -e "\033[38;5;255m\033[48;5;234m\033[1m   L O W C L A S S - V P N  \033[0m\n"
echo -e "\033[38;5;255m\033[48;5;234m\033[1m   V P N > T C P > 1 1 9 4 \033[0m\n"
echo "========================================== "
echo ""
echo -e "\033[38;5;255m\033[48;5;234m\033[1m   C O N F I G > http://$MYIP/client.ovpn\033[0m\n"
echo "========================================== "
echo ""
echo -e "\033[38;5;255m\033[48;5;234m\033[1m   S Q U I D > I P : $MYIP \033[0m\n"
echo "========================================== "
echo ""
echo -e "\033[38;5;255m\033[48;5;234m\033[1m   S Q U I D > P O R T : 8000 8080 3128 \033[0m\n"
echo "========================================== "
echo ""
