scrot -e 'convert -resize 20% -fill "#282828" -colorize 50% -blur 0x1 -resize 500% $f ~/Pictures/lockbg.png'
convert -gravity center -composite ~/Pictures/lockbg.png ~/Pictures/Icons/lock.png ~/Pictures/lockfinal.png
i3lock -u -i ~/Pictures/lockfinal.png
rm ~/Pictures/lockfinal.png ~/Pictures/lockbg.png
