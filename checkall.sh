for sg in $(seq 1 230); do
    echo $sg
    irrep -onlysym -code=fplo -sg=$sg > out
    if [ $? -ne 0 ]; then
        echo "Error in SG $sg"
        exit 1
    fi
done
