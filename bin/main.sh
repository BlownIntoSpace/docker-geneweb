#!/usr/bin/env bash

set -e

function startPortal()
{
    # Start GeneWeb
    #/opt/geneweb/gwd.sh -lang ${LANGUAGE} -p 2317
    gwd -lang ${LANGUAGE} -p 2317 
}

function ensureBackupPathExists()
{
    mkdir -p ${GENEWEB_DIR}/backup
}

function ensureImportPathExists()
{
    mkdir -p ${GENEWEB_DIR}
}

function startSetup()
{
    pushd ${GENEWEB_INSTALL_DIR} 1> /dev/null

        if [[ -n "${HOST_IP}" ]]; then
           echo "${HOST_IP}" > ${GENEWEB_INSTALL_DIR}/gw/only.txt
        fi

        ensureBackupPathExists
        ensureImportPathExists

        #DEFAULT_CONFIG="${HOME}/default.gwf"
        #if [[ ! -f ${DEFAULT_CONFIG} ]]; then
        #    cp /opt/geneweb/default.gwf ${DEFAULT_CONFIG}
        #fi

        #-only opt/geneweb/gw/only.txt

        # /opt/geneweb/gwsetup.sh -p 2316 -lang ${LANGUAGE} -bindir /opt/geneweb/gw/  | tee -a ${HOME}/gwsetup.log
        gwsetup -p 2316 -lang ${LANGUAGE} -bindir ${GENEWEB_INSTALL_DIR}/gw/  | tee -a ${GENEWEB_DIR}/gwsetup.log

    popd 1> /dev/null
}

function runBackup()
{
    # Run the backup of all GWB databases
    backup.sh
}

case "$1" in
        start-portal)
            startPortal
            ;;

        start-setup)
            startSetup
            ;;

        start-all)
            startSetup &
            startPortal
            ;;

        backup)
            runBackup
            ;;

        *)
            echo $"Usage: $0 {start-portal|start-setup|start-all|backup}"
            exit 1

esac
