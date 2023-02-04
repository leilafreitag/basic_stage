#!/bin/bash

outDir="simulation_files"
mkdir $outDir

#edm4hep_card="edm4hep_IDEA.tcl"
edm4hep_card="$HOME/FCC-config/FCCee/Delphes/edm4hep_IDEA.tcl"

### Pythia

process_card="$HOME/FCC-config/FCCee/Generator/Pythia8/p8_ee_Zbb_ecm91_EVTGEN.cmd"

process_name="evtGen_ecm91_Bs2JpsiPhi"
evtGenFile="$HOME/FCC-config/FCCee/Generator/EvtGen/Bs2JpsiPhi.dec"
evtGenDecay="531 B_s0 1"

cards=(
#	"_standard"
#        "_R1.3"
#        "_R1.3_w30"
#        "_R1.3_w50"
#        "_R1.3_w100"
#        "_R1.3_w30_DSK"
#        "_R1.3_w50_DSK"
#        "_R1.3_w100_DSK"
      )

#cards=("_R1.3_w100" "_R1.3_w100_DSK" "_R1.3_w30_DSK")
#cards=("_FullSilicon")
cards=("_R1.3_L1_w30")
#cards=("_standard")

for card in "${cards[@]}"; do

    nohup DelphesPythia8EvtGen_EDM4HEP_k4Interface $HOME/FCC-config/FCCee/Delphes/card_IDEA${card}.tcl $edm4hep_card $process_card ${outDir}/${process_name}${card}.root \
    $HOME/FCC-config/FCCee/Generator/EvtGen/DECAY.DEC $HOME/FCC-config/FCCee/Generator/EvtGen/evt.pdl $evtGenFile $evtGenDecay > ${process_name}${card}.log &
done

#one line example test:
#DelphesPythia8EvtGen_EDM4HEP_k4Interface $HOME/FCC-config/FCCee/Delphes/card_IDEA_standard.tcl $HOME/FCC-config/FCCee/Delphes/edm4hep_IDEA.tcl \
#$HOME/FCC-config/FCCee/Generator/Pythia8/p8_ee_Zbb_ecm91_EVTGEN.cmd  simulation_files/evtGen_ecm91_Bs2JpsiPhi_standard_2.root \
#$HOME/FCC-config/FCCee/Generator/EvtGen/DECAY.DEC $HOME/FCC-config/FCCee/Generator/EvtGen/evt.pdl $HOME/FCC-config/FCCee/Generator/EvtGen/Bs2JpsiPhi.dec "531 B_s0 1" > evtGen_ecm91_Bs2JpsiPhi_standard_2.log
