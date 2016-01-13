#!/usr/bin/env bash

#export PATH=$PATH:$(dirname $0)
#BASEDIR=$(dirname $0)


read1=$1
read2=$2
infofile=$3
barcodeMismatch=$4
enzymeMismatch=$5
rad_gbs_select=$6
demultiplex_stats=$7

extra=""
if [ "$read2" != "0" ];
then
    extra="-f2 $read2";
fi
mkdir gbsx_demultiplex;

java -jar $GBSX_PATH/GBSX.jar --Demultiplexer -o gbsx_demultiplex -f1 $read1 $extra -i $infofile -mb $barcodeMismatch -me $enzymeMismatch -rad $rad_gbs_select

cat gbsx_demultiplex/gbsDemultiplex.stats > $demultiplex_stats
rm gbsx_demultiplex/*.log
rm gbsx_demultiplex/*.stats
rm gbsx_demultiplex/undetermined*

