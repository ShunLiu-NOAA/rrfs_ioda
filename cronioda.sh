set -x

function iodaconverter {
  tmmark=$1
  cyc=$2
# tmmark="tm06"
# echo $tmmark
  INPUTDIAG=/scratch2/NCEPDEV/stmp3/Shun.Liu/IODA/diag.20210413/${cyc}.${tmmark}
  rundir=/scratch2/NCEPDEV/stmp3/Shun.Liu/IODA/tmpnwprd/20210413_${cyc}_${tmmark}
  GSIDIAG=$rundir/GSI_diags
  mkdir -p $GSIDIAG
  cp $INPUTDIAG/diag_conv*ges* $GSIDIAG

  cd $GSIDIAG
  gunzip *.gz

  fl=`ls -1 diag*`
  for ifl in $fl
  do
  leftpart=`basename $ifl .nc4`
  flnm=${leftpart}_ensmean.nc4
  echo $flnm
  mv $ifl $flnm
  done

  cd $rrfs_ioda_dir
  OutDir=$rundir
  sbatch convert_gsi_diags.sh $OutDir
}

rrfs_ioda_dir=`pwd`
allcyc="00"
alltmmark="tm06 tm05 tm04 tm03 tm02 tm01 tm00"

for icyc in $allcyc
do
  for itmmark in $alltmmark
  do
    iodaconverter $itmmark $icyc
  exit
  done
done
