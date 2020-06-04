# LSEA_spring_project

## Background
Gene Set Enrichment Analysis (GSEA) is a method that determines whether a priori defined set of genes shows statistically significant differences between several phenotypes. GSEA is often conducted on GWAS association data, where each individual’s genetic variations have a certain trait association score. By segregating highly associated variations from different gene sets, we may distinguish complex processes, underlying investigated phenotypes.

There are several programs, facilitating gene set analysis on the basis of GWAS data. Those include INRICH, MAGMA, GSA-SNP2. We introduce Locus Set Enrichment Analysis tool for GSEA analysis. It is based on LD-based grouping of SNP, merging intervals around the lead SNP in a group and analyzing the occurrence of genes from different gene sets inside those intervals.

## Goals of the project
This project had two goals - to rewrite previous version of LSEA and to conduct benchmarking of the result.  
Source code and corresponding README is in `LSEA` folder, made by Kutlenkov Dmitrii.  
Benchmarking utils with README are in `benchmarking` folder, made by Alexeev Dmitrii.
