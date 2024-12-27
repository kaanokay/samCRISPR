# samCRISPR

Command-line tool for estimation of knockout efficiency in long-read whole genome sequencing.

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

To download the entire repository
```{bash}
git clone https://github.com/kaanokay/samCRISPR.git
```

### Usage
Execute the script with --help option for a complete list of options. Sample data and output examples can be found at data and examples, respectively.

```{bash}
bash ./samCRISPR.sh \
--sgRNA sgRNAs.bed \ # coordinates of each sgRNA in corresponding genome
--reference genome.fa \ # corresponding reference genome FASTA file (uncompressed)
--bam bam.files.txt \ # a text file where each row contains path of individual bam file (should be indexed by SAMtools)
--quantification-window 1 # interval for seeking CRISPR events: how many basepairs upstream and downstream away from the cut site (default is 1)
```

Of note: 
-  1. The bam file is aligned to UCSC mm10 genome.
-  2. bed file of sgRNA should specify strand of DNA (either forward or reverse) where sgRNA of interest binds to.

### Cite samCRISPR
'It will be added soon'
