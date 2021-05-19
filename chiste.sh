#!/bin/bash

BANNER=$(cat <<-END
   ________  _______________________
  / ____/ / / /  _/ ___/_  __/ ____/
 / /   / /_/ // / \__ \ / / / __/   
/ /___/ __  // / ___/ // / / /___ 
\____/_/ /_/___//____//_/ /_____/  
                                                   
END
)

tput bold
if (($(tput colors) > 8)); then
    tput setaf 208
elif (($(tput colors) == 8)); then
    tput setaf 1
fi
echo "$BANNER" $'\n'
tput sgr0

echo ""
sort -R chistes.txt | head -n1
echo ""