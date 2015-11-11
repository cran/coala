## ----sfs-----------------------------------------------------------------
sfs <- c(112, 57, 24, 34, 16, 29, 8, 10, 15)

## ----model setup---------------------------------------------------------
library(coala)
model <- coal_model(10, 50) +
  feat_mutation(par_prior("theta", runif(1, 1, 5))) +
  sumstat_sfs()

## ----simulate, cache=TRUE------------------------------------------------
sim_data <- simulate(model, nsim = 2000, seed = 17)

## ------------------------------------------------------------------------
# Getting the parameters
sim_pars <- matrix(sapply(sim_data, function(x) x$pars), 2000, 1)
colnames(sim_pars) <- "theta"
head(sim_pars, n = 3)

# Getting the summary statistics
sim_sumstats <- t(sapply(sim_data, function(x) x$sfs))
colnames(sim_sumstats) <- paste0("S", 1:9)
head(sim_sumstats, n = 3)

## ----abc, fig.align="center", fig.width=5--------------------------------
suppressPackageStartupMessages(library(abc))
posterior <- abc(sfs, sim_pars, sim_sumstats, 0.05, method = "rejection")
hist(posterior, breaks = 10)

