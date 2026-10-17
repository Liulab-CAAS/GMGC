#!/usr/bin/env bash
# Step 03: ESMFold v1 batch structure prediction (CPU).
# Requires the ESMFold v1 environment named esmfold1.
# Files:
#   tai.txt               Input protein sequences in FASTA format.
#   run_esmfold_batch.py  Included ESMFold batch prediction program.
#   esmfold_pdb/          Output PDB files named by protein ID.
#   esmfold_batch.log     Prediction log.

# 1. Activate the ESMFold environment.
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate esmfold1

# 2. Predict protein structures from the input FASTA file.
nohup python run_esmfold_batch.py tai.txt esmfold_pdb > esmfold_batch.log 2>&1 &

# 3. Downstream filtering (not included here):
#    Retain structures with mean pLDDT >= 70 and >= 70% of residues at pLDDT >= 70.
#    Remove residues with pLDDT < 70 before all-versus-all TM-align comparisons.
