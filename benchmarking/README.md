# Benchmarking
The process of benchmarking implies several steps including genotype and phenotype data simulation, GWAS association
and lastly gene set analysis with LSEA.

### 1. Haplotype simulation with HapGen2 based on 1000GP_Phase3 genotype data

```{r, engine=bash}
hapdir=~/1000GP_Phase3
for chr in `seq 1 22`; do
	gunzip $hapdir/1000GP_Phase3_chr${chr}.legend.gz
	gunzip $hapdir/1000GP_Phase3_chr${chr}.hap.gz
	dummyDL=`sed -n '2'p $hapdir/1000GP_Phase3_chr${chr}.legend | cut -d ' ' -f 2`
	hapgen2 -m $hapdir/genetic_map_chr${chr}_combined_b37.txt \
        -l $hapdir/1000GP_Phase3_chr${chr}.legend \
        -h $hapdir/1000GP_Phase3_chr${chr}.hap -o ~/hapgen_results/genotypes_chr${chr}_hapgen \
        -dl $dummyDL 0 0 0 -n 1000 0 -no_haps_output 
	rm $hapdir/1000GP_Phase3_chr${chr}.hap
done
```

### 2. Conversion of Oxford to PLINK format

```{r, engine=bash}
for chr in `seq 1 22`; do
        plink --data genotypes_chr${chr}_hapgen.controls \
        --oxford-single-chr $chr \
        --make-bed \
        --out genotypes_chr${chr}_hapgen.controls
        
	echo -e "genotypes_chr${chr}_hapgen.controls" >> ~/hapgen_results/file_list
done

plink --merge-list file_list --make-bed --out genotypes_genome_hapgen.controls
```

### 3. Variant selection for causal SNP and genetic background simulation

```{r, engine=bash}
~/plink/plink --bfile genotypes_genome_hapgen.controls --extract caspase_list.txt \
--make-bed --out genotypes_hapgen.controls.caspase

cut -f2 genotypes_genome_hapgen.controls.bim > snps.map 
shuf -n 985 snps.map > snps.subset.map
#add causal SNP to snps.subset.map with nano

~/plink/plink --bfile genotypes_genome_hapgen.controls --extract snps.subset.map \
--make-bed --out genotypes_subset_hapgen.controls
```

### 4. Phenotype construction via PhenotypeSimulator (look into Phenotype_script.R)

### 5. GWAS association via PLINK

```{r, engine=bash}
cat Y_caspase | awk 'BEGIN { FS="\t"; OFS="\t" } { $1=$1 "\t" $1 } 1' > Y_caspase1 
cat Y_caspase1 | awk '{FS="\t";OFS="\t"} {sub("id1_","id2_",$2)}1' > Y_caspase2
cat Y_caspase2 | tr -d '"' > Y_caspase3

nohup ~/plink/plink --bfile genotypes_genome_hapgen.controls --maf 0.05 --hwe 1e-10 --allow-no-sex --pheno Y_caspase3 --all-pheno --assoc --out A_caspase &

```
### 6. LSEA gene set analysis

```{r, engine=bash}
for P in `seq 2 10`; do
        python3 ~/lsea/LSEA/LSEA_2.0.py -tsv ~/last_pathway_fmt/A_caspase_onlygens.P${P}.qassoc -pld ~/plink/ -b_file ~/pathway/genotypes_genome_hapgen.controls \
        -interval 100000 -gene_file ~/lsea/data/gencode_formatted.tsv -json ~/lsea/LSEA/universe.json -column_names chr bp snp p -qval_threshold 0.01
        
        mv result.tsv result_P${P}.tsv
done

```
