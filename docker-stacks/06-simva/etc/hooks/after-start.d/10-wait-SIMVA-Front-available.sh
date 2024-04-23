#!/usr/bin/env bash
set -euo pipefail
[[ "${DEBUG:-false}" == "true" ]] && set -x

mc_max_retries=${SIMVA_MAX_RETRIES:-20}
wait_time=${SIMVA_WAIT_TIME:-10};
count=${mc_max_retries};
done="ko";
while [ $count -gt 0 ] && [ "$done" != "ok" ]; do
  echo 1>&2 "Checking Simva availability: $((${mc_max_retries}-$count+1)) pass";
  set +e
  wget "https://${SIMVA_EXTERNAL_DOMAIN:-external.test}/" -O - >/dev/null;
  ret=$?;
  set -e
  if [ $ret -eq 0 ]; then
    done="ok";
  else
    echo 1>&2 "Simva not available, waiting ${wait_time}s";
    sleep ${wait_time};
  fi;
  count=$((count-1));
done;
if [ $count -eq 0 ] && [ "$done" != "ok" ]; then
  echo 1>&2 "Simva not available !";
  exit 1
fi;
if [ "$done" == "ok" ]; then
  echo 1>&2 "Simva available !";
fi;
