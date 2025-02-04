# Comparative Genomics HW#4

# Activate enviroment from previous HW assignment
mamba activate hw4
# Create directories to work in 
mkdir ~/ex6
mkdir ~/ex6/Raw_FastQs
cd ~/ex6/Raw_FastQs

## Ran each docker command (instead of a loop) followed by pigz command to compress each file due to low disc space on computer 
# Use docker to fetch all (10) SRA accessions: SRR1993270 SRR1993271 SRR1993272 SRR2984947 SRR2985018 SRR3214715 SRR3215024 SRR3215107 SRR3215123 SRR3215124
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR1993270
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR1993271
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR1993272
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR2984947
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR2985018
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR3214715
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR3215024
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR3215107
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR3215123
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR3215124

# Store in compressed form 
mamba install -c conda-forge pigz
pigz -9 *.fastq

# Clean reads with fastp
mamba install -c bioconda fastp
mkdir ~/ex6/Cleaned_FastQs
for read in ~/ex6/Raw_FastQs/*_1.fastq.gz; do
  sample="$(basename ${read} _1.fastq.gz)"
  echo fastp \
   -i "${read}" \
   -I "${read%_1.fastq.gz}_2.fastq.gz" \
   -o "~/ex6/Cleaned_FastQs/${sample}.R1.fq.gz" \
   -O "~/ex6/Cleaned_FastQs/${sample}.R2.fq.gz" \
   --json "~/ex6/Cleaned_FastQs/${sample}.json" \
   --html "~/ex6/Cleaned_FastQs/${sample}.html"
done
# Ran printed commands to clean
fastp -i /Users/asmakhimani/ex6/Raw_FastQs/SRR1993270_1.fastq.gz -I /Users/asmakhimani/ex6/Raw_FastQs/SRR1993270_2.fastq.gz -o ~/ex6/Cleaned_FastQs/SRR1993270.R1.fq.gz -O ~/ex6/Cleaned_FastQs/SRR1993270.R2.fq.gz --json ~/ex6/Cleaned_FastQs/SRR1993270.json --html ~/ex6/Cleaned_FastQs/SRR1993270.html
fastp -i /Users/asmakhimani/ex6/Raw_FastQs/SRR1993271_1.fastq.gz -I /Users/asmakhimani/ex6/Raw_FastQs/SRR1993271_2.fastq.gz -o ~/ex6/Cleaned_FastQs/SRR1993271.R1.fq.gz -O ~/ex6/Cleaned_FastQs/SRR1993271.R2.fq.gz --json ~/ex6/Cleaned_FastQs/SRR1993271.json --html ~/ex6/Cleaned_FastQs/SRR1993271.html
fastp -i /Users/asmakhimani/ex6/Raw_FastQs/SRR1993272_1.fastq.gz -I /Users/asmakhimani/ex6/Raw_FastQs/SRR1993272_2.fastq.gz -o ~/ex6/Cleaned_FastQs/SRR1993272.R1.fq.gz -O ~/ex6/Cleaned_FastQs/SRR1993272.R2.fq.gz --json ~/ex6/Cleaned_FastQs/SRR1993272.json --html ~/ex6/Cleaned_FastQs/SRR1993272.html
fastp -i /Users/asmakhimani/ex6/Raw_FastQs/SRR2984947_1.fastq.gz -I /Users/asmakhimani/ex6/Raw_FastQs/SRR2984947_2.fastq.gz -o ~/ex6/Cleaned_FastQs/SRR2984947.R1.fq.gz -O ~/ex6/Cleaned_FastQs/SRR2984947.R2.fq.gz --json ~/ex6/Cleaned_FastQs/SRR2984947.json --html ~/ex6/Cleaned_FastQs/SRR2984947.html
fastp -i /Users/asmakhimani/ex6/Raw_FastQs/SRR2985018_1.fastq.gz -I /Users/asmakhimani/ex6/Raw_FastQs/SRR2985018_2.fastq.gz -o ~/ex6/Cleaned_FastQs/SRR2985018.R1.fq.gz -O ~/ex6/Cleaned_FastQs/SRR2985018.R2.fq.gz --json ~/ex6/Cleaned_FastQs/SRR2985018.json --html ~/ex6/Cleaned_FastQs/SRR2985018.html
fastp -i /Users/asmakhimani/ex6/Raw_FastQs/SRR3214715_1.fastq.gz -I /Users/asmakhimani/ex6/Raw_FastQs/SRR3214715_2.fastq.gz -o ~/ex6/Cleaned_FastQs/SRR3214715.R1.fq.gz -O ~/ex6/Cleaned_FastQs/SRR3214715.R2.fq.gz --json ~/ex6/Cleaned_FastQs/SRR3214715.json --html ~/ex6/Cleaned_FastQs/SRR3214715.html
fastp -i /Users/asmakhimani/ex6/Raw_FastQs/SRR3215024_1.fastq.gz -I /Users/asmakhimani/ex6/Raw_FastQs/SRR3215024_2.fastq.gz -o ~/ex6/Cleaned_FastQs/SRR3215024.R1.fq.gz -O ~/ex6/Cleaned_FastQs/SRR3215024.R2.fq.gz --json ~/ex6/Cleaned_FastQs/SRR3215024.json --html ~/ex6/Cleaned_FastQs/SRR3215024.html
fastp -i /Users/asmakhimani/ex6/Raw_FastQs/SRR3215107_1.fastq.gz -I /Users/asmakhimani/ex6/Raw_FastQs/SRR3215107_2.fastq.gz -o ~/ex6/Cleaned_FastQs/SRR3215107.R1.fq.gz -O ~/ex6/Cleaned_FastQs/SRR3215107.R2.fq.gz --json ~/ex6/Cleaned_FastQs/SRR3215107.json --html ~/ex6/Cleaned_FastQs/SRR3215107.html
fastp -i /Users/asmakhimani/ex6/Raw_FastQs/SRR3215123_1.fastq.gz -I /Users/asmakhimani/ex6/Raw_FastQs/SRR3215123_2.fastq.gz -o ~/ex6/Cleaned_FastQs/SRR3215123.R1.fq.gz -O ~/ex6/Cleaned_FastQs/SRR3215123.R2.fq.gz --json ~/ex6/Cleaned_FastQs/SRR3215123.json --html ~/ex6/Cleaned_FastQs/SRR3215123.html
fastp -i /Users/asmakhimani/ex6/Raw_FastQs/SRR3215124_1.fastq.gz -I /Users/asmakhimani/ex6/Raw_FastQs/SRR3215124_2.fastq.gz -o ~/ex6/Cleaned_FastQs/SRR3215124.R1.fq.gz -O ~/ex6/Cleaned_FastQs/SRR3215124.R2.fq.gz --json ~/ex6/Cleaned_FastQs/SRR3215124.json --html ~/ex6/Cleaned_FastQs/SRR3215124.html

# create, activate, install enviroment with skesa
mamba create -n skesa-env
mamba activate skesa-env
mamba install -c bioconda skesa=2.3.0
# Genome assembly with skesa
# changed --reads option to --fastq because my version of skesa did not have this option
mkdir ~/ex6/Assemblies
for read in ~/ex6/Cleaned_FastQs/*.R1.fq.gz; do
  sample="$(basename ${read} .R1.fq.gz)"
  skesa \
   --fastq "${read}","${read%R1.fq.gz}R2.fq.gz" \ 
   --cores 4 \
   --min_contig 1000 \
   --contigs_out ~/ex6/Assemblies/"${sample}".fna
done

# Verify file sizes are similar
ls -alhS *.fna

# create and install parSNP and figtree
mamba create -n harvestsuite -c bioconda parsnp harvesttools figtree -y
mamba activate harvestsuite
mkdir ~/ex6/parsnp_input_assemblies
cd ~/ex6/parsnp_input_assemblies
for file in /Users/asmakhimani/ex6/fna_files/*.{fa,fna}; do
ln -sv "${file}" "$(basename ${file})"
done
# confirm files are available 
ls -alhtr *.{fa,fna}

# Run ParSNP with assemblies to generate a core SNP phylogenetic tree. Uses 4 CPUs (-p arg)
cd ~/ex6
conda activate harvestsuite
parsnp \
 -d parsnp_input_assemblies \
 -r /Users/asmakhimani/ex6/fna_files/SRR3214715.fna \
 -o parsnp_outdir \
 -p 4

# view tree
figtree parsnp_outdir/parsnp.tree
