find=$(find "$1" -type f)
printf "$find" | xargs -I {file} bash -c 'md5sum "{file}"' > /tmp/check.md5
while true; do
  Change=$(md5sum --quiet -c /tmp/check.md5)
    if [[ -n "$Change" ]];then
      echo "$Change" >> $HOME/.prometeo/Monitoreo.log
      find=$(find "$dir" -type f)
      printf "$find" | xargs -I {file} bash -c 'md5sum "{file}"' > /tmp/check.md5
    fi
  sleep 3
done