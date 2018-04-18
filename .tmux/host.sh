#!/bin/sh

var=$(echo $HOSTNAME)

var1=${var%.icepp.jp}
var2=${var1/login/icepp}

echo $var2

