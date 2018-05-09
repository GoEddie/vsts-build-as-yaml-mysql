#!/bin/sh

mysql --protocol=tcp -uroot -pmypassword -h$2 < $1
