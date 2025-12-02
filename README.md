# samCRISPR

Command-line tool for estimation of knockout efficiency in long-read whole genome sequencing. 

This tool is able to process multiple BAM files for multiple sgRNAs to detect CRISPR events around cut site of Cas9 in target region.

### Dependencies
In order to run samCRISPR the following software components and packages are required:
- SAMtools >=1.21
- R computing environment >=4.4.2
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

Then, you can directly execute the script with --help argument for a complete list of options.
```{bash}
bash ./samCRISPR.sh --help
```

To download the entire repository
```{bash}
git clone https://github.com/kaanokay/samCRISPR.git
```

### Usage
Sample data and output examples can be found at data and examples, respectively.

```{bash}
bash ./samCRISPR.sh \
--sgRNA path/to/sgRNAs.bed \ # path to bed file containing coordinates of each sgRNA in corresponding genome
--reference path/to/genome.fa \ # path to corresponding reference genome FASTA file (uncompressed)
--bam path/to/bam.files.txt \ # path to a text file where each row contains path of individual bam file (should be indexed by SAMtools)
--quantification-window 1 # interval for seeking CRISPR events: how many basepairs upstream and downstream away from the cut site (default is 1)
```

Note/
-  The 4th column of sgRNA bed file should contain a string specifying what strand of DNA (either forward or reverse) sgRNA of interest binds to.
 
Limitation:
-  It is highly recommended to consider CRISPR events that occur in the interval a few bp away from the cut site. The tool is currently incapable of identifying CRISPR events that are more far. This also means that sgRNA bed file should be limited to only exact coordinates of sgRNA.


### Cite samCRISPR
https://doi.org/10.1101/2025.09.12.675897.

#### Note/ The script and data should be kept in different directories and path of data should be specified to run samCRISPR.
