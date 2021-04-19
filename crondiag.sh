#!/bin/bash

module load EnvVars/1.0.3 lsf/10.1 HPSS/5.0.2.5 prod_util/1.1.0

thisdate=`$NDATE -48 | cut -c1-8`
echo $thisdate
allcyc='00 12'

for cyc in $allcyc
do
  cd /gpfs/dell5/ptmp/Shun.Liu/fv3lamda/fv3lamda.${thisdate}/$cyc
  mv diag.$thisdate diag.${thisdate}_$cyc
  htarc diag.${thisdate}_$cyc
done
