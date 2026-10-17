# Biosynthetic gene cluster identification and clustering ：

Assessment of BGC novelty 



**MAGs**

- *Step 1: antiSMASH *  

```bash
# run antiSMASH:
antismash --genefinding-tool prodigal-m --output-dir \"${ANTISMASH_SUBDIR}\" --skip-sanitisation --cpu 8 \"${FILE_PATH}\" >> \"${LOG_FILE}\" 2>&1
```

- *Step 2: Contig assemble*

```bash
# run BiG-SCAPE:
bigscape -i \"${INPUT_GBK}\" -o \"${OUTPUT_DIR}\" --gcf-cutoffs 0.3,0.5 -m 3.1 -c 8 -p ${soft}/envs/antismash/lib/python3.11/site-packages/antismash/databases/pfam/35.0/Pfam-A.hmm

```

- 

```bash
# run BIG-SLiCE:
nohup bigslice --query anti/bgc_gbk_collection/ --program_db_folder /home/lin/db/biglice/ --num_threads 8 --query_name "full_run1619_11" full_run_result  --no_normalize_feature > bigslice_run1619_11.log 2>&1

```



