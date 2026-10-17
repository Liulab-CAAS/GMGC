#!/usr/bin/env bash
# Step 02: Protein family alignment and Pfam-A re-screening.
# Files:
#   family_001.faa         Protein sequences from one family.
#   family_001.msa.faa     Clustal Omega alignment.
#   family_001.seed.faa    Prepared seed alignment (>=90% identity, >=75% coverage).
#   family_001.hmm         Family profile HMM.
#   family_consensus.faa   Prepared consensus sequences of all families.
#   Pfam-A.hmm             Pfam-A database; hmmpress creates its index files.
#   pfam_hits.out          Human-readable HMMER search results.
#   pfam_hits.tblout       Sequence-level Pfam matches.
#   pfam_hits.domtblout    Domain-level Pfam matches.

# 1. Repeat for all families to generate full alignments.
clustalo -i family_001.faa -o family_001.msa.faa --outfmt=fasta --threads=2 --force

# 2. Repeat for all prepared seed MSAs (90% identity; 75% both coverages).
hmmbuild --amino family_001.hmm family_001.seed.faa

# 3. Search consensus sequences from ALL families against Pfam-A.
hmmpress -f Pfam-A.hmm
hmmscan --cpu 60 -T 7.0 --domT 5.0 --incT 7.0 --incdomT 5.0 --noali \
  --tblout pfam_hits.tblout --domtblout pfam_hits.domtblout \
  Pfam-A.hmm family_consensus.faa > pfam_hits.out

# Retain Pfam-negative families only after evaluating the reported hit scores.
