##!/bin/bash
#echo ""
#echo "START"
#echo "DATE: $(date +%Y-%m-%d_%H:%M:%S)"
#
##exclude_file="/media/ex3mist/WEB/WORKING/backuper/script/exclude.txt"
##backup_dir="/media/ex3mist/WEB/WORKING/backuper/script/backup/files/week"
##backup_db_dir="/media/ex3mist/WEB/WORKING/backuper/script/backup/db/week"
##target_folder="/media/ex3mist/WEB/WORKING/backuper/script/www"
#
##exclude_file="/home/bitrix/backup/exclude.txt"
##backup_dir="/home/bitrix/backup/files/week"
##backup_db_dir="/home/bitrix/backup/db/week"
##target_folder="/home/bitrix/ext_www"
#
#date=$(date +%Y-%m-%d_%H:%M:%S)
#backup_folder=${backup_dir}/${date}
#START=$(date +%s)
#
##DB_NAME="dbedu-penza"
##DB_USER="useredu-penza"
##DB_PASSWORD="bEZ{RVf7faD@BDT"
#
#############################
#
#dreateArchive(){
#  echo "COPY DIR: $(date +%Y-%m-%d_%H:%M:%S) => ${fullDir}"
#  # Переходим в директорию
#  cd "$fullDir"
#
#  # Копируем файлы
#  rsync -az ${fullDir} ${backup_folder} --exclude-from="${exclude_file}"
#
#  # Архивируем
#  cd ${backup_folder}/$(basename "$PWD")
#  tar -cpzf ${backup_folder}/$(basename "$PWD").tar.gz *
#
#  # Удаляем папку
#  rm -rf ${backup_folder}/$(basename "$PWD")
#}
#
#############################
#
## Создаем папку для архивов
#mkdir "${backup_folder}"
#
## Получаем список сайтов/папок и запускаем цикл
#for fullDir in $(ls -d ${target_folder}/*)
#do
#  dreateArchive
#done
#
## Удаляем старые архивы
#echo "REMOVE OLD ARCHIVE"
#cd ${backup_dir}
#ls | grep -v ${date} | xargs rm -rf
#
############### DB ###############
#
## Создаем бекап бд
#echo "DUMP DB: $(date +%Y-%m-%d_%H:%M:%S)"
## mysqldump -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} | gzip > ${backup_db_dir}/${DB_NAME}_"${date}".sql.gz
#
## Удаляем старый бекап бд
#echo "REMOTE OLD DUMP DB"
## find ${backup_db_dir} -type f ! -name "${DB_NAME}_${date}.sql.gz" -delete
#
#END=$(date +%s)
#WORKTIME=$(( $END - $START ))
#echo "SCRIPT WORK TIME: "${WORKTIME}" sec."
#echo "END: $(date +%Y-%m-%d_%H:%M:%S)"
#exit