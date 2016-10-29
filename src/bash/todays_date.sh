#!/bin/bash
# echo -n $(date +"%Y.%m.%d %a")|xsel -ib
# ISO 8601 format, plus weekday
echo -n $(date +"%Y-%m-%d %a")|xsel -ib