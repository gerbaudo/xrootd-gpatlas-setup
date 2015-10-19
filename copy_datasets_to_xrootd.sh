#!/bin/env bash

# Script to create on the nodes the xrootd directories

# This is the directory structure suggested by Doug Benjamin, see
# email thread on 2015-01-16. The directories should be owned by
# xrootd.
# Note to self: for the ssh options, see
# http://serverfault.com/questions/625641/how-can-i-run-arbitrarily-complex-command-using-sudo-over-ssh

# davide.gerbaudo@gmail.com
# Jan 2015

readonly copy_user="gerbaudo"
readonly xrootd_destination_base_dir="/atlas/local/${copy_user}/test2/SusyNt"

# we want to always run this script as ucintprod
function check_user() {
    echo "check_user : todo"
}


function copy_files_dataset() {
    if [[ $# -gt 2 ]]; then # if wrong args, silently continue (we've complained already before)
        local dest_dir="$1"
        local file_names="${@:2}"
        local file_name=""
        local dest_file_name=""
        for file_name in ${file_names}
        do
            dest_file_name=$(basename ${file_name})
            echo "xrdcp ${file_name} root://gpatlas2-ib.local:1094/${xrootd_destination_base_dir}/${dest_dir}/${dest_file_name}"
            xrdcp ${file_name} root://gpatlas2-ib.local:1094/${xrootd_destination_base_dir}/${dest_dir}/${dest_file_name}
        done
        
    fi
}

function copy_datasets() {
    echo "n of args $#"
    if [[ $# -ge 2 ]]; then # if wrong args, silently continue (we've complained already before)
        local production="$1"
        local dataset_directories="${@:2}"
        local dataset_dir=""
        local dataset_name=""
        local dest_dir=""
        local file_names=""
        local file_name=""
        echo "prod ${production}"
        
        for dataset_dir in ${dataset_directories}
        do
            dataset_name=$(basename ${dataset_dir})
            if [[ -d ${dataset_dir} ]]; then
                dataset_name=$(basename ${dataset_dir})
                file_names=$(find ${dataset_dir} -maxdepth 1 -name "*.root*" -type f)                
                dest_dir="${production}/${dataset_name}"
                echo "ds: ${dataset_name}"
                echo "xrdfs root://gpatlas2-ib.local:1094/ mkdir -p ${xrootd_destination_base_dir}/${dest_dir}/"
                xrdfs root://gpatlas2-ib.local:1094/ mkdir -p ${xrootd_destination_base_dir}/${dest_dir}/
                copy_files_dataset ${dest_dir} ${file_names}
            else
                echo "not a dir, skipping ${dataset_dir}"
            fi
        done
    fi
}



function ls_directories () {
    local production="$1"
    local samplename="$2"
    local dest_dir="${production}/${samplename}"
    local nodes="c-12-15 c-12-19 c-12-23 c-12-27 c-12-31 c-12-35 c-12-39"
    local node=""
    local user="${copy_user}"
    for node in ${nodes}; do
        echo "ls on ${node} -> ${dest_dir}"
        ssh -tq ${node} " sudo -u xrootd bash -c \" ls  /scratch/atlas/local/${user}/SusyNt/${dest_dir}/*   \""
        echo "ls on ${node} -> SusyNt"
        ssh -tq ${node} " sudo -u xrootd bash -c \" ls  /scratch/atlas/local/${user}/SusyNt/   \""
    done
}

# check_user
# create_production_directories $1 $2
copy_datasets $*

# ls_directories $*
