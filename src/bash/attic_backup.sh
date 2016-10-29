#!/usr/bin/env bash

#BACKUP_URL="/media/j0sh/Backups/attic/"
BACKUP_URL="j0sh@192.168.0.104:/home/j0sh/backups/attic/"
GLOBAL_OPTIONS="-v --stats"
# these sizes are dumb! redo them!!!
# HOURLY="10"
# DAILY="10"
# WEEKLY="10"
# MONTHLY="10"
# YEARLY="10"
TIME="$(date +%Y_%m_%d_%H:%M.%S)"

attic create ${GLOBAL_OPTIONS} "${BACKUP_URL}::slash_${TIME}" /mnt/slash/
attic create ${GLOBAL_OPTIONS} "${BACKUP_URL}::j0sh_${TIME}" /mnt/home/j0sh \
        --exclude-caches --exclude /mnt/home/j0sh/.local/share/Trash

# attic prune ${GLOBAL_OPTIONS} \
#       -p j0sh_ \
#       -H ${HOURLY} \
#       -d ${DAILY} \
#       -w ${WEEKLY} \
#       -m ${MONTHLY} \
#       -y ${YEARLY} \
#       "${BACKUP_URL}"

# attic prune ${GLOBAL_OPTIONS} \
#       -p slash_ \
#       -H ${HOURLY} \
#       -d ${DAILY} \
#       -w ${WEEKLY} \
#       -m ${MONTHLY} \
#       -y ${YEARLY} \
#       "${BACKUP_URL}"
