#!/bin/bash
set -x


rrfs_ioda_dir=`pwd`
export thisdate=20210413

allcyc="00"
alltmmark="tm06 tm05 tm04 tm03 tm02 tm01 tm00"

for icyc in $allcyc
do
  for itmmark in $alltmmark
  do
    export itmmark
    export icyc
    sbatch convert_gsi_diags.sh $itmmark $icyc
  done
done
