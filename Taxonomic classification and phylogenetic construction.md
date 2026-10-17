# Taxonomic classification and phylogenetic construction
```bash
# run  GTDB-Tk:
gtdbtk classify_wf --genome_dir drep95_12425/dereplicated_genomes --out_dir temp/gtdb_12425 --extension fa --prefix tax --cpus 50 --skip_ani_screen

# run FastTree
fasttree tax.ar53.user_msa.fasta > tax.ar53.user_msa.nwk
fasttree tax.bac120.user_msa.fasta > tax.bac120.user_msa.nwk 
```
