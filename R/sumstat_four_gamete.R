#' @importFrom R6 R6Class
stat_four_gamete_class <- R6Class("stat_four_gamete", inherit = sumstat_class,
  private = list(
    population = NULL,
    req_segsites = TRUE
  ),
  public = list(
    initialize = function(name, population, transformation, na.rm=FALSE) {
      assert_that(identical(population, "all") || is.numeric(population))
      assert_that(length(population) == 1)
      private$population <- population
      super$initialize(name, transformation)
    },
    calculate = function(seg_sites, trees, files, model, sim_tasks = NULL, na.rm=FALSE) {
      individuals <- get_population_individuals(model, private$population,
                                                haploids = !is_unphased(model))
      calc_four_gamete_stat(seg_sites,
                            individuals,
                            get_locus_length_matrix(model),
                            ifelse(is_unphased(model),
                                   get_samples_per_ind(model), 1), na.rm)
    }
  )
)

#' Summary Statistic: Four-Gamete-Condition
#'
#' This summary statistic calculates a number of values (see 'Value')
#' related to the Four-Gamete-Condition (see 'Details').
#' It is sensitive for recombination and particularly useful when estimating
#' recombination rates with \pkg{jaatha} or Approximate Bayesian Computation.
#'
#' The Four-Gamete-Condition for two SNPs is violated if all four combinations
#' of derived and ancestral alleles at the SNPs are observed in a gamete/a
#' haplotype. Under an Infinite-Sites mutation model, a violation indicates that
#' there must have been at least one recombination event between the SNPs.
#'
#' @section Unphased Data:
#' For unphased data, the four gamete condition is only counted as violated if
#' it is violated for all possible phasing of the data.
#'
#' @param name The name of the summary statistic. When simulating a model,
#'   the value of the statistics are written to an entry of the returned list
#'   with this name. Summary statistic names must be unique in a model.
#' @param population The population for which the statistic is calculated.
#'   Can also be "all" to calculate it from all populations. Default is population 1.
#' @param transformation An optional function for transforming the results
#'   of the statistic. If specified, the results of the transformation are
#'   returned instead of the original values.
#' @param na.rm should missing data be ignored? Default is FALSE.
#' @return
#'   The statistic generates a matrix where each row represents one locus, and
#'   the columns give the statistic for different classes of pairs of SNPs:
#'
#'   \describe{
#'    \item{mid_near}{The value for all pairs of SNPs that are close together,
#'     that is within 10 percent of the locus" length. If locus trios are used,
#'     only pairs of SNPs were both SNPs are on the middle locus are considered.
#'     }
#'    \item{mid_far}{Same as \code{mid_near}, but for pairs of SNPs that are
#'     more that 10 percent of the locus" length apart. }
#'    \item{outer}{Only when using locus trios. The statistic for pairs
#'     where both SNPs are on the same outer locus.}
#'    \item{between}{Only when using locus trios. The statistic for pairs
#'     where one SNPs is on the middle locus, and the other is on an outer one.}
#'    \item{mid}{The value for all pairs on the
#'     middle locus or all pairs when not using trios.}
#'    \item{perc_polym}{The percentage of positions that are polymorpic.}
#'   }
#' @export
#' @template summary_statistics
#' @examples
#' model <- coal_model(5, 2) +
#'  feat_mutation(50) +
#'  feat_recombination(10) +
#'  sumstat_four_gamete()
#' stats <- simulate(model)
#' print(stats$four_gamete)
sumstat_four_gamete  <- function(name = "four_gamete", population = 1,
                                 transformation = identity, na.rm=FALSE) {
  stat_four_gamete_class$new(name, population, transformation, na.rm)
}
