#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ]; then
 echo usage: $0 original.domain new.domain [file]
 exit
fi
DEPLOY=${DEPLOY:-/deploy}
# Escape dots (.)
OLD_DOMAIN=$(echo "$1" | sed 's/\./\\\./g')
NEW_DOMAIN=$(echo "$2" | sed 's/\./\\\./g')
FILE=$3

if [[ -z $FILE ]]; then
  echo "Replacing $1 with $2 in all files"
  find ${DEPLOY} -not -path '*/\.*' -not -path '*configure*' -not -path '*crucible-seed*' -type f -exec sed -i "s/$OLD_DOMAIN/$NEW_DOMAIN/g" {} \;
  # sed -i "s/$OLD_DOMAIN/$NEW_DOMAIN/g" ${DEPLOY}/env;
elif [[ -d $FILE ]]; then
  echo "Replacing $1 with $2 in $FILE"
  find ${FILE} -not -path '*/\.*' -type f -exec sed -i "s/$OLD_DOMAIN/$NEW_DOMAIN/g" {} \;
else
  echo "Replacing $1 with $2 in $FILE"
  sed -i "s/$OLD_DOMAIN/$NEW_DOMAIN/g" ${FILE};
fi

