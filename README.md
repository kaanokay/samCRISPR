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
--sgRNA sgRNAs.bed \ # coordinates of each sgRNA in corresponding genome
--reference genome.fa \ # corresponding reference genome FASTA file (uncompressed)
--bam bam.files.txt \ # a text file where each row contains path of individual bam file (should be indexed by SAMtools)
--quantification-window 1 # interval for seeking CRISPR events: how many basepairs upstream and downstream away from the cut site (default is 1)
```

Of note
-  The 4th column of sgRNA bed file should contain strand of DNA (either forward or reverse) where sgRNA of interest binds to.
 
Limitation:
-  It is highly recommended to consider CRISPR events that occur in the interval a few bp away from the cut site. The tool is currently incapable of identifying CRISPR events that are more far.


### Cite samCRISPR
'It will be added soon.'
