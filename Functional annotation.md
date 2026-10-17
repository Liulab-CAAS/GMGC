# Functional annotation

```bash
# run eggnog:
emapper.py  -m diamond --no_annot --no_file_comments --data_dir ${db}/eggnog5/ --cpu 40 -i 1619.faa -o eggnog1619/protein --override
emapper.py  --annotate_hits_table eggnog1619/protein.emapper.seed_orthologs --no_file_comments -o output --cpu 3 --data_dir ${db}/eggnog5 --overrid

# run kofamscan :
exec_annotation --tmp-dir temp -p ${db}/KofamKOALA/profiles -k ${db}/KofamKOALA/ko_list -o kofam/1619faa.tvs --cpu 40 --format detail-tsv -E 1e-5 1619.faa >> kofam/1619.faa.log 2>&1 & 
```





