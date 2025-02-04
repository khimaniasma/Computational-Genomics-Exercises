# Create new enviroment for assignment 
mamba create -n hw4
mamba activate hw4
# Used Docker to fetch SRR3214715, SRR3215024, SRR3215107
mkdir seq_data
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR3214715 
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR3215024 
docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -e 2 -p SRR3215107
# Store in compressed form
mamba install -c conda-forge pigz
for file in *; do
> if [ -f "$file" ]; then
> pigz "$file"
> fi
> done

# Clean reads using trimmomatic
mamba install -c bioconda trimmomatic
for read in SRR3214715 SRR3215024 SRR3215107; do
> trimmomatic PE -phred33 \
> "${read}_1.fastq.gz" "${read}_2.fastq.gz" \
> "${read}_1.trimmed.fastq.gz" "${read}_1.unpaired.fastq.gz" \
> "${read}_2.trimmed.fastq.gz" "${read}_2.unpaired.fastq.gz" \
> SLIDINGWINDOW:5:30 AVGQUAL:30 MINLEN:36
> done

# Remove unpaired read files
rm -v *unpaired*

# Genome Assembly with Spades
mamba create -n new_env_spades python=3.8
mamba activate new_env_spades
mamba install -c bioconda -c conda-forge spades

spades.py --meta \
  -1 SRR3214715_1.trimmed.fastq.gz \
  -2 SRR3214715_2.trimmed.fastq.gz \
  -o spades_output \
  -t 4

spades.py --meta \
  -1 SRR3215024_1.trimmed.fastq.gz \
  -2 SRR3215024_2.trimmed.fastq.gz \
  -o spades_output2 \
  -t 4

spades.py --meta \
  -1 SRR3215107_1.trimmed.fastq.gz \
  -2 SRR3215107_2.trimmed.fastq.gz \
  -o spades_output3 \
  -t 4  

# Filter out low coverage and short contigs
mamba activate py27_bio
./filter_contigs.py -i contigs.fasta -o SRR3215107_assembly.fna
./filter_contigs.py -i contigs.fasta -o SRR3215024_assembly.fna
./filter_contigs.py -i contigs.fasta -o SRR3214715_assembly.fna

# Verify file sizes look similar
ls -alh *.fna

# Verify assemblies look right
head -n 2 *.fna
tail -n 1 *.fna
grep '>' *.fna

# Compare "contaminated" problem assembly to the species type strain
mamba activate fastani
fastANI \
  --query SRR3214715_assembly.fna \
  --ref GCF_000009085.1_ASM908v1_genomic.fna \
  --output FastANI_Output.tsv
awk \
  '{alignment_percent = $4/$5*100} \
   {alignment_length = $4*3000} \
   {print $0 "\t" alignment_percent "\t" alignment_length}' \
  FastANI_Output.tsv \
  > FastANI_Output_With_Alignment.tsv
sed \
  "1i Query\tReference\t%ANI\tNum_Fragments_Mapped\tTotal_Query_Fragments\t%Query_Aligned\tBasepairs_Query_Aligned" \
  FastANI_Output_With_Alignment.tsv \
  > FastANI_Output_With_Alignment_With_Header.tsv \
column -ts $'\t' FastANI_Output_With_Alignment_With_Header.tsv | less -S

# Genotype all 3 assemblies with MLST
mamba activate mlst
mlst *.fna > MLST_Summary.tsv
column -ts $'\t' FastANI_Output_With_Alignment_With_Header.tsv | less -S

# Use busco to evaluate the assembly itself
mamba create -n busco -c bioconda -c conda-forge busco
mamba activate busco
busco -i SRR3215107_assembly.fna -l bacteria_odb10 -o busco_output -m geno






