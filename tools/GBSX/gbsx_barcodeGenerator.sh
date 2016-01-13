#!/usr/bin/env bash

#export PATH=$PATH:$(dirname $0)
#BASEDIR=$(dirname $0)

barcode=$1
enzyme=$2
barcode_list=$3
barcode_summary=$4

java -jar $GBSX_PATH/GBSX.jar --BarcodeGenerator -b $barcode -e $enzyme

awk '{print "sample" NR "\t" $1 "\t" var;}' var="$enzyme" barcode_list.txt > $barcode_list
cat barcode_summary.txt > $barcode_summary
