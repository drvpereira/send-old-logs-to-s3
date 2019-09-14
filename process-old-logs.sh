MONITOR_ID={monitorId}
AUTH_KEY={cronitorAuthKey}

echo "Calling Cronitor's /run endpoint (https://cronitor.link/$MONITOR_ID/run?auth_key=$AUTH_KEY)"
curl -m 10 "https://cronitor.link/$MONITOR_ID/run?auth_key=$AUTH_KEY" || true

./compress-old-logs.sh {logSource1} {fileDir1}
./compress-old-logs.sh {logSource2} {fileDir2}
./compress-old-logs.sh {logSource3} {fileDir3}
# ...

#Mark job as complete if no errors occurred
if [ $? -eq 0 ]; then
  echo "Calling Cronitor's /complete endpoint (https://cronitor.link/$MONITOR_ID/complete?auth_key=$AUTH_KEY)"
  curl -m 10 "https://cronitor.link/$MONITOR_ID/complete?auth_key=$AUTH_KEY" || true
else
  echo "Calling Cronitor's /fail endpoint (https://cronitor.link/$MONITOR_ID/fail?auth_key=$AUTH_KEY)"
  curl -m 10 "https://cronitor.link/$MONITOR_ID/fail?auth_key=$AUTH_KEY" || true
fi
