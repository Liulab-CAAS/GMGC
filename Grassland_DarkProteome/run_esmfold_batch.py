import os
import re
import sys
import torch
import esm


N_THREADS = int(os.environ.get("OMP_NUM_THREADS", "10"))
torch.set_num_threads(N_THREADS)
torch.set_num_interop_threads(1)

fasta_file = sys.argv[1] if len(sys.argv) > 1 else "tai.txt"
outdir = sys.argv[2] if len(sys.argv) > 2 else "esmfold_pdb"
os.makedirs(outdir, exist_ok=True)

def read_fasta(path):
    seqs = []
    name = None
    seq_lines = []
    with open(path, "r") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if line.startswith(">"):
                if name is not None:
                    seq = "".join(seq_lines).replace(" ", "").replace("\r", "")
                    seqs.append((name, seq))
                name = line[1:].split()[0]
                seq_lines = []
            else:
                seq_lines.append(line)
        if name is not None:
            seq = "".join(seq_lines).replace(" ", "").replace("\r", "")
            seqs.append((name, seq))
    return seqs

def safe_name(name):
    return re.sub(r'[^A-Za-z0-9._-]', '_', name)

seqs = read_fasta(fasta_file)
if not seqs:
    print(f"ERROR: No FASTA sequences found in {fasta_file}")
    sys.exit(1)

print(f"Loaded {len(seqs)} sequences")

model = esm.pretrained.esmfold_v1()
model = model.eval()
model = model.float()
model.esm = model.esm.float()

ok = 0
fail = 0

with torch.no_grad():
    for i, (name, seq) in enumerate(seqs, 1):
        outname = safe_name(name) + ".pdb"
        outfile = os.path.join(outdir, outname)

        print(f"[{i}/{len(seqs)}] Processing: {name}  length={len(seq)}")

        try:
            pdb = model.infer_pdb(seq)
            with open(outfile, "w") as f:
                f.write(pdb)
            print(f"  saved: {outfile}")
            ok += 1
        except Exception as e:
            print(f"  ERROR: {name} -> {e}")
            fail += 1

print(f"Completed: {ok} succeeded, {fail} failed")
print(f"PDB output directory: {outdir}")
