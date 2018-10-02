## run ##
nohup snakemake -j 30 -rpn -s siRNA.Snakefile>> nohup.log 2>&1 &
