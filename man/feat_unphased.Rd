% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/feature_unphased.R
\name{feat_unphased}
\alias{feat_unphased}
\title{Feature: Unphased Sequences}
\usage{
feat_unphased(samples_per_ind, locus_group = "all")
}
\arguments{
\item{samples_per_ind}{The number of pseudo-chromosomes that are created
from the phased chromosomes for each individual.}

\item{locus_group}{The loci for which this features is used. Can either be
\code{"all"} (default), in which case the feature is used for simulating
all loci, or a numeric vector. In the latter case, the feature is only
used for the loci added in \code{locus_} commands  with the corresponding
index starting from 1 in order in which the commands where added to the
model. For example, if a model has
\code{locus_single(10) + locus_averaged(10, 11) + locus_single(12)} and
this argument is \code{c(2, 3)}, than the feature is used for all but
the first locus (that is locus 2 - 12).}
}
\value{
The feature, which can be added to a model using \code{+}.

The feature, which can be added to a model created with
\code{\link{coal_model}} using \code{+}.
}
\description{
This simulates unphased data by randomly mixing the sites within one
individual. Each position is randomly taken from a phased chromosome..
}
\details{
For each individual, \code{ploidy} chromosomes are simulated, and
\code{samples_per_ind} pseudo-chromosomes are created of these.
}
\examples{
# Simulate unphased data in a diploid population
model <- coal_model(10, 1, ploidy = 2) +
  feat_mutation(10) +
  feat_unphased(2) +
  sumstat_seg_sites()
simulate(model)

# The same as before, but return only one chromosome for
# each individual:
model <- coal_model(10, 1, ploidy = 2) +
  feat_mutation(10) +
  feat_unphased(1) +
  sumstat_seg_sites()
simulate(model)
}
\seealso{
For creating a model: \code{\link{coal_model}}

Other features: 
\code{\link{feat_growth}()},
\code{\link{feat_ignore_singletons}()},
\code{\link{feat_migration}()},
\code{\link{feat_mutation}()},
\code{\link{feat_outgroup}()},
\code{\link{feat_pop_merge}()},
\code{\link{feat_recombination}()},
\code{\link{feat_selection}()},
\code{\link{feat_size_change}()}
}
\concept{features}
