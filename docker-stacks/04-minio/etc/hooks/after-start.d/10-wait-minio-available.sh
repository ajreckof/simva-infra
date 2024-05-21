#!/usr/bin/env bash
set -euo pipefail
[[ "${DEBUG:-false}" == "true" ]] && set -x

mc_max_retries=${SIMVA_MAX_RETRIES:-20}
wait_time=${SIMVA_WAIT_TIME:-10};
count=${mc_max_retries};
done="ko";
while [ $count -gt 0 ] && [ "$done" != "ok" ]; do
  echo 1>&2 "Checking minio: $((${mc_max_retries}-$count+1)) pass";
  set +e
  curl "https://${SIMVA_MINIO_HOST_SUBDOMAIN:-minio}.${SIMVA_EXTERNAL_DOMAIN:-external.test}/minio/health/live" >/dev/null;
  ret=$?;
  set -e
  if [ $ret -eq 0 ]; then
    done="ok";
  else
    echo 1>&2 "Minio not available, waiting ${wait_time}s";
    sleep ${wait_time};
  fi;
  count=$((count-1));
done;
if [ $count -eq 0 ] && [ "$done" != "ok" ]; then
  echo 1>&2 "Minio not available !";
  exit 1
fi;
if [ "$done" == "ok" ]; then
  echo 1>&2 "Minio available !";
fi;