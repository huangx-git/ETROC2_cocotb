#!/bin/bash

PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin

export PATH


# User specific environment and startup programs

# GENERAL STUFF ***********************
# for calibre not respond to keyboard input
unset XMODIFIERS

#********** SETUP FOR CADENCE ***********************
export AMS_UNL=YES
export CDSHOME=/usr/local/cds2008/ic618
export IC=$CDSHOME
export CDSDIR=$CDSHOME
export CDS_Netlisting_Mode=Analog

export MMSIM=/usr/local/cds2008/SPECTRE191

#*******************EDI, GENUS, INNOVUS setup **************************

export INNOVUS_ROOT=/usr/local/cds2008/INNOVUS211  
export GENUS_ROOT=/usr/local/cds2008/GENUS211
export TEMPUS_ROOT=/usr/local/cds2008/SSV211
export CONFORMAL_ROOT=/usr/local/cds2008/CONFRML211
export EXCELIUM=/usr/local/cds2008/XCELIUM2109
export QRC=/usr/local/cds2008/EXT171
export PVS=/usr/local/cds2008/PVS161
#**********************************************************
# ADE had memory problem that is why this environment variable set
export MALLOC_CHECK_=0
#**********************************************************
# setup for 64 bit
export CDS_AUTO_64BIT=ALL

# Cadence `k' lock permission
export DD_DONT_DO_OS_LOCKS=set
export CDS_DEBUG_MPS=5
#************ SETUP FOR Assura/PVS *************************




export OPTION=1p9m6x1z1u
#export OPTION=1p6m3x1z1u
export PDK_PATH=/usr/local/TSMC65nm
export PDK_RELEASE=V1.7A_1
export TSMC_DIG_LIBS=$PDK_PATH/digital
export TSMC_PDK=$PDK_PATH/$PDK_RELEASE/$OPTION

export QRC_ENABLE_EXTRACTION=t


export OSS_IRUN_BIND2=YES
export pvs_source_added_place=TRUE

### Set the default netlisting mode to "Analog" - the recommended default
### Default may be "Digital" depending on the virtuoso executable.

##export AMSHOME=$INCISIVE_HOME
##export CDS_Netlisting_Mode=Analog
export QRC_ENABLE_EXTRACTION

export PVEHOME=/usr/local/cds2008/pve
export QRCHOME=/usr/local/cds2008/pve

export CLIOSOFT_DIR=/usr/local/clio/sos_7.05.p9_linux64
export CLIOLMD_LICENSE_FILE=27002@slic2a1.systems.smu.edu

export LM_LICENSE_FILE=/usr/local/cds2008/etc/license2.dat:/usr/local/synopsys/etc/license.dat:1717@sengr7lic2.smu.edu

export MGLS_LICENSE_FILE=1717@sengr7lic2.smu.edu
export CALIBRE_HOME=/usr/local/mentor/aoi_cal_2019.1_37.21
export MGC_HOME=/usr/local/mentor/aoi_cal_2019.1_37.21

PATH=$PATH:\
:$IC/tools/bin\
:$IC/tools/dfII/bin\
:$IC/tools/jre\
:$IC/tools/jre/bin\
:$IC/tools/dracula/bin\
:$IC/tools/iccraft/bin\
:$IC/tools/inca/bin\
:$IC/tools/mdl/bin\
:$IC/tools/plot/bin\
:$EXCELIUM/tools/bin\
:$MMSIM/tools/bin\
:$MMSIM/tools/dfII/bin\
:$MMSIM/tools/spectre/bin\
:$QRC/tools/bin\
:$PVS/tools/bin\
:$INNOVUS_ROOT/tools/bin\
:$GENUS_ROOT/tools.lnx86/bin\
:$TEMPUS_ROOT/tools/bin\
:$CONFORMAL_ROOT/tools/bin\
:$CALIBRE_HOME/bin

###########
#####


#export PATH

export LD_LIBRARY_PATH=$IC/tools/lib:$MMSIM/tools/lib:$IC/tools/lib/64bit
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CLIOSOFT_DIR/lib:$CLIOSOFT_DIR/lib/64bit
export GDM_USE_SHLIB_ENVVAR=1

export CLS_CDSD_COMPATIBILITY_LOCKING=NO
export XAPPLRESDIR=/usr/local/cds2008/ic/tools/dfII/etc/app-defaults
export OA_UNSUPPORTED_PLAT=linux_rhel50_gcc48x
export W3264_NO_HOST_CHECK=1


