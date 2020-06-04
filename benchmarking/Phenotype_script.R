library(PhenotypeSimulator)
setwd('~/GWAS/Server/pathway/')


genotypes <- readStandardGenotypes(N=1000, filename='genotypes_hapgen.controls.caspase',
                                   format="plink")


causalSNPs <-getCausalSNPs(N=1000, genotypes = genotypes$genotypes,NrCausalSNPs = 15, verbose = TRUE)
genFixed <-geneticFixedEffects(N = 1000, P = 10, X_causal = causalSNPs, pIndependentGenetic = 1,
                               pTraitIndependentGenetic = 1, mBeta = 0.25, sdBeta = 0.25)

genotypes <- readStandardGenotypes(N=1000, filename='genotypes_subset_hapgen.controls',
                                   format="plink")

genotypes_sd <-standardiseGenotypes(genotypes$genotypes)
kinship <- getKinship(N=1000, X=genotypes_sd, verbose = FALSE)

genBg <-geneticBgEffects(N=1000, kinship = kinship, P = 10)

genVar <- 0.3
noiseVar <- 1 - genVar
h2s <- 0.8
phi <- 0.6 
rho <- 0.1
delta <- 0.3
shared <- 0.3
independent <- 1 - shared

genFixed_shared_scaled <- rescaleVariance(genFixed$shared, shared * h2s *genVar)
genFixed_independent_scaled <- rescaleVariance(genFixed$independent, 
                                               independent * h2s *genVar)
genBg_shared_scaled <- rescaleVariance(genBg$shared, shared * (1-h2s) *genVar)
genBg_independent_scaled <- rescaleVariance(genBg$independent, 
                                            independent * (1-h2s) * genVar)

total <- shared * h2s*genVar +  independent * h2s*genVar +
  shared * (1-h2s)*genVar +   independent * (1-h2s)*genVar +
  shared * phi* noiseVar +  independent * phi* noiseVar +
  rho * noiseVar +
  shared * delta * noiseVar +  independent * delta * noiseVar

total == 1
      

Y_onlygens <- scale(genFixed_independent_scaled$component + genBg_independent_scaled$component)

row.names(Y_onlygens) <- genotypes[["id_samples"]]

image(t(Y_onlygens), main="Phenotype: [samples x traits]", 
      axes=FALSE, cex.main=0.8)


write.table(Y_onlygens, 'Y_caspase', sep = '\t', col.names = FALSE)
