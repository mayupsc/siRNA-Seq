## run ##
nohup snakemake -j 30 -rp -s siRNA.Snakefile>> nohup.log 2>&1 &
