#!/bin/env bash

# Script to create on the nodes the xrootd directories

# This is the directory structure suggested by Doug Benjamin, see
# email thread on 2015-01-16. The directories should be owned by
# xrootd.
# Note to self: for the ssh options, see
# http://serverfault.com/questions/625641/how-can-i-run-arbitrarily-complex-command-using-sudo-over-ssh

# davide.gerbaudo@gmail.com
# Jan 2015

function create_xrootd_directories() {
    local nodes="c-12-15 c-12-19 c-12-23 c-12-27 c-12-31 c-12-35 c-12-39"
    local node=""
    for node in ${nodes}; do
        echo "running on ${node}"
        ssh -tq ${node} " sudo -u xrootd bash -c \" mkdir -p  /scratch/atlas/dq2   \""
        ssh -tq ${node} " sudo -u xrootd bash -c \" mkdir -p  /scratch/atlas/local \""
        echo
    done
}


function create_users_directories() {
    local nodes="c-12-15 c-12-19 c-12-23 c-12-27 c-12-31 c-12-35 c-12-39"
    local node=""
    local users=""
    local user=""
    users+=" amete"
    users+=" anelson"
    users+=" asoffa"
    users+=" ataffard"
    users+=" cshimmin"
    users+=" dantrim"
    users+=" gerbaudo"
    users+=" mfrate"
    users+=" nzhou"
    users+=" suneetu"
    users+=" ucintprod"
    users+=" whiteson"
    for node in ${nodes}; do
        echo "running on ${node}"
        for user in ${users}; do
            ssh -tq ${node} " sudo -u xrootd bash -c \" mkdir -p  /scratch/atlas/local/${user}   \""
        done
    done
}

# create_xrootd_directories
create_users_directories