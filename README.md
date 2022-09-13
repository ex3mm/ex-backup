## Описание
Скрипт создания резервных копий сайтов или обычных папок. 
После запуска, скрипт создает папку хранения бекапа. Имя папки = время запуска скрипта.
Каждая папка обработанная скриптом создает отдельный архив tar.gz и добавляет их в созданную папку бекапа.

---

## Файлы и папки
settings.cfg
> Конфигурационный файл .Содержит настройки и пути к файлам и папкам

exclude.txt
> Содержит названия файлов, папок, расширений которые скрипт будет игнорировать.
> Одна строка = одно значение

ignore.txt
> Содержит список сайтов (папки) которые скрипт будет игнорировать
> Одна строка = одно значение

bin
> Папка содержащая исполняемые скрипты
>> ex-backup-day.sh - скрипт ежедневного бекапа
>>
>> ex-backup-week.sh - скрипт еженедельного бекапа
>>
>> ex-backup-month.sh - скрипт ежемесячного бекапа

logs
> хранение логов работы скрипта

backup
> Хранение бекапов
> 
> db - базы данных
>> day - Ежедневные бекапы
>>
>> week - Еженедельные бекапы
>>
>> month - Ежемесячные бекапы
> 
> files - архивы файлов
>> day - Ежедневные бекапы
>>
>> week - Еженедельные бекапы
>>
>> month - Ежемесячные бекапы

---

## Настройка скрипта
- Переходим в папку скрипта
- Делаем файлы исполняемые
> chmod u+x bin/ex-backup-day.sh
> 
> chmod u+x bin/ex-backup-week.sh
> 
> chmod u+x bin/ex-backup-month.sh
- Создаем и настраиваем файл settings.cfg
> cp exemple.settings.cfg settings.cfg
> 
> Указываем актуальные пути до файлов и папок

- Создаем и заполняем файл ignore.txt
> cp exemple.ignore.txt ignore.txt
>
> Указываем актуальные пути до файлов и папок

- Создаем конфиг файл для дампа БД
> mysql_config_editor set --login-path="CONFIG_NAME" --host="localhost" --user="BD_USER" --password

> Далее указываете пароль от бд

> Посмотреть конфиг файл:
>
> mysql_config_editor print --login-path="CONFIG_NAME"

> Запрос будет выглядеть как
>
> mysqldump --login-path=CONFIG_NAME DB_NAME > DB_DUMP_NAME.sql
> 
> или если присутствует ошибка Error: 'Access denied; you need (at least one of) the PROCESS privilege(s) for this operation' when trying to dump tablespaces
> 
> mysqldump --login-path=CONFIG_NAME --no-tablespaces DB_NAME > DB_DUMP_NAME.sql

---

## Запуск скрипта (вручную)
- Запуск ежедневного бекапа
> /{путь до папки с скриптами}/ex-backup/bin/ex-backup-day.sh

- Запуск еженедельного бекапа
> /{путь до папки с скриптами}/ex-backup/bin/ex-backup-week.sh

- Запуск ежемесячного бекапа
> /{путь до папки с скриптами}/ex-backup/bin/ex-backup-month.sh

- Запуск ежедневного бекапа с логированием
> /{путь до папки с скриптами}/ex-backup/bin/ex-backup-day.sh >> /{путь до папки с скриптами}/ex-backup/logs/day.log

---

## Запуск скрипта (CRON)
> 1 6 * * * /{путь до папки с скриптами}/ex-backup/bin/ex-backup-day.sh >> /{путь до папки с скриптами}/ex-backup/logs/day.log
>
> 2 5 1,6,13,19,25 * * /{путь до папки с скриптами}/ex-backup/bin/ex-backup-week.sh >> /{путь до папки с скриптами}/ex-backup/logs/week.log
>
> 3 7 13 * * /{путь до папки с скриптами}/ex-backup/bin/ex-backup-month.sh >> /{путь до папки с скриптами}/ex-backup/logs/month.log
---

## Ошибки в работе
- Файл не сможет добавить в архив файлы и папки которые начинаются не с цифр или букв
- Если при дампе бд возникает ошибка 
> mysqldump: Error: 'Access denied; you need (at least one of) the PROCESS privilege(s) for this operation' when trying to dump tablespaces
>
>используйте в запросе конструкцию --no-tablespaces
