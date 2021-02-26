#!/bin/bash

# This is a bash script I use to convert a word into every possible uppercase and lowercase combination
#
# EXAMPLE USAGE: 
# ./generate_all_uppercase_lowercase_combos_for_a_word.sh osbornepro
# osbornepro
# osborneprO
# osbornepRo
# osbornePro
# osbornEpro
# osborNepro
# osboRnepro
# osbOrnepro
# osBornepro......
 
TOUPPER=${1^^}
GETLEN=${#TOUPPER}

for ((permutation=0; permutation <= GETLEN; permutation++))
do

    for ((i=0; i <= GETLEN; i++))
    do
        lower=${TOUPPER,,}

        if [ $permutation -gt 0 ]
        then
            nth=${lower:permutation-1}
            lower=$(echo ${lower:0:permutation-1}${nth^})
        fi
        
        echo -n ${TOUPPER:0:i}
        echo ${lower:i}
        
    done

done | sort -u
