#!/bin/bash

#SBATCH --job-name=run_4951
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --time=168:00:00
#SBATCH --ntasks=1
#SBATCH --mem=500g
#SBATCH --mail-type=END   
#SBATCH --mail-user=<Email Address>@email.unc.edu 


module load sratoolkit/2.9.6

for run in <Run Accessions> #eg:SRR5385305 SRR5385306 SRR5385307
do
        #fastq-dump --gzip --split-files $run 
        fastq-dump $run
done

