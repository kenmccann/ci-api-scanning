#!/bin/bash
#
# scan-check-queue-status.sh
# 
# Prerequisites:
#   TIMEOUT - set in CI/CD bindings
#   AQUA_USER - set in CI/CD bindings
#   AQUA_PASS - set in CI/CD bindings  
#
# Input Parameters:
#   1: URL
#   2: Aqua Registry Name
#   3: image:tag

# Set these to binary locations on your build host
JQ=jq
CURL=curl

###
### Don't modify anything below this comment ###
###

SCANNING='true'
COUNT=0

while [ "$SCANNING" = true ]; do

  SCANNING_STATUS=$($CURL -s -k -u $AQUA_USER:$AQUA_PASS -X GET $1/api/v1/scanner/registry/$2/image/$3/status | $JQ -r .status | sed ':a;N;$!ba;s/\n/ /g')
  ((COUNT=COUNT+1))
  sleep 1
  echo $(date +"%H:%M:%S") Scanning status is ${SCANNING_STATUS}.

  if [ "$SCANNING_STATUS" = "Scanned" ];
   then
   SCANNING='false'
   echo "Scanning finished."
   DISALLOWED=$($CURL -s -k -u $AQUA_USER:$AQUA_PASS -X GET $1/api/v1/scanner/registry/$2/image/$3/scan_result | $JQ -r .disallowed | sed ':a;N;$!ba;s/\n/ /g')
   if [ "$DISALLOWED" = false  ];
    then
    echo "Image is ALLOWED."
    exit 0
   else
    echo "Image is DISALLOWED."
    DISALLOW_REASON=$($CURL -s -k -u $AQUA_USER:$AQUA_PASS -X GET $1/api/v1/scanner/registry/$2/image/$3/scan_result | $JQ -r .disallow_reason | sed ':a;N;$!ba;s/\n/ /g')
    echo "Disallow reason: $DISALLOW_REASON"
    exit 1
   fi

  fi

  if [ "$COUNT" -gt "$TIMEOUT" ];
   then
   SCANNING='false'
   echo "Timeout exceeded."
   exit 1
  fi
done
