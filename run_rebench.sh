#!/bin/bash

# if no arguments, run the very fast minimal case
if [ "$#" -eq  "0" ]
then
     rebench --it 1 --in 1 -f --without-building -c ast-vs-bc.conf minimal
else
     rebench -f --without-building -c ast-vs-bc.conf $1
fi