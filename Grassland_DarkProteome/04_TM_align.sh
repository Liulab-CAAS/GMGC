#!/usr/bin/env bash
# Step 04: Pairwise TM-align comparisons of protein structures.
# Files:
#   high_quality_trimmed/       Prepared high-confidence, trimmed PDB structures.
#   structure_001.pdb          Example query PDB in that directory.
#   trimmed_targets.list       List of target PDB IDs.
#   structure_001.TMalign.tsv  Pairwise TM-align results.
#   structure_similarity.dot   Prepared structural similarity network (both TM-scores >0.6).
#   structure_component*.dot  Individual connected components (Graphviz DOT).

# 1. Repeat for all structures in high_quality_trimmed/.
TMalign high_quality_trimmed/structure_001.pdb \
  -dir2 high_quality_trimmed/ trimmed_targets.list \
  -suffix .pdb -ter 1 -split 0 -outfmt 2 > structure_001.TMalign.tsv

# 2. Include an edge ONLY when BOTH directional TM-scores are >0.6.
# 3. Compute connected components from the prepared network.
ccomps -x -o structure_component.dot structure_similarity.dot

# Representative selection must follow the Methods: highest mean of
# min(TM1, TM2) over members; tie-break by minimum pair score, direct degree,
# and structure ID. The selection calculation is NOT encoded in these commands.
