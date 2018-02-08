#!/bin/sh

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";

myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

 red='\e[1;31m'
               green='\e[0;32m'
               NC='\e[0m'
			   
               echo "Connect ocspanel.info..."
               sleep 1
               
			   echo "กำลังตรวจสอบ Permision..."
               sleep 1
               
			   echo -e "${green}ได้รับอนุญาตแล้ว...${NC}"
               sleep 1
			   
flag=0

if [ $USER != 'root' ]; then
	echo "คุณต้องเรียกใช้งานนี้เป็น root"
	exit
fi

vps="VPS";

if [[ $vps = "VPS" ]]; then
	OCSPANEL="xn--l3clxf6cwbe0gd7j.com/ocspanel/fast-vpn-script"
else
	source="http://เฮียเบิร์ด.com"
fi

#REGISTER CONFIG
clear
 echo ""
          echo -e "\e[031;1m     
                         
                =============== OS-32 & 64-bit ================
                ♦                                             ♦
                ♦     AUTOSCRIPT CREATED BY เฮียเบิร์ด แงะตลอด   ♦
                ♦       -----------About Us------------       ♦ 
                ♦            Telp : 097-026-7262              ♦
                ♦         { VPN / SSH / OCS PANEL }           ♦ 
                ♦       http://facebook.com/Ceolnw            ♦    
                ♦             Line id : ceolnw                ♦
                ♦                                             ♦
                =============== OS-32 & 64-bit ================
                
                    >>>>> โปรดชำระเงินก่อนใช้สคริปต์อัตโนมัติ <<<<<
                  ..........................................
                  .         ราคา: 50 บาท = 1IP             .
                  .        ***********************         .
                  .        True Wallet Account             .
                  .        =======================         .
                  .        Phone : 097-026-7262            .
                  .        Name  : HERE BIRD LNWSHOP       .
                  ..........................................   
                                      
                           Thank You For Choice Us"
			
	echo ""
	echo -e "\e[034;1m----SCRIPT V.1 VIP"
	echo ""
	echo -e "\e[032;1m ( ใส่รหัสผ่านติดตั้ง... )"
	echo ""
read -p "๏๏๏โปรดใส่รหัสสำหรับติดตั้งสคลิปนี้.. : " OCSPANEs
wget -q -O /usr/bin/OCSPANEs xn--l3clxf6cwbe0gd7j.com/config.txt
if ! grep -w -q $OCSPANEs /usr/bin/OCSPANEs; then
clear
echo ""
echo ""
echo " เสียใจด้วย รหัสผิดว่ะ ถ้าไม่มีรหัสติดต่อแอดมินฯ เฮียเบิร์ด"
echo ""
echo " เด้งไปเลยเฟสนี้แน่นอน : www.facebook.com/ceonw"
echo ""
echo ""
rm /usr/bin/pass
rm fastvpn-lowclass
exit
fi
