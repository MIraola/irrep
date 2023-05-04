homedir=$(pwd)

echo "Running self-consistent VASP calculation"
echo "WARNING: we assume you have placed a suitable pseudopotential file named POTCAR in the directory dft_inputs. If you do not have access to such a file, run the file run_reference.sh instead"
mkdir "dft_output"
cp "dft_inputs"/POSCAR "dft_output"
cp "dft_inputs"/POTCAR "dft_output"
cp "dft_inputs"/INCAR.sc-cycle "dft_output"/INCAR
cp "dft_inputs"/KPOINTS.sc-cycle "dft_output"/KPOINTS
cd "dft_output"
vasp-spin-orbit
mkdir "tmp"
cp CHGCAR "tmp"
rm ./*
mv "tmp"/* .
rm -rf "tmp"
cd $homedir

echo "Calculating wave functions at maximal k-points with VASP"
cp "dft_inputs"/POSCAR "dft_output"
cp "dft_inputs"/POTCAR "dft_output"
cp "dft_inputs"/INCAR.maximalk "dft_output"/INCAR
cp "dft_inputs"/KPOINTS.maximalk "dft_output"/KPOINTS
cd "dft_output"
vasp-spin-orbit
echo "DFT calculation completed. Output is in dft_output"

echo "Running IrRep"
cd $homedir
mkdir "irrep_output"
cd "irrep_output"
irrep -fWAV="$homedir/dft_output"/WAVECAR -fPOS="$homedir/dft_inputs"/POSCAR -spinor -kpnames=T,GM,F,L -Ecut=50 -refUC=1,-1,0,0,1,-1,1,1,1 -EF=5.2156 -IBstart=5 -IBend=10 > irrep.out
rm trace.txt irreps.dat irreptable-template irrep-output.json
cd $homedir
echo "IrRep calculation completed. Output is in irrep_output. You can compare it with irrep.out"
