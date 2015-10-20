#!/bin/bash
for x in c-12-15 c-12-19 c-12-23 c-12-27 c-12-31 c-12-35 c-12-39
do
    ssh -t $x 'sudo -u xrootd bash -c "sudo service xrootd start"'
    ssh -t $x 'sudo -u xrootd bash -c "sudo service cmsd start"'
done
