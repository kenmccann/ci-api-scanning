#!/bin/bash
# 
# scan-new-image.sh 
# 
# Prerequisites:
#   AQUA_USER - set in CI/CD bindings
#   AQUA_PASS - set in CI/CD bindings  
#
# Input Parameters:
#   1: URL
#   2: Aqua Registry Name
#   3: image:tag
#

curl -vvv "$1/api/v2/images" \
  -u $AQUA_USER:$AQUA_PASS \
  -H 'Content-Type:application/json' \
  --data-binary '{"registry": "ACR","image": "'"$3"'"}' 
