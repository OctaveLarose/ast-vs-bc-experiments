#!/bin/bash

rebench -d -v -f --setup-only ast-vs-bc.conf all ${1:-all-normal} s:*:List
rebench -f --without-building -c ast-vs-bc.conf ${1:-all-normal} s:* 