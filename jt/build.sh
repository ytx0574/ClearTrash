#!/bin/bash

jtPath="/Users/`whoami`/Desktop/jt"

if [ -f "$jtPath" ]
then

cp $jtPath /usr/local/bin/jt
`chmod 777 /usr/local/bin/jt`

fi



