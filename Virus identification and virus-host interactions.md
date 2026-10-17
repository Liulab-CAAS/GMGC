# Virus identification and virus-host interactions

```bash
# run seqkit 
seqkit seq -m 1000 $input_file > $input_file_con1000
# run genomad:
time genomad end-to-end --cleanup --splits 8 $input_file_con1000 genomad/ ${db}/viral/genomad_db
# run virsorter
time virsorter run -w $output_file_con1000 -i  $input_file_con1000 -j 16 --exclude-lt2gene all
# run DeepVirFinde
time python DeepVirFinder/dvf.py -i $input_file_con1000 -o temp/deepvir/ -c 20

# run CD-HIT:
nohup cd-hit-est -i 1825.fna -o cdhit/1825_cdhit.fna -c 1.0 -aL 1.0 -M 400000 -T 40 >> cd-hit1825.log 2>&1 &

# https://bitbucket.org/berkeleylab/checkv/src/master/
checkv
nohup checkv end_to_end cdhit/1825_cdhit.fna checkv_out1825 -d ~/db/checkv-db-v1.5/ -t 40 >> checkv.log 2>&1 &
seqkit grep -f 8778.list ../cdhit/1825_cdhit.fna -o filtered_sequences.fasta
nohup makeblastdb -in filtered_sequences.fasta -dbtype nucl -out viral_db  >> checkv_db.log 2>&1 &
nohup blastn -query filtered_sequences.fasta -db viral_db -outfmt "6 std qlen slen" -max_target_seqs 10000 -out all_viral_blast.tsv -num_threads 32 >> checkv_db.log 2>&1 &
python3 scripts/anicalc.py -i all_viral_blast.tsv -o my_ani.tsv &
python3 scripts/aniclust.py --fna filtered_sequences.fasta --ani my_ani.tsv --out my_clusters.tsv --min_ani 95 --min_tcov 85 --min_qcov 0 &
awk -F "\t" '$8 == "Complete" || $8 == "Medium-quality" || $8 == "High-quality"' quality_summary.tsv > filtered_quality.tsv

# run PRODIGAL v2.6.3 :
prodigal -i "filtered_sequences.fasta" -p single -f gff -a "prodigal/s_8877.faa" -d "prodigal/s_8877.fna" -o "prodigal/s_8877.gff"

# :run Phabox :
nohup phabox2 --task tree --dbdir ${db}/phabox/phabox_db_v2_1/ --outpth phabox4/ --threads 40 --contigs filtered_sequences.fasta --proteins phabox2/midfolder/ALLprotein.fa --midfolder phabox2/midfolder/ --tree Y --msa Y >> phabox4.log 2>&1 &

```
