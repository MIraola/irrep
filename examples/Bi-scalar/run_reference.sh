homedir=$(pwd)

echo "Running IrRep from reference output files in reference_output"
cd "reference_output"
irrep -Ecut=50 -code=abinit -fWFK="./O_DS2_WFK" -refUC=0,-1,1,1,0,-1,-1,-1,-1 -kpoints=1 -IBend=5 -kpnames="GM" > irrep.out
rm irreps.dat irrepta* irrep-out* trace.txt
cd $homedir
echo "IrRep calculation completed. Output is in reference_output."
