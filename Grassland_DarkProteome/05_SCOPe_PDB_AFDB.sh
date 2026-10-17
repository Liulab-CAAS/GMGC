#!/usr/bin/env bash
# Step 05: SCOPe search by TM-align; PDB and AFDB search by Foldseek.
# Files:
#   representatives_trimmed/  Selected trimmed representative PDBs.
#   scope_domains/            SCOPe v2.08 domain PDBs (*.ent).
#   scope_targets.list        List of SCOPe domain IDs.
#   scope_001.tsv             TM-align results for one query.
#   scope_pass_pdb/           Queries passing SCOPe exclusion criteria.
#   pdb_db                    Foldseek PDB reference database.
#   pdb_hits.tsv              PDB Foldseek alignments.
#   pdb_unmatched_pdb/        Queries without qualifying PDB matches.
#   afdb_rep_v4_db            Foldseek AFDB_rep_v4 reference database.
#   afdb_hits.tsv             AFDB Foldseek alignments.
#   scope_pass_db, afdb_query_db  Foldseek query database files.
#   pdb_results, afdb_results    Foldseek intermediate result databases.
#   pdb_tmp, afdb_tmp            Foldseek temporary directories.

# 1. SCOPe v2.08 is searched with TM-align (NOT Foldseek).
TMalign representatives_trimmed/structure_001.pdb \
  -dir2 scope_domains/ scope_targets.list \
  -suffix .ent -ter 1 -split 0 -outfmt 2 > scope_001.tsv

# Keep max query-normalized SCOPe TM-score <0.5; exclude if ANY hit also has
# query-aligned fraction >=0.5 AND target-normalized SCOPe TM-score >=0.5.

# 2. Search SCOPe-passing candidates against PDB with Foldseek.
foldseek createdb scope_pass_pdb scope_pass_db
foldseek search scope_pass_db pdb_db pdb_results pdb_tmp \
  --threads 20 --alignment-type 1 -s 9.5 -e 1000 --max-seqs 1000 -a
foldseek convertalis scope_pass_db pdb_db pdb_results pdb_hits.tsv \
  --format-output 'query,target,evalue,alnlen,qcov,tcov,qtmscore,ttmscore'

# 3. Search AFDB_rep_v4 ONLY for queries not matched in PDB.
# A PDB match requires BEST query TM-score >=0.5 AND query coverage >=0.5.
foldseek createdb pdb_unmatched_pdb afdb_query_db
foldseek search afdb_query_db afdb_rep_v4_db afdb_results afdb_tmp \
  --threads 20 --alignment-type 1 -s 9.5 -e 1000 --max-seqs 1000 -a
foldseek convertalis afdb_query_db afdb_rep_v4_db afdb_results afdb_hits.tsv \
  --format-output 'query,target,evalue,alnlen,qcov,tcov,qtmscore,ttmscore'

# Apply the same BEST qTM-score >=0.5 and qcov >=0.5 criterion to AFDB hits.
