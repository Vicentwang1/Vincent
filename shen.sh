#!/bin/bash

# 颜色定义
RED='\033[1;31m'
GRN='\033[1;32m'
BLU='\033[1;34m'
YEL='\033[1;33m'
PUR='\033[1;35m'
CYAN='\033[1;36m'
WHT='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# 打印渐变标题函数
print_title() {
  echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
  echo -e "${YEL}║${NC}          ${BOLD}${WHT}Welcome to ShengeKeJi Script${NC}${YEL}           ║${NC}"
  echo -e "${YEL}║${NC}        ${BOLD}${WHT}MDM Check & AutoBypass for macOS${NC}${YEL}         ║${NC}"
  echo -e "${PUR}║${NC}           ${BOLD}${WHT}Powered by 申哥技术支持${NC}${PUR}                ║${NC}"
  echo -e "${PUR}║${NC}             ${BOLD}${WHT}Website: shengekeji.cn${NC}${PUR}              ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
  echo ""
}

# 打印分割线
print_separator() {
  echo -e "${BLU}────────────────────────────────────────────────────────${NC}"
}

# 菜单选项函数
print_menu() {
  echo -e "${YEL}请选择一个操作:${NC}"
  echo -e " ${GRN}①${NC}. 自动跳过恢复模式 (Autobypass Recovery)"
  echo -e " ${GRN}②${NC}. 禁用MDM通知 (Disable Notifications)"
  echo -e " ${GRN}③${NC}. 检查MDM状态 (Check MDM Status)"
  echo -e " ${GRN}④${NC}. 重启电脑 (Reboot Machine)"
  echo -e " ${GRN}⑤${NC}. 退出脚本 (Exit)"
  echo ""
}

# 等待动画函数
wait_animation() {
  local pid=$1
  local spin='-\|/'
  local i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) %4 ))
    printf "\r${CYAN}处理中，请稍候... ${spin:$i:1}${NC}"
    sleep 0.2
  done
  printf "\r${GRN}处理完成！                ${NC}\n"
}

# 主脚本逻辑
print_title

while true; do
  print_menu
  read -rp "输入对应数字选择操作: " choice
  case $choice in
    1)
      echo -e "${GRN}开始自动跳过恢复模式...${NC}"
      # 放你原有命令或调用函数，举例：
      sleep 2 &
      wait_animation $!
      echo -e "${GRN}自动跳过恢复模式执行完毕！${NC}"
      ;;
    2)
      echo -e "${YEL}正在禁用MDM通知...${NC}"
      sleep 2 &
      wait_animation $!
      echo -e "${GRN}通知已禁用（需要SIP关闭权限）${NC}"
      ;;
    3)
      echo -e "${GRN}正在检查MDM注册状态，请稍候...${NC}"
      sleep 2 &
      wait_animation $!
      sudo profiles show -type enrollment
      ;;
    4)
      echo -e "${RED}系统即将重启，请保存好您的工作！${NC}"
      read -rp "确认重启请输入 'yes': " confirm
      if [[ "$confirm" == "yes" ]]; then
        reboot
      else
        echo -e "${YEL}重启已取消${NC}"
      fi
      ;;
    5)
      echo -e "${PUR}感谢使用申哥技术支持的脚本，期待下次相见！${NC}"
      break
      ;;
    *)
      echo -e "${RED}无效选项，请输入正确的数字。${NC}"
      ;;
  esac
done
