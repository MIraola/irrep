homedir=$(pwd)
mkdir "irrep_output"
cd "irrep_output"
irrep -fWAV="$homedir/reference_output"/WAVECAR -fPOS="$homedir/dft_inputs"/POSCAR -spinor -kpnames=T,GM,F,L -Ecut=50 -refUC=1,-1,0,0,1,-1,1,1,1 -EF=auto -IBstart=5 -IBend=10 > irrep.out
rm trace.txt irreps.dat irreptable-template irrep-output.json
cd $homedir
