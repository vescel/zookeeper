#!/bin/bash

function zooHealth {
   if [ $(echo ruok | nc 127.0.0.1 2181) != 'imok' ]; then echo 0; else echo 1; fi
}


zooHealth

