#!/bin/bash

# Step 1. Initialize variables for samtools mpileup parameters
reference=""
bam_list=""  # Changed from 'bam' to 'bam_list' to indicate it's a list (file) of BAM paths
sgRNA=""
quantification_window=1 # Default quantification window size
output_file="knockout_efficiency_results.txt"

# Step 2. Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --sgRNA) sgRNA="$2"; shift ;;
        --reference|--ref) reference="$2"; shift ;;
        --bam) bam_list="$2"; shift ;;  # Expecting a file containing paths of BAM files
        --quantification-window) quantification_window="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Validate required arguments
if [ -z "$sgRNA" ] || [ -z "$reference" ] || [ -z "$bam_list" ]; then
    echo "Missing required arguments."
    exit 1
fi



# Initialize the output file and write the header
echo -e "Bam_file\tsgRNA\tNumber_of_modified_reads\tCoverage\tKnockout_efficiency" > "$output_file"


# Ensure the associative array is declared before the loops
declare -A target_line

# Loop over each BAM file
while read -r bam_file; do
    bam_basename=$(basename "$bam_file" .bam)

    # Generate a mpileup file for each sgRNA location for the current BAM file
    while read -r chr start end strand name; do
        sgRNA_genomic_location="${chr}:${start}-${end}"
        samtools_mpileup_output="${bam_basename}_${name}_samtools_mpileup.txt"
        samtools mpileup --region "$sgRNA_genomic_location" -f "$reference" "$bam_file" > "$samtools_mpileup_output"

        # Determine the target coordinate based on strand information
        if [ "$strand" == "forward" ]; then
            target_coordinate="$end"
        else
            target_coordinate="$start"
        fi

        # Find the line number in the mpileup output that corresponds to the target coordinate
        target_line=$(grep -n "${target_coordinate}" "$samtools_mpileup_output" | cut -d: -f1 | head -n 1)
        
        # Determine the CRISPR cut site based on the strand
        if [ ! -z "$target_line" ]; then
            if [ "$strand" == "forward" ]; then
                # For forward strand, cut site is two lines up from target_line
                cut_site_line=$((target_line - 2))
            else
                # For reverse strand, cut site is two lines down from target_line
                cut_site_line=$((target_line + 2))
            fi
            
            # Extract and print the CRISPR cut site line
            cut_site_content=$(sed "${cut_site_line}q;d" "$samtools_mpileup_output")
            echo "CRISPR cut site for $name at ${sgRNA_genomic_location} for ${bam_basename}  (strand: $strand):"
            echo "$cut_site_content"
        else
            echo "Target coordinate $target_coordinate for $name at ${sgRNA_genomic_location} not found in mpileup output."
        fi
        
        # Calculate start and end lines of the quantification window around cut site
            window_start=$((cut_site_line - quantification_window))
            window_end=$((cut_site_line + quantification_window))

            # Read total number of lines in mpileup output
            total_lines=$(wc -l < "$samtools_mpileup_output")

            # Ensure window does not extend beyond the start or end of the file
            window_start=$(( window_start < 1 ? 1 : window_start ))
            window_end=$(( window_end > total_lines ? total_lines : window_end ))

            echo "Quantification window for $name in $bam_basename from line $window_start to $window_end"
            
            
        # Count CRISPR edit indicators within the quantification window directly from the mpileup output
        
        # Extract the specified range from the mpileup file, focusing on the 5th column
        awk -v start="$window_start" -v end="$window_end" 'NR>=start && NR<=end {print $5}' "$samtools_mpileup_output" > quantification_window_subset_mpileup.txt

        # Count CRISPR edit indicators in the extracted lines
        end_of_reads_with_large_indels=$(grep -o '\$' quantification_window_subset_mpileup.txt | wc -l)
        start_of_reads_with_large_indels=$(grep -o '\^' quantification_window_subset_mpileup.txt | wc -l)
        deletions=$(grep -o '-' quantification_window_subset_mpileup.txt | wc -l)
        insertions=$(grep -o '\+' quantification_window_subset_mpileup.txt | wc -l)
        substitutions=$(awk '
            {
                # Remove sequences for insertions and deletions
                gsub(/\+[0-9]+[ACGTNacgtn]+/, "");
                gsub(/\-[0-9]+[ACGTNacgtn]+/, "");
                # Remove end of read symbol and start of read symbol
                gsub(/\$|\^./, "");
                # Count the remaining A, T, C, G
                count += gsub(/[ACGTacgt]/, "");
            }
            END {print count}' quantification_window_subset_mpileup.txt)

        # Calculate total edits
        number_of_modified_reads=$((end_of_reads_with_large_indels + start_of_reads_with_large_indels + deletions + insertions + substitutions))
        echo "Number of modified reads for $name in $bam_basename: $number_of_modified_reads"
        
        
        
        # Calculate coverage around quantification window

# Extract the specified range from the mpileup file, focusing on the 1st and 2nd columns to get coordinates of quantification window

awk -v start="$window_start" -v end="$window_end" 'NR>=start && NR<=end {print $1, $2}' "$samtools_mpileup_output" > quantification.window.coverage.txt


# Determine the start and end coordinates of the quantification window
start_coord=$(head -n 1 quantification.window.coverage.txt | awk '{print $2}')
end_coord=$(tail -n 1 quantification.window.coverage.txt | awk '{print $2}')
chromosome=$(head -n 1 quantification.window.coverage.txt | awk '{print $1}')

# Construct the region string
coverage_region="${chromosome}:${start_coord}-${end_coord}"
echo "Quantification window region: $coverage_region"

# Use samtools coverage to calculate coverage for the quantification window region
total_number_of_reads=$(samtools coverage --region "$coverage_region" "$bam_file" | awk 'NR>1 {print $4}')
echo "Total number of reads around quantification window: $total_number_of_reads"




# Calculate knockout efficiency: total number of reads with CRISPR event/total number of reads

Knockout_efficiency=$(echo "scale=4; ($number_of_modified_reads/$total_number_of_reads) *100" | bc | sed 's/\.\?0*$//')
echo "Knockout efficiency: $Knockout_efficiency%"
        


# Write the results to the output file

echo -e "$(basename $bam_basename)\t$name\t$number_of_modified_reads\t$total_number_of_reads\t$Knockout_efficiency%" >> "$output_file"
        

    done < "$sgRNA" # End of inner loop for sgRNA processing

done < "$bam_list" # End of outer loop for BAM file processing

# Remove intermediate files for the current BAM file

rm -f *_samtools_mpileup.txt
rm -f quantification_window_subset_mpileup.txt
rm -f quantification.window.coverage.txt