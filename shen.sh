#!/bin/bash
RED='\033[1;31m'
GRN='\033[1;32m'
BLU='\033[1;34m'
YEL='\033[1;33m'
PUR='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${YEL}║${NC}          ${WHT}Welcome to ShengeKeJi Script${YEL}      ║${NC}"
echo -e "${YEL}║${NC}        ${WHT}MDM Check & AutoBypass for macOS${YEL}    ║${NC}"
echo -e "${PUR}║${NC}           ${WHT}Powered by 申哥技术支持${PUR}            ║${NC}"
echo -e "${PUR}║${NC}             ${WHT}Website: shengekeji.cn${PUR}         ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""


PS3='请选择一个操作（输入对应数字）: '
options=(
  "自动跳过恢复模式 (Autobypass Recovery)"
  "禁用MDM通知 (Disable Notifications)"
  "检查MDM状态 (Check MDM Status)"
  "重启电脑 (Reboot Machine)"
  "退出脚本 (Exit)"
)

select opt in "${options[@]}"; do
    case $opt in
        "自动跳过恢复模式 (Autobypass Recovery)")
            echo -e "${GRN}开始自动跳过恢复模式..."
            if [ -d "/Volumes/Macintosh HD - Data" ]; then
                diskutil rename "Macintosh HD - Data" "Data"
            fi
            echo -e "${GRN}创建新用户"
            echo -e "${BLU}按回车继续，留空使用默认用户"
            echo -e "请输入用户名（默认：Apple）:"
            read realName
            realName="${realName:=Apple}"
            echo -e "请输入系统用户名（无空格，默认：Apple）:"
            read username
            username="${username:=Apple}"
            echo -e "请输入密码（默认：1234）:"
            read passw
            passw="${passw:=1234}"
            dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default'
            echo -e "${GRN}正在创建用户..."
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
            mkdir "/Volumes/Data/Users/$username"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
            dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
            dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
            echo "0.0.0.0 deviceenrollment.apple.com" >> /Volumes/Macintosh\ HD/etc/hosts
            echo "0.0.0.0 mdmenrollment.apple.com" >> /Volumes/Macintosh\ HD/etc/hosts
            echo "0.0.0.0 iprofiles.apple.com" >> /Volumes/Macintosh\ HD/etc/hosts
            echo -e "${GRN}成功屏蔽相关MDM主机"
            touch /Volumes/Data/private/var/db/.AppleSetupDone
            rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
            rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
            touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
            touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
            echo -e "${CYAN}------ 自动跳过恢复模式完成 ------${NC}"
            echo -e "${CYAN}请退出终端，重启Mac享受自由！${NC}"
            break
            ;;
        "禁用MDM通知 (Disable Notifications)")
            echo -e "${YEL}正在禁用MDM通知..."
            sudo rm -f /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
            sudo rm -f /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
            sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
            sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
            echo -e "${GRN}通知已禁用（需要SIP关闭权限）"
            break
            ;;
        "检查MDM状态 (Check MDM Status)")
            echo -e "${GRN}正在检查MDM注册状态，请稍候..."
            sudo profiles show -type enrollment
            break
            ;;
        "重启电脑 (Reboot Machine)")
            echo -e "${RED}系统即将重启，请保存好您的工作！${NC}"
            reboot
            break
            ;;
        "退出脚本 (Exit)")
            echo "感谢使用申哥技术支持的脚本，期待下次相见！"
            break
            ;;
        *)
            echo "无效选项，请输入正确的数字。"
            ;;
    esac
done
