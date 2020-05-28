## Usage

To see description for every option run `python3 LSEA_2.0.py --help`.

## Data format

Input file (tsv) should contain headers. You should pass as parameter 4 column names - for chromosome, position, id and pval. See  `data/in.tsv`.
Output file contains pathway, p-value and q-value. See `data/result.tsv` for example.

## Examples
To run full pipeline with *plink* run:  
`
python3 LSEA_2.0.py -tsv ./in.tsv -pldir <plink_folder_path> -b_file ../phase3_binary/EUR_1KG_nodups -gene_file ../data/gencode_formatted.tsv -json universe.json -column_names CHR BP SNP P
`


To use pregenerated file from *plink* run:  
`
python3 LSEA_2.0.py -tsv ./in.tsv -use_clumped ./<clumped_file>.clumped -interval 100000 -gene_file ../data/gencode_formatted.tsv -json universe.json -column_names CHR BP SNP P
`  

To generate universe run:
`
python3 universe_generator.py -path ./in.tsv -gene_file ../data/gencode_formatted.tsv -msig_path ../c2.all.v7.0.symbols.gmt  -interval 100000
`
