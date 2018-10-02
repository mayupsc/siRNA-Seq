library(ShortRead)
#setwd("clean")
fastqs_list <- list.files("clean")

pdf("figure/read_length_distr.pdf")
layout(matrix(c(1:12),4,3,byrow = T))
for (fastq_file in fastqs_list){

  fastq <- readFastq(paste0("clean/",fastq_file))
  read_length <- fastq@quality@quality@ranges@width
 # range(read_length)
  rm(fastq)
  gc()

  stat <- c()
  for (length in 18:32){
    stat_tmp <- length(which(read_length==length))
    stat <- c(stat,stat_tmp)
  }
  stats <- data.frame("Read Length"= as.character(18:32),"Read Number" = stat)
  #stat30 <- data.frame("Read Length"= ">30","Read Number" = length(which(read_length>30)))
  #stats <- rbind(stats,stat30)

  stats$Read.Number <- stats$Read.Number/1000000
  barplot(stats$Read.Number,
          names.arg = stats$Read.Length,
          col = "paleturquoise2",
          border = "paleturquoise2",
          xlab = "Read Length (bp)",
          ylab = "Read Number (million)",
          main = gsub(".trimmed.fastq.gz","",fastq_file),
          axes = T,
          las = 1,
          ylim = c(0,max(stats$Read.Number)+1))
  box()  
  
}
