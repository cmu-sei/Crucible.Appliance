#!/usr/bin/env bash
if [[ -z "$DEPLOY" ]]; then
  DEPLOY=${1:-/deploy}
fi
# Script to pull images docker swarm pulls digest images which omits the tag.
echo "ATTEMPTING TO PULL IMAGES"
find "${DEPLOY}" \
  -not -path "*/\.*" \
  -type f -name "*.yml" \
  ! -path "${DEPLOY}/docker/*" \
  ! -path "${DEPLOY}/osticket/*" \
  ! -path "${DEPLOY}/moodle/*" \
  -exec sed -n -e 's/image: //p' {} \; > /tmp/img
sed '/find/d' /tmp/img > /tmp/images
envsubst < "/tmp/images" > "/tmp/images.out"
sort -o /tmp/images /tmp/images.out
images=`cat /tmp/images`
for image in $images; do
  if test -z "$(docker images -q $image)"; then 
    echo "$image doesen't exist, pulling..."
    docker pull $image
  fi
done
# Remove temporary files.
rm -rf /tmp/img /tmp/images /tmp/images.out

