## samCRIPSR

Command-line tool for estimation of knockout efficiency in long-read whole genome sequencing

#### Dependencies
In order to run samCRISPR the following software components and packages are required:
- SAMtools >= v1.21
- Linux environment

#### Installation
The samCRISPR script can be directly downloaded from this repository:
```{bash}
wget https://github.com/kaanokay/samCRISPR/blob/main/script/samCRISPR.sh
```

#### Change the execution permissions:
```{bash}
chmod u+x samCRISPR.sh
```

Then, you can directly execute the script:
```{bash}
./samCRISPR.sh --help
```

To download the entire repository, which includes the dockerfile and example files:
```{bash}
git clone https://github.com/kaanokay/samCRISPR.git
```

#### Usage
Execute the script with --help option for a complete list of options. Sample data and usage examples can be found at directory data and directory examples, respectively.
