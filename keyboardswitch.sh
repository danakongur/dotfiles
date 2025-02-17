(setxkbmap -query | grep -q "variant:\s\+colemak") && /home/danakongur/mc.sh || setxkbmap -variant colemak is -option caps:backspace,shift:both_capslock && xmodmap -e "clear Lock"
