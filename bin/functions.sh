#!/bin/bash

# Show error message
ShowError(){
  echo "$(date +%Y-%m-%d_%H:%M:%S) - ERROR: ${1}!"
  exit
}

# Show message
ShowMessage(){
  echo "$(date +%Y-%m-%d_%H:%M:%S) - ${1}"
}

# Check dir
checkDirExist(){
  if [[ ! -d "$1" ]]; then
      ShowError "$2"
  fi
}

# Check file
checkFileExist(){
  if [[ ! -f "$1" ]]; then
      ShowError "$2"
  fi
}

# Check files and dir
checkCfg(){
  # check exclude.txt
  checkFileExist "$1" "exclude.txt doesnt exist"

  # check backup files dir
  checkDirExist "$2" "backup files dir doesnt exist"

  # check backup db dir
  checkDirExist "$3" "backup db dir doesnt exist"

  # check target folder
  checkDirExist "$4" "target folder doesnt exist"

  # check ignore.txt
  checkFileExist "$5" "ignore.txt doesnt exist"
}

# Create archive
createArchive(){
  ShowMessage "COPY DIR: ${1}"

  # Check ignore domain
  if [[ " ${ignoreArray[@]} " =~ " $(basename ${1}) " ]]; then
      ShowMessage "IGNORE DIR: $(basename ${1})"
      return
  fi

  # Go to website dir
  # shellcheck disable=SC2164
  cd "${1}"

  # Copy files without ignore files in exclude.txt
  # shellcheck disable=SC2154
  rsync -az "${1}" "${backup_folder}" --exclude-from="${EXCLUDE_FILE}"

  # go to folder where is copy files
  # shellcheck disable=SC2164
  # shellcheck disable=SC2046
  cd "${backup_folder}"/$(basename "$PWD")

  # Create archive
  # shellcheck disable=SC2046
  # shellcheck disable=SC2035
  tar -cpzf "${backup_folder}"/$(basename "$PWD").tar.gz *

  # Delete folder
  # shellcheck disable=SC2115
  # shellcheck disable=SC2046
  rm -rf "${backup_folder}"/$(basename "$PWD")
}

# Create DB dump
createDumpDb(){
  ShowMessage "CREATE DUMP DB"
  # shellcheck disable=SC2154
  mysqldump --login-path=backupdb --no-tablespaces "${DB_NAME}" > "${backup_db_dir}"/"${DB_NAME}"_"${DATE}".sql.gz
}

# Remote old DB dump
remoteDumpDb(){
  ShowMessage "REMOVE DUMP DB"
  find "${backup_db_dir}" -type f ! -name "${DB_NAME}_${DATE}.sql.gz" -delete
}

# Remote old DB dump
remoteDumpDbDay(){
  ShowMessage "REMOVE DUMP DB"
  find "${backup_db_dir}" -type d -mtime "${SAVE_DAYS}" -exec rm -rf {} \;
}

# Working Time
workTime(){
  END=$(date +%s)
  # shellcheck disable=SC2004
  WORKTIME=$(( $END - $START ))
  # shellcheck disable=SC2027
  ShowMessage "SCRIPT WORK TIME: "${WORKTIME}" sec."
}

# Delete old backups - day
removeOldDays(){
  ShowMessage "REMOVE OLD ARCHIVE"
  # shellcheck disable=SC2164
  cd "${BACKUP_DIR_DAY}"
  find "${BACKUP_DIR_DAY}" -type d -mtime "${SAVE_DAYS}" -exec rm -rf {} \;
}
