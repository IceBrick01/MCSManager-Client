#!/bin/bash
printf "\033c"

Red_Error() {
  echo '================================================='
  printf '\033[1;31;40m%b\033[0m\n' "$@"
  exit 1
}

if [ $(whoami) != "root" ]; then
  Red_Error "[x] 請使用 root 權限執行 MCSManager Client 安裝指令！"
fi

echo "+----------------------------------------------------------------------
| MCSManager Client Install Script
+----------------------------------------------------------------------
| Copyright ©2022 IceBrick All rights reserved.
+----------------------------------------------------------------------
| Client Install Script by IceBrick01, Client by nuomiaa
+----------------------------------------------------------------------
"

echo "[↓] 下載 MCSManager Client..."
rm -f /opt/mcsm.sh
wget -P /opt https://shell.ea0.cn/mcsm.sh
chmod -R 755 /opt/mcsm.sh

echo "[+] 安裝 MCSManager Client..."
rm -f /usr/local/bin/mcsm
ln -s /opt/mcsm.sh /usr/local/bin/mcsm

echo "=================================================================="
echo -e "\033[1;32mMCSManager Client - 安裝成功\033[0m"
echo "=================================================================="
echo "您可以在命令行使用 \"mcsm\" 呼出 MCSManager Client"

exit
