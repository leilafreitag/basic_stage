#!/bin/bash

outDir="simulation_files"
mkdir $outDir

#edm4hep_card="edm4hep_IDEA.tcl"
edm4hep_card="$HOME/FCC-config/FCCee/Delphes/edm4hep_IDEA.tcl"

### Pythia
### for Z -> mumu
process_card="$HOME/FCC-config/FCCee/Generator/Pythia8/p8_ee_Zmumu_ecm91.cmd"
#process_card="p8_ee_Zmumu_ecm91.cmd"
process_name="Zmumu_ecm91"


cards=(
	"_standard"
        "_R1.3"
        "_R1.3_w30"
        "_R1.3_w50"
        "_R1.3_w100"
        "_R1.3_w30_DSK"
        "_R1.3_w50_DSK"
        "_R1.3_w100_DSK"
      )


for card in "${cards[@]}"; do
    # Pythia
    nohup DelphesPythia8_EDM4HEP $HOME/FCC-config/FCCee/Delphes/card_IDEA${card}.tcl $edm4hep_card $process_card ${outDir}/${process_name}${card}.root > ${process_name}${card}.log &
   # nohup DelphesPythia8_EDM4HEP card_IDEA${card}.tcl $edm4hep_card $process_card ${outDir}/${process_name}${card}.root > ${process_name}${card}.log &
   # DelphesPythia8_EDM4HEP card_IDEA${card}.tcl $edm4hep_card $process_card ${outDir}/${process_name}${card}.root
done
