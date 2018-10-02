configfile: "siRNA.config.yaml"

rule all:
	input:
		expand('fastq/{sample}.fastq.gz', sample=config['samples']),
		expand('fastqc/raw/{sample}_fastqc.html', sample=config['samples']),
		expand('clean/{sample}.trimmed.fastq.gz', sample=config['samples']),
		expand('fastqc/clean/{sample}.trimmed_fastqc.html', sample=config['samples']),
		expand('stat/fastqc_stat.tsv'),
		expand('figure/read_length_distr.pdf'),
		expand('bam/{sample}.bam', sample=config['samples']),
		expand('bam/{sample}.mapped.bam', sample=config['samples']),
		expand('bam/{sample}.clean.bam', sample=config['samples']),
		expand('bam/{sample}.clean.bam.bai', sample=config['samples'])
		
rule fastqc_raw_SE:
	input:
		'fastq/{sample}.fastq.gz'
	output:
		'fastqc/raw/{sample}_fastqc.html'
	params:
		conda = config['conda_path']
	shell:
		'{params.conda}/fastqc --quiet -t 2 -o fastqc/raw {input}'

rule cutadapt_SE:
	input:
		'fastq/{sample}.fastq.gz'
	output:
		'clean/{sample}.trimmed.fastq.gz'
	params:
		conda = config['conda_path']
	shell:
		'{params.conda}/cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC --discard-untrimmed -m 18 -q 10 -M 32 -o {output} {input}'

rule fastqc_clean_SE:
	input:
		'clean/{sample}.trimmed.fastq.gz'
	output:
		'fastqc/clean/{sample}.trimmed_fastqc.html'
	params:
		conda = config['conda_path']
	shell:
		'{params.conda}/fastqc --quiet -t 2 -o fastqc/clean {input}'

rule fastqc_stat_SE:
	input:
		['fastqc/raw/{sample}_fastqc.html'.format(sample=x) for x in config['samples']],
		['fastqc/clean/{sample}.trimmed_fastqc.html'.format(sample=x) for x in config['samples']]
	output:
		'stat/fastqc_stat.tsv'
	params:
		script = config['script_path']
	shell:
		'Rscript {params.script}/reads_stat_by_fastqcr.R'
rule read_length_stat:
	input:
		['clean/{sample}.trimmed.fastq.gz'.format(sample=x) for x in config['samples']]
	output:
		'figure/read_length_distr.pdf'
	params:
		script = config['script_path']
	shell:
		'Rscript {params.script}/read_length_distribution.R'

rule bowtie_SE:
	input:
		'clean/{sample}.trimmed.fastq.gz'
	output:
		'bam/{sample}.bam'
	params:
		index = config['bowtie_index'],
		prefix= 'bam/{sample}'
	shell:
		'bowtie -p 4 -v 0 -k 10 {params.index} {input} -S | samtools view -Shub | samtools sort - -T {params.prefix} -o  {output}'

rule mapped_bam:
	input:
		'bam/{sample}.bam'
	output:
		'bam/{sample}.mapped.bam'
	shell:
		'samtools view -b -F 4 {input} > {output}'


rule no_rRNA_tRNA_snRNA_snoRNA_bam:
	input:
		'bam/{sample}.mapped.bam'
	output:
		'bam/{sample}.clean.bam'
	params:
		 bed = config['rRNA_tRNA_snRNA_snoRNA_bed']
	shell:
		'bedtools intersect -a {input} -b {params.bed} -v > {output}'

rule bam_index:
	input:
		'bam/{sample}.clean.bam'
	output:
		'bam/{sample}.clean.bam.bai'
	shell:
		'samtools index {input} {output}'
#rule bam_qc:
#	input:
#		bam = 'bam/{sample}.bam'
#	output:
#		bamqc_dir = 'bam/{sample}.bamqc',
#		bamqc_html = 'bam/{sample}.bamqc/qualimapReport.html'
#	params:
#		cpu = config['cpu'],
#		conda = config['conda_path']
#	shell:
#		"{params.conda}/qualimap bamqc --java-mem-size=10G -nt {params.cpu} -bam {input.bam} -outdir {output.bamqc_dir}"

#rule bam_qc_stat:
#	input:
#		['bam/{sample}.bamqc/qualimapReport.html'.format(sample=x) for x in config['samples']]
#	output:
#		'stat/bamqc_stat.tsv'
#	params:
#		Rscript = config['Rscript_path']		
#	shell:
#		"Rscript {params.Rscript}/mapping_stat_by_bamqc.R"

