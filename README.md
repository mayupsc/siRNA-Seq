# siRNA-Seq
## small RNA Seq workflow (fastqc trimmomatic bowtie samtools bedtools )

### 1.File Preparation

* tRNA_rRNA_snRNA_snoRNA.gtf
```
wget ftp://ftp.ensemblgenomes.org/pub/release-40/plants/gtf/solanum_lycopersicum/Solanum_lycopersicum.SL2.50.40.gtf.gz
gunzip Solanum_lycopersicum.SL2.50.40.gtf.gz
grep -E 'tRNA|rRNA|snRNA|snoRNA' Solanum_lycopersicum.SL2.50.40.gtf > tRNA_rRNA_snRNA_snoRNA.gtf
sed -i 's/^/SL2.50ch0&/g' tRNA_rRNA_snRNA_snoRNA.gtf
sed -i 's/SL2.50ch010/SL2.50ch10/g' tRNA_rRNA_snRNA_snoRNA.gtf 
sed -i 's/SL2.50ch011/SL2.50ch11/g' tRNA_rRNA_snRNA_snoRNA.gtf 
sed -i 's/SL2.50ch012/SL2.50ch12/g' tRNA_rRNA_snRNA_snoRNA.gtf
sed -i 's/SL2.50ch0SL2.40/SL2.40/g' tRNA_rRNA_snRNA_snoRNA.gtf

```
* tRNA_rRNA_snRNA_snoRNA.bed
```
tRNA_rRNA_snRNA_snoRNA <- read.table("~/genome/SL2.5/tRNA_rRNA_snRNA_snoRNA.gtf",sep = "\t",stringsAsFactors = F)
tRNA_rRNA_snRNA_snoRNA <- tRNA_rRNA_snRNA_snoRNA[,c(1,4,5,9,6,7)]
colnames(tRNA_rRNA_snRNA_snoRNA) <- c("chrom","start","end","name","score","strand")
tRNA_rRNA_snRNA_snoRNA$name <- gsub("; gene_name.*","",tRNA_rRNA_snRNA_snoRNA$name)
tRNA_rRNA_snRNA_snoRNA$name <- gsub("; transcript_id.*","",tRNA_rRNA_snRNA_snoRNA$name)
tRNA_rRNA_snRNA_snoRNA$name <- gsub("gene_id ","",tRNA_rRNA_snRNA_snoRNA$name)
write.table(tRNA_rRNA_snRNA_snoRNA,"~/genome/SL2.5/tRNA_rRNA_snRNA_snoRNA.bed",sep = "\t",quote = F,row.names = F,col.names = F)

```

### 2.Clone the Repository

```
git clone https://github.com/mayupsc/siRNA-Seq.git
```

### 3.Initiate the Project

```
./init.sh
```
### 4.Modify Configuration file(siRNA.config.yaml) 

### 5.Dry run the workflow to check any mistakes

```
./dry_run.sh
```
### 6.Start the workflow

```
 ./run.sh
```

### 7.Check the workflow progress in nohup.out
## Reference
![paper](https://github.com/mayupsc/siRNA-Seq/blob/master/images/paper.jpeg)
![paper](https://github.com/mayupsc/siRNA-Seq/blob/master/images/method.jpeg)


