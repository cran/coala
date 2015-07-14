#' @importFrom R6 R6Class
stat_segsites_class <- R6Class("stat_segsites", inherit = sumstat_class,
  private = list(req_segsites = TRUE),
  public = list(
    calculate = function(seg_sites, trees, files, model) seg_sites
  )
)


#' Returns the Segregation Sites Statistics from simulations
#'
#' @inheritParams sumstat_four_gamete
#' @export
sumstat_seg_sites <- function(name = "seg_sites") {
  stat_segsites_class$new(name) #nolint
}


conv_for_trios <- function(seg_sites, model) {
  for (i in seq(along = seg_sites)) {
    locus_length <- get_locus_length(model, i, total = FALSE)
    if (length(locus_length) == 1) next

    total_length <- sum(locus_length)
    borders <- cumsum(locus_length[1:4] / total_length)
    pos <- attr(seg_sites[[i]], "positions")
    left <- pos < borders[1]
    middle <- pos >= borders[2] & pos < borders[3]
    right <- pos >= borders[4]
    seg_sites[[i]] <- seg_sites[[i]][, left | middle | right, drop = FALSE]
    assert_that(nrow(seg_sites[[i]]) > 0)

    pos[left] <- pos[left] * total_length / locus_length[1]
    pos[middle] <- (pos[middle] - borders[2]) * total_length / locus_length[3]
    pos[right] <- (pos[right] - borders[4]) * total_length / locus_length[5]

    attr(seg_sites[[i]], "positions") <- pos[left | middle | right]
    attr(seg_sites[[i]], "locus") <- c(rep(-1, sum(left)),
                                       rep(0, sum(middle)),
                                       rep(1, sum(right)))
  }
  seg_sites
}