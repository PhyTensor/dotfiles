# # #!/bin/bash
# #
# # # The power menu HTML popup template
# # POPUP_CONTENT="
# # <div class='power-menu'>
# #   <div class='option' onclick=\"bash -c 'systemctl reboot'\">
# #     <span>⭮ Reboot</span>
# #   </div>
# #   <div class='option' onclick=\"bash -c 'systemctl poweroff'\">
# #     <span>⏻ Shutdown</span>
# #   </div>
# #   <div class='option' onclick=\"bash -c 'systemctl hibernate'\">
# #     <span>⏾ Hibernate</span>
# #   </div>
# # </div>"
# #
# # # Toggle visibility of the power menu
# # if [ "$1" == "toggle" ]; then
# #   if [ -f /tmp/.waybar-power-menu ]; then
# #     rm /tmp/.waybar-power-menu
# #   else
# #     echo "$POPUP_CONTENT" > /tmp/.waybar-power-menu
# #   fi
# # else
# #   # Output the menu content if the file exists
# #   [ -f /tmp/.waybar-power-menu ] && cat /tmp/.waybar-power-menu
# # fi
#
#
#
#
# Using Wofi
#!/bin/bash

action=$(echo -e "Hibernate\nReboot\nShutdown" | wofi --show dmenu --prompt "Power:")

case $action in
    Hibernate)
        systemctl hibernate
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
    *)
        ;;
esac


#
# #!/bin/bash
#
# options="Reboot\nHibernate\nPower Off\nCancel"
# chosen=$(echo -e "$options" | wofi --dmenu --prompt=" Power Menu" --width=200 --height=200)
#
# case "$chosen" in
#     Reboot)
#         systemctl reboot
#         ;;
#     Hibernate)
#         systemctl hibernate
#         ;;
#     "Power Off")
#         systemctl poweroff
#         ;;
#     Cancel)
#         ;;
# esac
