# ETROC2

for chip-level verification 

## Getting started

   Commands:

#### Cloning repository (with SSH) ####



#### Running Simulation ####

   cd $WORKAREA/functional/ETROC2
   mkdir workdir
   cd workdir
   ln -s ../../../../ETROC2
   cp ../model/ModuleSwitch.v ./
   cp ../../etroc2readout/commonDefinition.v ./
   ln -s ../../etroc2readout
   ln -s ../scripts
   ./scripts/runSimulation

#### Notes
      ## simulation requires XCELIUM2109 (-no_analogsolver switch is used to reduce simulation time) 

      ## to update XCELIUM2109 
         ## create local copy of below file under $WORKAREA/functional/ETROC2/workdir/ 
            ~cadadmin/userArea/GenericBashProfile 
            source <local copy> 

      ## set PDK_PATH 
         ### for ETROC2, export PDK_PATH in setup.sh
             export PDK_PATH=/asic/cad/Library/tsmc/TSMC65_VCAD/Base_PDK/

         ### to check environment variable 
             export // lists down all environment variables  
             


## Add your files

```
cd existing_repo
git remote add origin https://gitlab.cern.ch/qusun/ETROC2.git
git branch -M master
git push -u origin master
```

