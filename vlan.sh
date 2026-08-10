#!/bin/sh

ARGS=$(getopt --options dhi: --longoptions delete,help,id: -- "$@")

if [ $? != 0 ]; then
    unset ARGS

    exit 1;
fi

eval set -- "${ARGS}"
unset ARGS

ID=""
DELETE=0

while true; do
    case "$1" in
    -h|--help)
        exit 0
        ;;
    -i|--id)
        if [ -n "${ID}" ]; then
            ID="${ID} ${2}"
        else
            ID=$2
        fi
        shift 2
        ;;
    -d|--delete)
        DELETE=1
        shift
        ;;
    --)
        shift
        break;;
    ?)
        exit 1
        ;;
    esac
done


LINK=${1:-eth0}

if [ -n "${ID}" ]; then
    for i in ${ID}; do
        if [ ${DELETE} = 0 ]; then
            printf "Creating %s VLAN id %s\n" "${LINK}.${i}" "${i}"

            ip link add link ${LINK} name ${LINK}.${i} type vlan id ${i}
            ip link set ${LINK}.${i} up
        else
            printf "Removing %s VLAN id %s\n" "${LINK}.${i}" "${i}"
            
            ip link set ${LINK}.${i} down
            ip link delete ${LINK}.${i}

        fi
    done

    unset i
fi


