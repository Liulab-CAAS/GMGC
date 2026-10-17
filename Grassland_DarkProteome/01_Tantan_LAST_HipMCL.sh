#!/usr/bin/env bash
# Step 01: Protein clustering with Tantan, LAST and HipMCL.
# Files:
#   proteins.faa    Input unannotated proteins (FASTA).
#   masked.faa      Low-complexity-masked proteins.
#   lastdb*         LAST database files.
#   last_hits.tsv   LAST pairwise sequence alignments.
#   graph.triples   Pre-filtered protein pairs (identity >=70%, coverage >=80% each).
#   clusters.txt    HipMCL clustering output.
#   family_001.ids  Protein IDs from one family with >=10 members.
#   family_001.faa  FASTA sequences extracted for that family.

# 1. Mask low-complexity regions and perform all-versus-all LAST searches.
tantan -p proteins.faa > masked.faa
lastdb -p -c lastdb masked.faa
lastal -P 60 -m 100 -f BlastTab lastdb masked.faa > last_hits.tsv

# 2. Run HipMCL on the filtered similarity graph (inflation = 2.0).
OMP_NUM_THREADS=15 mpirun -np 4 hipmcl -M graph.triples -I 2.0 -o clusters.txt

# 3. Repeat the following command for each family containing >=10 proteins.
seqkit grep -f family_001.ids proteins.faa > family_001.faa
