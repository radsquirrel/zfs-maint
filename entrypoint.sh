#!/bin/sh
set -eu

# validate that none of the required environment variables are empty
if [ -z "${ZFS_POOLS}" ]
then
  echo "ERROR: Missing one or more of the following variables"
  echo "  ZFS_POOLS"
  exit 1
fi

cat > /etc/periodic/weekly/scrub <<EOF
#!/bin/sh
exec /scrub.sh ${ZFS_POOLS}
EOF
chmod 755 /etc/periodic/weekly/scrub

# run CMD
echo "INFO: entrypoint complete; executing '${*}'"
exec "${@}"
