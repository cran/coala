#' @importFrom R6 R6Class
stat_four_gamete_class <- R6Class("stat_four_gamete", inherit = sumstat_class,
  private = list(
    population = NULL,
    req_segsites = TRUE
  ),
  public = list(
    initialize = function(name, population) {
      assert_that(is.numeric(population))
      assert_that(length(population) == 1)
      private$population <- population
      super$initialize(name)
    },
    calculate = function(seg_sites, trees, files, model) {
      calc_four_gamete_stat(seg_sites,
                            get_population_indiviuals(model,
                                                      private$population),
                            get_locus_length_matrix(model))
    }
  )
)

#' A Summary Statistic based on the Four-Gamete-Condition
#'
#' The Four-Gamete-Condition for two SNPs is violated if all four combinations
#' of derived and ancestral alleles at the SNPs are observed in a gamete/a
#' haplotype. Under an Infinite-Sites mutation model, a violation indicates that
#' there must have been at least one recombination event between the SNPs.
#' This summary statistic calculates the percentage of certain pairs of SNPs
#' that violate the Four-Gamete-Condition.
#' It is sensitive for recombination and particularly useful when estimating
#' recombination rates.
#'
#' The statistic generates a matrix where each row represents one locus, and the
#' columns give the statistic for different classes of pairs of SNPs:
#'
#' \describe{
#' \item{mid_near}{The value for all pairs of SNPs that are close together, that
#'   is within 10 percent of the locus" length. If locus trios are used, only pairs of
#'   SNPs were both SNPs are on the middle locus are considered.}
#' \item{mid_far}{Same as \code{mid_near}, but for pairs of SNPs that are
#'   more that 10 percent of the locus" length apart. }
#' \item{outer}{Only when using locus trios. The statistic for pairs
#'   where both SNPs are on the same outer locus.}
#' \item{between}{Only when using locus trios. The statistic for pairs
#'   where one SNPs is on the middle locus, and the other is on an outer one.}
#' \item{mid}{The value for all pairs on the
#'   middle locus or all pairs when not using trios.}
#' \item{perc_polym}{The percentage of positions that are polymorpic.}
#' }
#'
#'
#' @param name The name of the summary statistic. When simulating a model,
#'   the value of the statistics are written to an entry of the returned list
#'   with this name. Summary statistic names must be unique in a model.
#' @param population The population for which the statistic is calculated.
#' @export
sumstat_four_gamete  <- function(name="four_gamete", population=1) {
  stat_four_gamete_class$new(name, population) #nolint
}