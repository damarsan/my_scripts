#!/bin/bash

TO_ADDRESS=""
FROM_ADDRESS=""
SUBJECT="Prueba de envio"
BODY="This is a linux mail system. Linux is one of the email operating systems which can be used to send and receive emails."

echo ${BODY}| mail -s ${SUBJECT} ${TO_ADDRESS} -- -r ${FROM_ADDRESS}
