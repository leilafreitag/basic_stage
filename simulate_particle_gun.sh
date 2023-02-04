#!/bin/bash

#generate Zmumu events with specific momentum (transverse momentum and angle) with particle gun

outDir="simulation_files"
mkdir $outDir

edm4hep_card="$HOME/FCC-config/FCCee/Delphes/edm4hep_IDEA.tcl"

### Pythia
### for Z -> mumu
#process_card="$HOME/FCC-config/FCCee/Generator/Pythia8/p8_ee_Zmumu_ecm91.cmd"
#process_name="Zmumu_ecm91"

#momentum=(1,10,100) #GeV 
#angle=(10,20,30,40,50,60,70,80,90)
 
momenta=("1000" "1000" "1000" "1000" "1000" "1000" "1000" "1000" "1000") #MeV units (want 1,10,100GeV, so 1000,10000,100000 MeV)
momenta_GeV=("1" "1" "1" "1" "1" "1" "1" "1" "1") #remember to change this to match the momentum entries (in MeV)
angles=("10" "20" "30" "40" "50" "60" "70" "80" "89") #degrees

#momenta=("100000" "100000")
#momenta_GeV=("100" "100")
#angles=("8.5" "9")

#input of the particle gun needs tranverse momentum so we calculate this in the script calc_pt.py which takes as input a list of momenta and corresp theta to calc list of pt
list_of_pt=(`python calc_pt.py -wantMom yes -p ${momenta[@]} -theta ${angles[@]} | tr -d '[],'`) #the tr command deletes the brackets and commas to make the returned python list have the format of a bash array
list_of_eta=(`python calc_pt.py -wantEta yes -theta ${angles[@]} | tr -d '[],'`)

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

cards=("_standard")

#cards=("_R1.3_w30_DSK" "_R1.3_w50_DSK" "_R1.3_w100_DSK")
#cards=("_R1.3_w50_DSK" "_R1.3_w100_DSK")

#echo $cards
echo list of pt $list_of_pt
echo "${cards[@]}"
echo whole list of pt "${list_of_pt[@]}"

echo whole list of eta "${list_of_eta[@]}"
echo angles $angles
echo ${list_of_eta[0]}
echo ${list_of_eta[1]}
echo ${list_of_eta[2]}

#echo "${angles[1]}"


for card in "${cards[@]}"
do
    declare -i x=0
    for pt in "${list_of_pt[@]}"
    do
         echo ------- $card $pt
         echo the angle and mom going into the output: ${angles[$x]} ${momenta[$x]}
         pt_max=`echo "$pt+0.0001" | bc` #calculates pt plus 1 to use as input for PtMax
         #if ["${list_of_eta[$x]}" -lt "0.01"] #DOESNT WORK for tiny numbers in bash (ie eta for theta=90)
         #then
         #    eta_max=0.01
         #else
         #    eta_max=`echo "${list_of_eta[$x]}+0.0001" | bc`
         #fi          
         eta_max=`echo "${list_of_eta[$x]}+0.000000001" | bc`
         echo the pt min and max going into the k4run: $pt  $pt_max
         echo the eta min and max going into the k4run: ${list_of_eta[$x]} $eta_max
         #units for PtMin PtMax are MeV
         k4run $HOME/k4SimDelphes/framework/k4SimDelphes/examples/options/k4simdelphesalg.py \
                --out.filename ${outDir}/ParticleGun_Mu${card}_${momenta_GeV[$x]}GeV_${angles[$x]}degrees.root \
                --k4SimDelphesAlg.DelphesCard $HOME/FCC-config/FCCee/Delphes/card_IDEA${card}.tcl \
                --GenAlg.ConstPtParticleGun.PtMin $pt \
                --GenAlg.ConstPtParticleGun.PtMax $pt_max \
                --GenAlg.ConstPtParticleGun.EtaMin ${list_of_eta[$x]} \
                --GenAlg.ConstPtParticleGun.EtaMax $eta_max \
                --k4SimDelphesAlg.DelphesOutputSettings $HOME/FCC-config/FCCee/Delphes/edm4hep_IDEA.tcl \
                --GenAlg.ConstPtParticleGun.PdgCodes 13 \
                -n 10000
         let "x+=1"
    done
done


