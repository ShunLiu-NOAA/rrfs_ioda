#!/bin/bash
#SBATCH -J convert_diags_jedi 
#SBATCH -A fv3-cam
#SBATCH -q batch
#SBATCH --nodes=1
#SBATCH -t 0:08:00
#SBATCH -o /scratch2/NCEPDEV/stmp3/Shun.Liu/RRFS_IODA/tmpnwprd/log/rrfs_ioda.out_%j
#SBATCH -e /scratch2/NCEPDEV/stmp3/Shun.Liu/RRFS_IODA/tmpnwprd/log/rrfs_ioda.err_%j
#SBATCH --mail-user=$LOGNAME@noaa.gov
#DATE=2018041500

# load modules here used to compile GSI
module purge
module use -a /scratch1/NCEPDEV/da/Cory.R.Martin/Modulefiles
module load modulefile.ProdGSI.hera
module list

# load python module from Stelios
module use -a /home/Stylianos.Flampouris/modulefiles
module load anaconda/2019.08.07
module load nccmp # for ctests


  echo $thisdate
  cyc=$2
  tmmark=$1
  IODACDir=/scratch2/NCEPDEV/fv3-cam/save/Shun.Liu/gsi/GSI_forJEDI/ush/JEDI/ioda-converters/build/bin
  IODAdir=/scratch2/NCEPDEV/stmp3/Shun.Liu/RRFS_IODA/IODA/$thisdate
  DIAGdir=/scratch2/NCEPDEV/stmp3/Shun.Liu/RRFS_IODA/DIAG/diag.${thisdate}_${cyc}/${cyc}.${tmmark}
  rundir=/scratch2/NCEPDEV/stmp3/Shun.Liu/RRFS_IODA/tmpnwprd/${thisdate}_${cyc}_${tmmark}
  OutDir=$rundir
  GSIDIAG=$rundir/GSI_diags
  mkdir -p $IODAdir
  rm -fr $GSIDIAG
  mkdir -p $GSIDIAG
  cp $DIAGdir/diag_conv*ges* $GSIDIAG

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

cd $IODACDir

rm -rf $OutDir/obs
rm -rf $OutDir/geoval
rm -rf $OutDir/log.proc_gsi_ncdiag
mkdir -p $OutDir/obs
mkdir -p $OutDir/geoval

#python ./proc_gsi_ncdiag.py -n 24 -o $OutDir/obs -g $OutDir/geoval $OutDir/GSI_diags
python ./proc_gsi_ncdiag.py -n 24 -o $OutDir/obs -g $OutDir/geoval $OutDir/GSI_diags

# subset obs
python ./subset_files.py -n 24 -m $OutDir/obs -g $OutDir/geoval
python ./subset_files.py -n 24 -s $OutDir/obs -g $OutDir/geoval

mv $rundir $IODAdir
exit

# combine conventional obs
python ./combine_conv.py -i $OutDir/obs/sfc_*m.nc4 -o $OutDir/obs/sfc_obs_"$DATE"_m.nc4 -g $OutDir/geoval/
python ./combine_conv.py -i $OutDir/obs/sfcship_*m.nc4 -o $OutDir/obs/sfcship_obs_"$DATE"_m.nc4 -g $OutDir/geoval/
python ./combine_conv.py -i $OutDir/obs/aircraft_*m.nc4 -o $OutDir/obs/aircraft_obs_"$DATE"_m.nc4 -g $OutDir/geoval/
python ./combine_conv.py -i $OutDir/obs/sondes_ps*m.nc4 $OutDir/obs/sondes_q*m.nc4 $OutDir/obs/sondes_tsen*m.nc4 $OutDir/obs/sondes_uv*m.nc4 -o $OutDir/obs/sondes_obs_"$DATE"_m.nc4 -g $OutDir/geoval/
python ./combine_conv.py -i $OutDir/obs/sondes_ps*m.nc4 $OutDir/obs/sondes_q*m.nc4 $OutDir/obs/sondes_tv*m.nc4 $OutDir/obs/sondes_uv*m.nc4 -o $OutDir/obs/sondes_tvirt_obs_"$DATE"_m.nc4 -g $OutDir/geoval/
python ./combine_conv.py -i $OutDir/obs/sfc_*s.nc4 -o $OutDir/obs/sfc_obs_"$DATE"_s.nc4 -g $OutDir/geoval/
python ./combine_conv.py -i $OutDir/obs/sfcship_*s.nc4 -o $OutDir/obs/sfcship_obs_"$DATE"_s.nc4 -g $OutDir/geoval/
python ./combine_conv.py -i $OutDir/obs/aircraft_*s.nc4 -o $OutDir/obs/aircraft_obs_"$DATE"_s.nc4 -g $OutDir/geoval/
python ./combine_conv.py -i $OutDir/obs/sondes_ps*s.nc4 $OutDir/obs/sondes_q*s.nc4 $OutDir/obs/sondes_tsen*s.nc4 $OutDir/obs/sondes_uv*s.nc4 -o $OutDir/obs/sondes_obs_"$DATE"_s.nc4 -g $OutDir/geoval/
python ./combine_conv.py -i $OutDir/obs/sondes_ps*s.nc4 $OutDir/obs/sondes_q*s.nc4 $OutDir/obs/sondes_tv*s.nc4 $OutDir/obs/sondes_uv*s.nc4 -o $OutDir/obs/sondes_tvirt_obs_"$DATE"_s.nc4 -g $OutDir/geoval/
