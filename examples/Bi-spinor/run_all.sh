homedir=$(pwd)

echo "Running DFT calculation with ABINIT"
mkdir "dft_output"
cp "dft_inputs"/* "dft_output"
cd "dft_output"
abinit < files.txt
rm abinit_parameters.in Bi.xml files.txt pseudopot
echo "DFT calculation completed. Output is in dft_output"

echo "Running IrRep"
cd $homedir
mkdir "irrep_output"
cd "irrep_output"
irrep -Ecut=50 -code=abinit -fWFK="$homedir/dft_output/O_DS2_WFK" -refUC=0,-1,1,1,0,-1,-1,-1,-1 -IBend=4 -kpnames="GM" > irrep.out
cd $homedir
echo "IrRep calculation completed. Output is in irrep_output. You can compare it with irrep.out"
