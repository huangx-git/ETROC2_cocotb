# ETROC2

for chip-level verification 

## Getting started

   Commands:

#### Cloning repository (with SSH) ####

   git clone ssh://git@gitlab.cern.ch:7999/qusun/ETROC2.git

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

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.cern.ch/qusun/ETROC2.git
git branch -M master
git push -u origin master
```

