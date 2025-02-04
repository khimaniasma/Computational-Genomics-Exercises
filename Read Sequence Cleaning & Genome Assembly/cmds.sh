# Fetch SRR26244988 Illumina FastQ from the recent publication https://journals.asm.org/doi/full/10.1128/mra.00973-23
#mkdir -pv ~/exercise_3/raw_data
#fasterq-dump --version
#fasterq-dump \
 #SRR26244988 
 #--threads 1 \
 #--outdir ~/exercise_3/raw_data \
 #--split-files \
 #--skip-technical

 # Used Docker to fetch SRR26244988
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR26244988
# Store in compressed form
pigz -p 4 SRR26244988_1.fastq
pigz -p 4 SRR26244988_2.fastq

 # View Quality Assessment
mkdir -v ~/exercise_3/raw_qa
fastqc \
 --threads 2 \
 --outdir ~/exercise_3/raw_qa \
 ~/exercise_3/raw_data/SRR26244988_1.fastq.gz \
 ~/exercise_3/raw_data/SRR26244988_2.fastq.gz
google-chrome ~/exercise_3/raw_qa/*.html

# Trimming using fastp
#mamba install -c bioconda fastp
#fastp \
# -i SRR26244988_1.fastq.gz \
#-I SRR26244988_2.fastq.gz \
#  -o SRR26244988_1_trimmed.fastq.gz \
#  -O SRR26244988_2_trimmed.fastq.gz \
#  --qualified_quality_phred 20 \
#  --detect_adapter_for_pe \
# --trim_tail1 10 \
#  --trim_tail2 10 \
 # --json SRR26244988_fastp.json \
  #--html SRR26244988_fastp.html

# Trimming using trimmomatic 
mkdir -v ~/exercise_3/trim 
cd ~/exercise_3/trim
trimmomatic -version # mine was 0.39
trimmomatic PE -phred33 \
 ~/exercise_3/raw_data/SRR26244988_1.fastq.gz \
 ~/exercise_3/raw_data/SRR26244988_2.fastq.gz \
 ~/exercise_3/trim/r1.paired.fq.gz \
 ~/exercise_3/trim/r1_unpaired.fq.gz \
 ~/exercise_3/trim/r2.paired.fq.gz \
 ~/exercise_3/trim/r2_unpaired.fq.gz \
 SLIDINGWINDOW:5:30 AVGQUAL:30 \
 1> trimmo.stdout.log \
 2> trimmo.stderr.log
cat ~/exercise_3/trim/r1_unpaired.fq.gz ~/exercise_3/trim/r2_unpaired.fq.gz > ~/exercise_3/trim/singletons.fq.gz 
rm -v ~/exercise_3/trim/*unpaired*
tree ~/exercise_3/trim

# Assemble with SPAdes
mamba install -c conda-forge spades
spades.py --meta \
  -1 r1.paired.fq.gz \
  -2 r2.paired.fq.gz \
  -o spades_output \
  -t 4

# Evaluate filtering parameters
mamba create -n py27_bio python=2.7
mamba activate py27_bio
mamba install -c conda-forge biopython
# Use filter.contigs.py to evaluate how filtering parameters (e.g., contig coverage, contig length, etc.) affect your output genome size.
chmod u+x filter_contigs.py
./filter_contigs.py
# Iterate over different parameters 
for min_cov in 1 5 10; do
  for min_len in 500 1000 1500; do
    ./filter.contigs.py -i contigs.fasta -o filtered_spades_${min_cov}_${min_len}.fna --cov $min_cov --len $min_len
  done
done

# Use QUAST to evaluate assembly quality
mamba install -c bioconda quast
for min_cov in 1 5 10; do
  for min_len in 500 1000 1500; do
    quast filtered_spades_${min_cov}_${min_len}.fna -o quast_output_${min_cov}_${min_len}
  done
done

# Compare QUAST reports
# Goodness of an assembly: Choose parameters that result in the least amount of contigs (fragments) 
# Best parameters were min_cov: 5 and min_len 1500 resulting in 77 contigs 

#Compress files for submission


