#!/bin/bash
# ----------------------------------------------------------------------------------------------------
# NAME:    DATA.BACKUP.SH
# DESC:    BACKUP CONFIGS AND OTHER FILES AND FOLDERS
# DATE:    15.07.2018
# LANG:    BASH
# AUTOR:   LAGUTIN R.A.
# CONTACT: RLAGUTIN@MTA4.RU
# ----------------------------------------------------------------------------------------------------
#
# Scheduling: 0 0 * * * /backup/data.backup.sh exec

# ----------------------------------------------------------------------------------------------------
# VARIABLES
# ----------------------------------------------------------------------------------------------------

# DATE FORMAT
# BACKUP_DATE=`date +%Y.%m.%d`
BACKUP_DATE=$(date +%Y-%m-%d.%H-%M-%S)

# HOSTNAME
#HOSTNAME=`uname -n`
HOST=$(hostname -s) # Short name
DOM=$(hostname -d)  # Domain name
IP=$(hostname -i)   # IP

# BACKUP DATA
BACKUP_DATA=()
BACKUP_DATA+=("/etc/my.cnf")
BACKUP_DATA+=("/etc/nginx/")
BACKUP_DATA+=("/opt/atlassian/jira/")
BACKUP_DATA+=("/opt/atlassian/confluence/")
BACKUP_DATA+=("/var/atlassian/application-data/jira/")
BACKUP_DATA+=("/var/atlassian/application-data/confluence/")

# BACKUP
BACKUP_DIR=/backup
BACKUP_ROT=1440 # Delete backup old min. 1 day = 1440 min
# BACKUP_ROT=1

# BACKUP THRESHOLD
BACKUP_DISK=$BACKUP_DIR # backup mount dir
BACKUP_DISK_THRESHOLD=10 # free space, precent %

# MAIL
MAIL_SERVER="mail.example.com:25" # Example mail.example.com:25 or localhost:25
MAIL_FROM="Backup Data and Configs <$HOST@example.com>" # MAIL_FROM
MAIL_TO="lagutin_ra@example.com" # Delimiter space
# MAIL_TO="user1@example.com"
# MAIL_TO="user2@example.com"
# MAIL_TO="user3@example.com"
# MAIL_TO="user1@example.com user2@example.com user3@example.com"
# MAIL_VERBOSE="ONLY_FAIL"
# MAIL_VERBOSE="FAIL_OK"
# MAIL_VERBOSE="OK"
MAIL_VERBOSE=

# SCRIPT
SCRIPT_FILE=$0
SCRIPT_ARGS=$@
SCRIPT_LOG=${BACKUP_DIR}/$(basename $SCRIPT_FILE).${BACKUP_DATE}.log

# BASH COLOR
SETCOLOR_BLUE="echo -en \\033[1;34m"
SETCOLOR_WHITE="echo -en \\033[0;39m"
SETCOLOR_BLACK="echo -en \\033[0;30m"
SETCOLOR_RED="echo -en \\033[0;31m"
SETCOLOR_GREEN="echo -en \\033[0;32m"
SETCOLOR_CYAN="echo -en \\033[0;36m"
SETCOLOR_MAGENTA="echo -en \\033[1;31m"
SETCOLOR_LIGHTRED="echo -en \\033[1;31m"
SETCOLOR_YELLOW="echo -en \\033[1;33m"
SETCOLOR_BLACK_BG="echo -en \\033[0;40m"
SETCOLOR_RED_BG="echo -en \\033[0;41m"
SETCOLOR_GREEN_BG="echo -en \\033[0;42m"

# ----------------------------------------------------------------------------------------------------
# FUNCTIONS
# ----------------------------------------------------------------------------------------------------

function LOG() {

    if [ ! -d $BACKUP_DIR ]; then

        mkdir -p $BACKUP_DIR

    fi

    : > $SCRIPT_LOG # create log file

    #clear
    exec &> >(tee -a $SCRIPT_LOG) # Save script stdout, stdin to logfile

}

function RUN() {

    $SETCOLOR_BLUE; echo -en 'РЕЗЕРВНОЕ КОПИРОВАНИЕ КОНФИГУРАЦИОННЫХ ФАЙЛОВ И ДРУГИХ ФАЙЛОВ И ПАПОК.';$SETCOLOR_WHITE; echo -e
    $SETCOLOR_CYAN; echo -en '----------------------------------------------------------------------------------------------------';$SETCOLOR_WHITE; echo -e

    echo -en "DATE: "; $SETCOLOR_YELLOW; echo -en $BACKUP_DATE; $SETCOLOR_WHITE; echo -e
    echo -en "EXEC: "; $SETCOLOR_YELLOW; echo -en $SCRIPT_FILE $SCRIPT_ARGS; $SETCOLOR_WHITE; echo -e
    echo -e
    echo -en "HOST: "; $SETCOLOR_YELLOW; echo -en $HOST; $SETCOLOR_WHITE; echo -e
    echo -en "DOM:  "; $SETCOLOR_YELLOW; echo -en $DOM; $SETCOLOR_WHITE; echo -e
    echo -en "IP:   "; $SETCOLOR_YELLOW; echo -en $IP; $SETCOLOR_WHITE; echo -e
    echo -e
    echo -en "BACKUP_DIR: "; $SETCOLOR_YELLOW; echo -en $BACKUP_DIR; $SETCOLOR_WHITE; echo -e
    echo -en "BACKUP_ROT: "; $SETCOLOR_YELLOW; echo -en $BACKUP_ROT; $SETCOLOR_WHITE; echo -e
    echo -e
    echo -en "BACKUP_DISK:           "; $SETCOLOR_YELLOW; echo -en $BACKUP_DISK; $SETCOLOR_WHITE; echo -e
    echo -en "BACKUP_DISK_THRESHOLD: "; $SETCOLOR_YELLOW; echo -en $BACKUP_DISK_THRESHOLD'%'; $SETCOLOR_WHITE; echo -e
    echo -e
    echo -en "MAIL_SERVER:  "; $SETCOLOR_YELLOW; echo -en $MAIL_SERVER; $SETCOLOR_WHITE; echo -e
    echo -en "MAIL_FROM:    "; $SETCOLOR_YELLOW; echo -en $MAIL_FROM; $SETCOLOR_WHITE; echo -e
    echo -en "MAIL_TO:      "; $SETCOLOR_YELLOW; echo -en $MAIL_TO; $SETCOLOR_WHITE; echo -e
    echo -en "MAIL_VERBOSE: "; $SETCOLOR_YELLOW; echo -en $MAIL_VERBOSE; $SETCOLOR_WHITE; echo -e
    echo -e
    echo -en "SCRIPT_FILE: "; $SETCOLOR_YELLOW; echo -en $SCRIPT_FILE; $SETCOLOR_WHITE; echo -e
    echo -en "SCRIPT_ARGS: "; $SETCOLOR_YELLOW; echo -en $SCRIPT_ARGS; $SETCOLOR_WHITE; echo -e
    echo -en "SCRIPT_LOG:  "; $SETCOLOR_YELLOW; echo -en $SCRIPT_LOG; $SETCOLOR_WHITE; echo -e
    $SETCOLOR_CYAN; echo -en '----------------------------------------------------------------------------------------------------';$SETCOLOR_WHITE; echo -e

}

function HELP() {

    $SETCOLOR_BLUE; echo -en 'Параметры запуска';$SETCOLOR_WHITE; echo -e
    echo -e
    $SETCOLOR_YELLOW; echo -en "$0 {exec}";$SETCOLOR_WHITE; echo -e

}

function ELAPSED_TIME_BEFORE() {

    DATE_BEFORE=$(date +%s)

}

function ELAPSED_TIME_AFTER() {

    DATE_AFTER="$(date +%s)"
    ELAPSED="$(expr $DATE_AFTER - $DATE_BEFORE)"
    HOURS=$(($ELAPSED / 3600))
    ELAPSED=$(($ELAPSED - $HOURS * 3600))
    MINUTES=$(($ELAPSED / 60))
    SECONDS=$(($ELAPSED - $MINUTES * 60))

    echo -e
    echo -en "Время выполнения: "; $SETCOLOR_RED;
    echo -en "$HOURS часов $MINUTES минут $SECONDS сек"
    $SETCOLOR_WHITE;
    echo -e; echo -e

}

function SEND_MAIL() {

    if [ -f $SCRIPT_LOG ]; then

        local MAILSUB="BACKUP DATA AND CONFIGS: ${HOST}"

        # cat "$SCRIPT_LOG" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"
        if [ "$(cat $SCRIPT_LOG | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | grep -wi -e "warn" -e "err" -e "error" -e "fatal" -e "fail" -e "crit" -e "critical" -e "panic")" ]; then

            local MAILSUB=$MAILSUB' - FAIL'
            local EXEC_STATUS="FAIL"

        else

            local MAILSUB=$MAILSUB' - OK'
            local EXEC_STATUS="OK"

        fi

        # echo $MAILSUB
        # echo $MAIL_SERVER
        # echo $MAIL_FROM
        # echo $MAIL_TO
        # echo $SCRIPT_LOG

        if [ "$MAIL_VERBOSE" == "ONLY_FAIL" ] && [ "$EXEC_STATUS" == "FAIL" ]; then

            cat $SCRIPT_LOG | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | $(which mail) -v \
              -S smtp="smtp://$MAIL_SERVER" \
              -s "$MAILSUB" \
              -S from="$MAIL_FROM" \
              "$MAIL_TO"

            local SEND_MAIL_STATUS="$?"
            local MAIL_STATUS="YES"

        elif [ "$MAIL_VERBOSE" == "OK" ] && [ "$EXEC_STATUS" == "OK" ]; then

            cat $SCRIPT_LOG | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | $(which mail) -v \
              -S smtp="smtp://$MAIL_SERVER" \
              -s "$MAILSUB" \
              -S from="$MAIL_FROM" \
              "$MAIL_TO"

            local SEND_MAIL_STATUS="$?"
            local MAIL_STATUS="YES"

        elif [ "$MAIL_VERBOSE" == "FAIL_OK" ]; then

            cat $SCRIPT_LOG | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | $(which mail) -v \
              -S smtp="smtp://$MAIL_SERVER" \
              -s "$MAILSUB" \
              -S from="$MAIL_FROM" \
              "$MAIL_TO"

            local SEND_MAIL_STATUS="$?"
            local MAIL_STATUS="YES"

        else

            local MAIL_STATUS="NOT"

        fi

    fi

    if [ "$MAIL_STATUS" == "YES" ]; then

        if [ "$SEND_MAIL_STATUS" != "0" ]; then

            echo -e
            $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' SEND_MAIL ';  $SETCOLOR_GREEN; echo -en '# эл. письмо должно быть отправлено.'; $SETCOLOR_WHITE; echo -e

        else

            echo -e
            $SETCOLOR_GREEN_BG; echo -en ' OK '; $SETCOLOR_WHITE; echo -en ' SEND_MAIL ';  $SETCOLOR_GREEN; echo -en '# эл. письмо должно быть отправлено.'; $SETCOLOR_WHITE; echo -e

        fi

    fi

}

function CHECK_ROOT() {

    if [ "$(id -u)" != "0" ]; then

        $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' CHECK_ROOT ';  $SETCOLOR_GREEN; echo -en '# '$SCRIPT_FILE' должен быть выполнен от суперпользователя root.'; $SETCOLOR_WHITE; echo -e
        SEND_MAIL; exit 1

    else

        $SETCOLOR_GREEN_BG; echo -en ' OK '; $SETCOLOR_WHITE; echo -en ' CHECK_ROOT ';  $SETCOLOR_GREEN; echo -en '# '$SCRIPT_FILE' должен быть выполнен от суперпользователя root.'; $SETCOLOR_WHITE; echo -e

    fi

}

# $1 - PROG NAME
function CHECK_PID() {

    if [ $(/usr/sbin/pidof -x $(which tar)) ] || [ $(/usr/sbin/pidof -x $(which gzip)) ] || [ $(/usr/sbin/pidof -x $(which gunzip)) ]; then

        $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' CHECK_PID ';  $SETCOLOR_GREEN; echo -en '# tar, gzip и gunzip не должны выполняется в момент запуска скрипта.'; $SETCOLOR_WHITE; echo -e
        SEND_MAIL; exit 1

    else

        $SETCOLOR_GREEN_BG; echo -en ' OK '; $SETCOLOR_WHITE; echo -en ' CHECK_PID ';  $SETCOLOR_GREEN; echo -en '# tar, gzip и gunzip не должны выполняется в момент запуска скрипта.'; $SETCOLOR_WHITE; echo -e

    fi

    # if [ $(ps -ef | grep -i "$1" | grep -v "grep" | wc -l) -gt 0 ]; then

    #     echo "Error: CHECK_PID - $1 already running."
    #     return 1

    # else

    #     return 0

    # fi

}


# $1 - $BACKUP_DIR
function CHECK_BACKUP_DIR() {

    local BACKUP_DIR=$1

    if [ ! -d $BACKUP_DIR ]; then

        mkdir -p $BACKUP_DIR

    fi

    if [ "$?" != "0" ]; then

        $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' CHECK_BACKUP_DIR ';  $SETCOLOR_GREEN; echo -en '# создание папки рез. копии '$BACKUP_DIR; $SETCOLOR_WHITE; echo -e
        SEND_MAIL; exit 1

    else

        $SETCOLOR_GREEN_BG; echo -en ' OK '; $SETCOLOR_WHITE; echo -en ' CHECK_BACKUP_DIR ';  $SETCOLOR_GREEN; echo -en '# создание папки рез. копии '$BACKUP_DIR; $SETCOLOR_WHITE; echo -e

    fi

}

# $1 - $BACKUP_DISK
# $2 - $BACKUP_DISK_THRESHOLD
function CHECK_FREE_DISK_SPACE() {

    # local check_free_disk_space=$(df -k $1 | tail -n1 | awk -F " " '{print($4)}' | awk -F "%" '{print($1)}' | awk '{print($1)}') # AIX
    local check_free_disk_space=$(df -k $1 | tail -n1 | awk -F " " '{print($5)}' | awk -F "%" '{print($1)}' | awk '{print($1)}') # Linux
    # echo $check_free_disk_space

    if [ $(( 100 - check_free_disk_space )) -ge $2 ]; then

        $SETCOLOR_GREEN_BG; echo -en ' OK '; $SETCOLOR_WHITE; echo -en ' CHECK_FREE_DISK_SPACE ';  $SETCOLOR_GREEN; echo -en '# свободное место на диске хранения рез. копий '$check_free_disk_space'% должно быть > чем threshold '$2'%.'; $SETCOLOR_WHITE; echo -e

    else

        $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' CHECK_FREE_DISK_SPACE ';  $SETCOLOR_GREEN; echo -en '# свободное место на диске хранения рез. копий '$check_free_disk_space'% должно быть > чем threshold '$2'%.'; $SETCOLOR_WHITE; echo -e
        SEND_MAIL; exit 1

    fi

}

# $1 - $BACKUP_DIR
function CREATE_BACKUP() {

    local BACKUP_DIR=$1

    for BACKUP_ITEM in ${BACKUP_DATA[*]}; do

        if [ -e $BACKUP_ITEM ]; then

            BACKUP_FILE=$BACKUP_ITEM
            BACKUP_FILE=${BACKUP_FILE////.}
            BACKUP_FILE=${BACKUP_FILE//../.}
            BACKUP_FILE=$(echo $BACKUP_FILE | sed 's/^\.//')
            BACKUP_FILE=$(echo ${BACKUP_FILE/%./})
            # echo $BACKUP_FILE

            if [ -z "$BACKUP_FILE" ] || [ "$BACKUP_FILE" == "" ]; then

                $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' CREATE_BACKUP ';  $SETCOLOR_GREEN; echo -en '# резервное копирование '$BACKUP_ITEM; $SETCOLOR_WHITE; echo -e

            else

                if [ -f $BACKUP_ITEM ]; then

                    local CREATE_BACKUP_VAR=$(which tar)' czfp '$BACKUP_DIR'/'$BACKUP_FILE'.'$BACKUP_DATE'.tgz '$BACKUP_ITEM

                elif [ -d $BACKUP_ITEM ]; then

                    local CREATE_BACKUP_VAR=$(which tar)' czfp '$BACKUP_DIR'/'$BACKUP_FILE'.'$BACKUP_DATE'.tgz -C '$BACKUP_ITEM' . --warning=no-file-ignored'

                fi

                $SETCOLOR_CYAN

                echo -en $CREATE_BACKUP_VAR; echo -e

                $CREATE_BACKUP_VAR
                local CREATE_BACKUP_VAR_STATUS="$?"

                $SETCOLOR_WHITE

                if [ "$CREATE_BACKUP_VAR_STATUS" = "0" ]; then

                    # $SETCOLOR_GREEN_BG; echo -en ' OK '; $SETCOLOR_WHITE; echo -en ' CREATE_BACKUP ';  $SETCOLOR_GREEN; echo -en '# резервное копирование '$BACKUP_ITEM; $SETCOLOR_WHITE; echo -e
                    local CREATE_BACKUP_TEST_VAR=$(which gunzip)' -t '$BACKUP_DIR'/'$BACKUP_FILE'.'$BACKUP_DATE'.tgz'

                    $SETCOLOR_CYAN

                    echo -en $CREATE_BACKUP_TEST_VAR; echo -e

                    $CREATE_BACKUP_TEST_VAR
                    local CREATE_BACKUP_TEST_VAR_STATUS="$?"

                    $SETCOLOR_WHITE

                    if [ "$CREATE_BACKUP_TEST_VAR_STATUS" = "0" ]; then

                        $SETCOLOR_GREEN_BG; echo -en ' OK '; $SETCOLOR_WHITE; echo -en ' CREATE_BACKUP ';  $SETCOLOR_GREEN; echo -en '# резервное копирование '$BACKUP_ITEM; $SETCOLOR_WHITE; echo -e

                    else

                        $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' CREATE_BACKUP ';  $SETCOLOR_GREEN; echo -en '# резервное копирование '$BACKUP_ITEM; $SETCOLOR_WHITE; echo -e

                    fi

                else

                    $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' CREATE_BACKUP ';  $SETCOLOR_GREEN; echo -en '# резервное копирование '$BACKUP_ITEM; $SETCOLOR_WHITE; echo -e

                fi

            fi

        else

            $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' CREATE_BACKUP ';  $SETCOLOR_GREEN; echo -en '# резервное копирование '$BACKUP_ITEM'.'; $SETCOLOR_WHITE; echo -e

        fi

    done

}

# $1 - $BACKUP_DIR
# $2 - $BACKUP_ROT
function DEL_OLD_BACKUP() {

    local BACKUP_DIR=$1
    local BACKUP_ROT=$2

    for BACKUP_ITEM in ${BACKUP_DATA[*]}; do

        if [ -e $BACKUP_ITEM ]; then

            BACKUP_FILE=$BACKUP_ITEM
            BACKUP_FILE=${BACKUP_FILE////.}
            BACKUP_FILE=${BACKUP_FILE//../.}
            BACKUP_FILE=$(echo $BACKUP_FILE | sed 's/^\.//')
            BACKUP_FILE=$(echo ${BACKUP_FILE/%./})
            # echo $BACKUP_FILE

            if [ -z "$BACKUP_FILE" ] || [ "$BACKUP_FILE" == "" ]; then

                $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' DEL_OLD_BACKUP ';  $SETCOLOR_GREEN; echo -en '# определение названия файла рез. копии для бэкапа '$BACKUP_ITEM; $SETCOLOR_WHITE; echo -e

            else

                for DEL_BACKUP in $(find $BACKUP_DIR -type f -name "*$BACKUP_FILE.*" -mmin +$BACKUP_ROT 2>/dev/null); do

                    rm -f "$DEL_BACKUP"

                    if [ "$?" != "0" ]; then

                        $SETCOLOR_RED_BG; echo -en 'FAIL'; $SETCOLOR_WHITE; echo -en ' DEL_OLD_BACKUP ';  $SETCOLOR_GREEN; echo -en '# удаление бэкапа '$DEL_BACKUP' старше чем '$BACKUP_ROT' минут.'; $SETCOLOR_WHITE; echo -e
                        SEND_MAIL; exit 1

                    else

                        $SETCOLOR_GREEN_BG; echo -en ' OK '; $SETCOLOR_WHITE; echo -en ' DEL_OLD_BACKUP ';  $SETCOLOR_GREEN; echo -en '# удаление бэкапа '$DEL_BACKUP' старше чем '$BACKUP_ROT' минут.'; $SETCOLOR_WHITE; echo -e

                    fi

                done

            fi

        fi

    done

}

# ----------------------------------------------------------------------------------------------------
# MAIN

# LOG
# RUN
# HELP
# ELAPSED_TIME_BEFORE
# ELAPSED_TIME_AFTER
# SEND_MAIL
# CHECK_ROOT
# CHECK_PID
# CHECK_BACKUP_DIR
# CHECK_FREE_DISK_SPACE
# CREATE_BACKUP
# DEL_OLD_BACKUP
# ----------------------------------------------------------------------------------------------------

LOG; RUN

case $1 in

    exec)

        $SETCOLOR_WHITE; echo -en 'BACKUP DATA AND CONFIGS'; $SETCOLOR_WHITE; echo -e; echo -e

        ELAPSED_TIME_BEFORE; # sleep 2
        CHECK_ROOT; CHECK_PID "$SCRIPT_FILE"
        CHECK_BACKUP_DIR "$BACKUP_DIR"
        CHECK_FREE_DISK_SPACE "$BACKUP_DISK" "$BACKUP_DISK_THRESHOLD"
        CREATE_BACKUP "$BACKUP_DIR"
        DEL_OLD_BACKUP "$BACKUP_DIR" "$BACKUP_ROT"
        ELAPSED_TIME_AFTER
        SEND_MAIL
        exit 0

        ;;

    *)

        HELP
        exit 0

esac

