## Fetch genome fna file (genome of Staphylococcus capitis O112)

## Gene Prediction using Prodigal 
# Create new enviroment for gene prediction and annotation
mamba create -n hw4_pt2 -y
# Activate enviroment
mamba activate hw4_pt2
# Install prodigal and pigz
mamba install -c bioconda -c conda-forge prodigal pigz -y
# Run prodigal
prodigal \
 -i /Users/asmakhimani/Desktop/bioinformatics/BIOL_7210/hw_ex4/GCF_034427945.1_ASM3442794v1_genomic.fna \
 -c \
 -m \
 -f gff \
 -o khimani.gff \
 2>&1 | tee log.txt

# Compress and view file output
pigz -9f *.gff log
zhead *.gff.gz
gzcat log.txt.gz

## Using barnup for 16S extraction
# create new enviroment for 16S extraction
mamba create -n hw4 -y
# activate enviroment
mamba activate hw4
# Install barnup and bedtools
mamba install -c bioconda -c conda-forge barrnap bedtools -y

# Run barrnap
barrnap \
 GCF_034427945.1_ASM3442794v1_genomic.fna \
 | grep "Name=16S_rRNA;product=16S ribosomal RNA" \
 > 16S.gff
bedtools getfasta \
 -fi GCF_034427945.1_ASM3442794v1_genomic.fna \
 -bed 16S.gff \
 -fo 16S.fa

# Clean up and view output
rm -v *.{fai,gff}
cat 16S.fa


## Functional Annotation of Aux5_seqs.faa and ompA.faa using eggNOG-mapper and InterPro search algorithms 
