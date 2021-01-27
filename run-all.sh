# This is a bash script that runs all examples available

for dir in examples/*[!data*]; do
 
 cd $dir
 echo
 echo "---------------------------------------------"
 echo " RUNNING EXAMPLE IN $dir "
 echo "---------------------------------------------"
 echo
 bash run-nosave.sh
 rm trace.txt irreps.dat irreptable-template
 cd -
done
