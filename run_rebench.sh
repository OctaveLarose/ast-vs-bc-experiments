#!/bin/bash

rebench -d -v -f --setup-only --disable-data-reporting --experiment="Just building" codespeed.conf all ${1:-all-normal} s:*:List
rebench -f --without-building -c --experiment="Every optim removed individually" codespeed.conf ${1:-all-normal} s:* 