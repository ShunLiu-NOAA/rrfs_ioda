#!/bin/bash

set -x
module purge
module load compiler_mpi/ips/19.1.2/impi/19.1.2
module load core_third/ips/19.1.2.254  impi/19.1.2
module load gnu/4.8.5
module load EnvVars/1.0.3 lsf/10.1 HPSS/5.0.2.5 prod_util/1.1.0
module list

thisdate=`$NDATE -24 | cut -c1-8`
echo $thisdate
allcyc='00 12'

for cyc in $allcyc
do
  cd /gpfs/dell5/ptmp/Shun.Liu/fv3lamda/fv3lamda.${thisdate}/$cyc
  mv diag.$thisdate diag.${thisdate}_$cyc
  htar cf /NCEPDEV/emc-da/1year/Shun.Liu/diag.${thisdate}_${cyc}.tar diag.${thisdate}_$cyc
done
