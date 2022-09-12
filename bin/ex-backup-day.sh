#!/bin/bash

# Include functions
# shellcheck disable=SC2046
source $(dirname "$0")/functions.sh

################# SCRIPT #################

# Script data
START=$(date +%s) # unix time

# Check config
# shellcheck disable=SC2046
CFG=$(dirname $(dirname "$0"))/"settings.cfg"
if [ ! -f "$CFG" ]; then
  ShowError "config doesnt exist"
fi

# include config
# shellcheck disable=SC1090
source "${CFG}"

# start script
ShowMessage "START BACKUP"

# check directories
checkCfg "${EXCLUDE_FILE}" "${BACKUP_DIR_DAY}" "${BACKUP_DB_DAY}" "${TARGET_FOLDER}" "${IGNORE_FILE}"

# Target backup folder
backup_folder=${BACKUP_DIR_DAY}/${DATE}

# Include ignore.txt
# shellcheck disable=SC2207
# shellcheck disable=SC2006
# shellcheck disable=SC2034
ignoreArray=(`cat "$IGNORE_FILE"`)

# Create directories for new archives
mkdir "${backup_folder}"
runs=1

# Get websites folders and run cycle
# shellcheck disable=SC2045
for fl in $(ls -d "${TARGET_FOLDER}"/*)
do
  # Create archive
  createArchive "$fl"

  # check max folders
  if [[ "$runs" -ge "$MAX_FOLDERS" ]]; then
    break
  fi
  # shellcheck disable=SC2004
  runs=$(($runs + 1))
done

# Remote old backups
removeOldDays

# Create backup DB
# shellcheck disable=SC2034
backup_db_dir=${BACKUP_DB_DAY}
createDumpDb

# Remote old backup DB
remoteDumpDbDay

# Working time
workTime

# End message
ShowMessage "END"
exit
