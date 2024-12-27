# samCRISPR

Command-line tool for estimation of knockout efficiency in long-read whole genome sequencing

### Dependencies
In order to run samCRISPR the following software components and packages are required:
- SAMtools >= v1.21
- Linux environment

### Installation
The samCRISPR script can be directly downloaded from this repository:
```{bash}
wget https://github.com/kaanokay/samCRISPR/blob/main/script/samCRISPR.sh
```

### Change the execution permissions:
```{bash}
chmod u+x samCRISPR.sh
```

Then, you can directly execute the script:
```{bash}
bash ./samCRISPR.sh --help
```

To download the entire repository, which includes the dockerfile and example files:
```{bash}
git clone https://github.com/kaanokay/samCRISPR.git
```

### Usage
Execute the script with --help option for a complete list of options. Sample data and usage examples can be found at directory data and directory examples, respectively.

```{bash}
bash ./samCRISPR \
--sgRNA sgRNAs.bed \ # coordinates of each sgRNA in corresponding genome
--reference genome.fa \ # corresponding reference genome FASTA file (uncompressed)
--bam bam.files.txt \ # a text file where each row contains path of individual bam file
--quantification-window 1 # interval for seeking CRISPR events: how many basepairs upstream and downstream away from the cut site (default is 1)
```

To download mouse or human reference genomes from UCSC:
```{bash}
wget -c https://hgdownload.soe.ucsc.edu/goldenPath/mm10/bigZips/mm10.fa.gz # mm10 genome
wget -c https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz # hg38 genome
```

### Cite samCRISPR
'It will be added soon'
