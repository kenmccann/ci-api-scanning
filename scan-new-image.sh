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
#   3: Repository Name
#   4: Image Tag
#

#DEBUG
echo AQUA USER: $AQUA_USER
echo AQUA PASS: $AQUA_PASS

#DEBUG
echo curl -s -k -u $AQUA_USER:$AQUA_PASS -X POST -H 'Content-Type:application/json' $1/api/v1/images --data

curl -s -k -u $AQUA_USER:$AQUA_PASS -X POST -H 'Content-Type:application/json' $1/api/v1/images --data @<(cat <<EOF
{
  "images": [
    {
      "registry": "$2",
      "repository": "$3",
      "tag": "$4",
      "digest": null,
      "source": null
    }
  ]
}
EOF
)
