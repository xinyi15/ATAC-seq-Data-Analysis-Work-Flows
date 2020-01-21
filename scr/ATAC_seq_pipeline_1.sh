#!/bin/bash

#SBATCH --job-name=run_temp
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --time=20:00:00
#SBATCH --ntasks=1
#SBATCH --mem=200g
#SBATCH --mail-type=END   
#SBATCH --mail-user=xinyi7@email.unc.edu 

module load bowtie2
module load samtools
module load macs
module load picard


for f in SRR5385305 SRR5385306 SRR5385307
do
bowtie2  --very-sensitive  -x /proj/seq/data/MM10_UCSC/Sequence/Bowtie2Index/genome   -U ${f}.fastq \
  |  samtools view -u -  \
  |  samtools sort -n -o  Result_1/${f}.sorted.bam


samtools view -h Result_1/${f}.sorted.bam | grep -v chrM | samtools sort - -O bam -o Result_1/${f}.sorted.rmChrM.bam

java -jar /proj/seq/data/DropSeqWorkshop/Drop-seq_tools-1.12/3rdParty/picard/picard.jar MarkDuplicates I= Result_1/${f}.sorted.rmChrM.bam O= Result_1/${f}.sorted.rmChrM.dup.bam M=dups.txt REMOVE_DUPLICATES=true READ_NAME_REGEX=null

samtools view -b  -q 10  Result_1/${f}.sorted.rmChrM.dup.bam >  Result_1/${f}.sorted.rmChrM.dup2.bam

samtools sort -T a5.sorted -o Result_1/${f}.sorted2.rmChrM.dup2.bam Result_1/${f}.sorted.rmChrM.dup2.bam
samtools index Result_1/${f}.sorted2.rmChrM.dup2.bam

macs2 callpeak  -t Result_1/${f}.sorted2.rmChrM.dup2.bam  -f BED  -n Result_1/${f}_macs -g ce  --keep-dup all


done
