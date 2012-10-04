#!/bin/bash

# Vacuums the Mail.app SQLITE3 database to improve responsiveness and size

MAIL_DB="${HOME}/Library/Mail/V2/MailData/Envelope Index"

if [ ! -f "${MAIL_DB}" ]; then
  echo "Cannot find mail database ${MAIL_DB}"
  exit 1
fi

DB_SIZE_PRE=`ls -lh "${MAIL_DB}" | awk '{ print $5 }'`

pgrep -q Mail

if [[ $? -eq 0 ]]; then
  echo "Cannot vacuum while Mail.app is running"
  exit 1
else
  echo -n "Reorganizing mail index..."
  sqlite3 "${MAIL_DB}" vacuum;
  echo "done"

  DB_SIZE_POST=`ls -lh "${MAIL_DB}" | awk '{ print $5 }'`

  echo ""
  echo "Mail index size before: ${DB_SIZE_PRE}"
  echo "Mail index size after: ${DB_SIZE_POST}"
  echo 
fi
