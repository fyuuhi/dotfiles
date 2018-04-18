#!/bin/sh

var=$(du -hs ~/)

var1=${var%/home/yfukuhar/}
var2=${var1/G/GB}

echo $var2

