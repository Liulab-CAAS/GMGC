# Grassland metagenomic data processing

```bash
# run KneadData:
time kneaddata --input1 $input_file1 --input2 $input_file2 -o $qc_dir -v -t $cpu_num --remove-intermediate-output  --trimmomatic ~/miniconda3/envs/metawrap1.1/share/trimmomatic/ --reorder --trimmomatic-options 'ILLUMINACLIP:/home/lin/miniconda3/envs/metawrap1.1/share/trimmomatic/adapters/TruSeq3-PE.fa:2:40:15 SLIDINGWINDOW:4:20 MINLEN:50' --bowtie2-options '--very-sensitive --dovetail' --serial $db_args"

# QC summary:
kneaddata_read_count_table --input ${wd}/temp/qc/ --output ${wd}/temp/qc/kneaddata_statistics.txt

# run megahit:
time megahit -t $cpu_num -1 $input_file1 -2 $input_file2 -o ${megahit_dir}/$sample
# run seqkit:
seqkit seq -m 500 $input_fa > $output_fasta

# binning module:
metawrap binning -o ${binning_dir}/$sample -t $cpu_num -a $input_fasta --metabat2 --maxbin2 --concoct $input_qc_files1 $input_qc_files2

# refinement module
time metawrap bin_refinement -o ${refinement_dir}/$sample -A ${metabat2_bins} -B ${maxbin2_bins} -C ${concoct_bins} -c 50 -x 10 -t $cpu_num

# run dRep
nohup dRep dereplicate temp/drep95_12425/ -g temp/drep_in/*.fa -sa 0.95 -nc 0.30 -comp 50 -con 10 -p 50 >> drep.log 2>&1 &

```
