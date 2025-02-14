#!/usr/bin/env bash

docker build . -t lxcfs-debug

LOCAL_LXCFS_ARGS=(
  --volume=$PWD/build/lxcfs:/usr/local/bin/lxcfs
  --volume=$PWD/build/liblxcfs.so:/usr/local/lib/x86_64-linux-gnu/lxcfs/liblxcfs.so
)

docker rm -f lxcfs-debug
docker run --rm --privileged --name=lxcfs-debug "${LOCAL_LXCFS_ARGS[@]}" lxcfs-debug bash -ec "
  export PATH=\"/usr/local/bin:\$PATH\"

  mkdir -p /var/lib/lxcfs
  lxcfs -f /var/lib/lxcfs &
  # while ! [[ -e /var/lib/lxcfs/proc/cpuinfo ]]; do
    # echo Waiting for lxcfs...
    # sleep 1
  # done
  sleep 1
  # for _ in {1..3}; do
  #   stat /var/lib/lxcfs/proc/cpuinfo
  #   sleep 0.5
  # done
  cat /proc/cpuinfo >/dev/null
  podman run --rm --cpuset-cpus=0,1 \
    --mount type=bind,source=/var/lib/lxcfs/proc/cpuinfo,target=/proc/cpuinfo,bind-propagation=rprivate \
    --mount type=bind,source=/var/lib/lxcfs/proc/diskstats,target=/proc/diskstats,bind-propagation=rprivate \
    --mount type=bind,source=/var/lib/lxcfs/proc/meminfo,target=/proc/meminfo,bind-propagation=rprivate \
    --mount type=bind,source=/var/lib/lxcfs/proc/stat,target=/proc/stat,bind-propagation=rprivate \
    --mount type=bind,source=/var/lib/lxcfs/proc/swaps,target=/proc/swaps,bind-propagation=rprivate \
    --mount type=bind,source=/var/lib/lxcfs/proc/uptime,target=/proc/uptime,bind-propagation=rprivate \
    --mount type=bind,source=/var/lib/lxcfs/proc/slabinfo,target=/proc/slabinfo,bind-propagation=rprivate \
    --mount type=bind,source=/var/lib/lxcfs/sys/devices/system/cpu,target=/sys/devices/system/cpu,bind-propagation=rprivate \
    busybox sh -c '
      # echo cpuset.cpus=\$(cat /sys/fs/cgroup/cpuset.cpus)
      cat /proc/cpuinfo | grep processor

      # for _ in \$(seq 1 3); do
        # stat /proc/cpuinfo
        # sleep 0.5
      # done
    '
"
