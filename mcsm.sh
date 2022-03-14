#!/bin/bash
printf "\033c"

Red_Error() {
  printf '\033[1;31;40m%b\033[0m\n' "$@"
}

echo "============= MCSManager Client ===============
(1) 重啟面版服務       (8) 重啟守護進程
(2) 停止面版服務       (9) 停止守護進程
(3) 啟動面版服務       (10) 启动守護進程
(4) 禁用面版服務       (11) 禁用守護進程
(5) 啟用面版服務       (12) 啟用守護進程
(6) 修改管理密碼       (13) 清理面版日志
(7) 卸載管理面版       (14) 全部重啟
(0) 退出
==============================================="

read -r -p "[-] 請输入命令代號: " cmd;

if [ "$cmd" ] && [ "$cmd" -gt 0 ] && [ "$cmd" -lt 15 ]; then
   echo "==============================================="
   echo "[-] 正在執行($cmd)..."
   echo "==============================================="
fi

if [ "$cmd" == 1 ]
then
  systemctl restart mcsm-web.service
elif [ "$cmd" == 2 ]
then
  systemctl stop mcsm-web.service
elif [ "$cmd" == 3 ]
then
  systemctl start mcsm-web.service
elif [ "$cmd" == 4 ]
then
  systemctl disable mcsm-web.service
elif [ "$cmd" == 5 ]
then
  systemctl enable mcsm-web.service
elif [ "$cmd" == 6 ]
then
  read -r -p "[+] 請輸入新密碼: " new1;

  if [ "${#new1}" -lt 6 ]; then
    echo "==============================================="
    echo "[x] 密碼長度不能小於 6"
    exit
  fi

  read -r -p "[+] 請再次輸入新密碼: " new2;

  if [ "$new1" != "$new2" ]; then
    echo "==============================================="
    echo "[x] 兩次輸入的密碼不一致"
    exit
  fi

  echo "[-] 修改 MCSManager-Web root 密碼..."
  passWord_old=$(awk -F"\"" '/passWord/{print $4}' /opt/mcsmanager/web/data/User/root.json)
  passWord_new=$(echo -n "$new2" | md5sum | cut -d ' ' -f1)
  sed -e "s@$passWord_old@$passWord_new@g" -i /opt/mcsmanager/web/data/User/root.json

  echo "[-] 重启 MCSManager-Web 服務..."
  systemctl restart mcsm-web.service

  echo "[+] root 密碼已更新！"
elif [ "$cmd" == 7 ]
then
  Red_Error "[!] 卸載後無法找回數據，請先備份必要數據！"
  read -r -p "[-] 確認已了解以上内容，我確定已備份完成 (輸入yes繼續卸載): " yes;
  if [ "$yes" != "yes" ]; then
    echo "==============================================="
    echo "已取消！"
    exit
  fi

  echo "[-] MCSManager 服務正在運行，停止服務..."
  systemctl stop mcsm-{daemon,web}.service
  systemctl disable mcsm-{daemon,web}.service

  echo "[x] 删除 MCSManager 服務"
  rm -f /etc/systemd/system/mcsm-daemon.service
  rm -f /etc/systemd/system/mcsm-web.service

  echo "[-] 重載服務配置文件"
  systemctl daemon-reload

  echo "[x] 删除 MCSManager 相關文件"
  rm -irf /opt/mcsmanager

  echo "[x] 删除 MCSManager Client 相關文件"
  rm -f /usr/local/bin/mcsm
  rm -f /opt/mcsm.sh

  echo "==============================================="
  echo -e "\033[1;32m卸載完成，感謝使用 MCSManager！\033[0m"

elif [ "$cmd" == 8 ]
then
  systemctl restart mcsm-daemon.service
elif [ "$cmd" == 9 ]
then
  systemctl stop mcsm-daemon.service
elif [ "$cmd" == 10 ]
then
  systemctl start mcsm-daemon.service
elif [ "$cmd" == 11 ]
then
  systemctl disable mcsm-daemon.service
elif [ "$cmd" == 12 ]
then
  systemctl enable mcsm-daemon.service
elif [ "$cmd" == 13 ]
then
  rm -ifr /opt/mcsmanager/web/logs
  mkdir -p /opt/mcsmanager/web/logs
  echo "[-] 已清空日誌！"
elif [ "$cmd" == 14 ]
then
  systemctl restart mcsm-{daemon,web}.service
else
  echo "==============================================="
  echo "[-] 已取消！"
fi
