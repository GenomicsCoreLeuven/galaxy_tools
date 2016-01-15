#!/usr/bin/env bash

#export PATH=$PATH:$(dirname $0)
#BASEDIR=$(dirname $0)


genome=$1
length=$2 
enzyme_combination=$3
dualEnzyme="0"
min_size=$4
max_size=$5
digest_bed=$6
digest_result=$7

awk 'BEGIN {n_seq=0;} /^>/ {if(n_seq%1==0){file=$1".fa"; sub(">","",file)} print >> file; n_seq++; print file >> "list.txt"; next;} { print >> file; }' < $genome 

case "$enzyme_combination" in
    ApeKI) 
            enzyme="ApeKI"
            cutsite="G^CWGC"
    ;;
    PstI) 
            enzyme="PstI"
            cutsite="CTGCA^G"
    ;;
    EcoT22I) 
            enzyme="EcoT22I"
            cutsite="ATGCA^T"
    ;;
    PasI) 
            enzyme="PasI"
            cutsite="CC^CWGGG"
    ;;
    HpaII) 
            enzyme="HpaII"
            cutsite="C^CGG"
    ;;
    MspI) 
            enzyme="MspI"
            cutsite="C^CGG"
    ;;
    PstI-EcoT22I) 
            dualEnzyme="1"
            enzyme="PstI"
            cutsite="CTGCA^G"
            enzyme2="EcoT22I"
            cutsite2="ATGCA^T";
    ;;
    PstI-MspI) 
            dualEnzyme="1"
            enzyme="PstI"
            cutsite="CTGCA^G"
            enzyme2="MspI"
            cutsite2="C^CGG"
    ;;
    PstI-TaqI) 
            dualEnzyme="1"
            enzyme="PstI"
            cutsite="CTGCA^G"
            enzyme2="TaqI"
            cutsite2="T^CGA"
    ;;
    SbfI-MspI) 
            dualEnzyme="1"
            enzyme="SbfI"
            cutsite="CCTGCA^GG"
            enzyme2="MspI"
            cutsite2="C^CGG"
    ;;
    AsiSI-MspI) 
            dualEnzyme="1"
            enzyme="AsiSI"
            cutsite="GCCGAT^CGC"
            enzyme2="MspI"
            cutsite2="C^CGG"
    ;;
    BssHII-MspI) 
            dualEnzyme="1"
            enzyme="BssHII"
            cutsite="G^CGCGC"
            enzyme2="MspI"
            cutsite2="C^CGG"
    ;;
    FseI-MspI) 
            dualEnzyme="1"
            enzyme="FseI"
            cutsite="GGCCGG^CC"
            enzyme2="MspI"
            cutsite2="C^CGG"
    ;;
    SalI-MspI) 
            dualEnzyme="1"
            enzyme="SalI"
            cutsite="G^TCGAC"
            enzyme2="MspI"
            cutsite2="C^CGG"
    ;;
    ApoI) 
            enzyme="ApoI"
            cutsite="R^AATTY"
    ;;
    BamHI) 
            enzyme="BamHI"
            cutsite="G^GATCC"
    ;;
    MseI) 
            enzyme="MseI"
            cutsite="T^TAA"
    ;;
    Sau3AI) 
            enzyme="Sau3AI"
            cutsite="^GATC"
    ;;
    RBSTA) 
            enzyme="RBSTA"
            cutsite="^TA"
    ;;
    RBSCG) 
            enzyme="RBSCG"
            cutsite="^CG"
    ;;
    NspI) 
            enzyme="NspI"
            cutsite="RCATG^Y"
    ;;
    AvaII) 
            enzyme="AvaII"
            cutsite="G^GWCC"
    ;;
esac

extraparameters="";
if [ "$dualEnzyme" != "0" ];
then
    extraparameters="-E $enzyme2 -D $cutsite2";
fi

perl $GBSX_PATH/GBSX_digest.pl -f list.txt -l $length -d $cutsite -e $enzyme $extraparameters -n $min_size -m $max_size;

rm *.fa;
rm list.txt;

if [ "$dualEnzyme" != "0" ];
then
    cat "genome."$enzyme"."$enzyme2"."$length"nt.digest.bed" > $digest_bed;
    cat "genome."$enzyme"."$enzyme2"."$length"nt.digest_results" > $digest_result;
else
    cat "genome."$enzyme"."$length"nt.digest.bed" > $digest_bed;
    cat "genome."$enzyme"."$length"nt.digest_results" > $digest_result;
fi


