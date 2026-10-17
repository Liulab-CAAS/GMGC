#!/usr/bin/env bash
# Step 06: Protein function prediction using DeepFRI2.
# Files:
#   representatives_full/  Full-length representative PDB structures (input).
#   deepFRI2/.../deepfri2.py Installed DeepFRI2 program.
#   deepfri2_results/      Predicted GO functions (output).

# 1. Predict protein functions with the DeepFRI2 fusion model and ESM-2 features.
# This is a Linux CLI invocation of the existing model, NOT custom Python code.
OMP_NUM_THREADS=20 MKL_NUM_THREADS=20 python \
  deepFRI2/src/deepFRI2/deepfri2.py \
  --input representatives_full/ --output_dir deepfri2_results/ \
  --model fusion --aspect mf,cc,bp --threshold 0.1,0.2 --batch_size 32

# 2. Retain GO predictions with pred_prob >=0.5.
# Apply the manually curated Retain / Retain (Bacteria only) / Broad / Exclude
# GO term categories; do not treat these manual decisions as model predictions.
