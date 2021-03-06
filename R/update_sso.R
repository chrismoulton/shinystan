#' Update an object created by an earlier version of shinystan
#' 
#' Before you can use an old shinystan object (sso) with the new version of 
#' shinystan you might need to run \code{update_sso}. The updated sso
#' will then have all the slots that will be accessed by the ShinyStan app. 
#' 
#' @export
#' @param old_sso An old shinystan object to update.
#' @return sso, updated. 
#' 
#' @examples 
#' \dontrun{
#' sso_new <- update_sso(sso_old)
#' }  
#' 
update_sso <- function(old_sso) {
  stopifnot(is.shinystan(old_sso))
  sso_name <- deparse(substitute(old_sso))
  new_sso <- new("shinystan")
  snms <- slotNames("shinystan")
  m <- which(snms == "misc")
  for (nm in snms[-m]) {
    slot(new_sso, nm) <- slot(old_sso, nm)
  }
  if (.hasSlot(old_sso, "stan_algorithm")) {
    new_sso@misc$stan_algorithm <- slot(old_sso, "stan_algorithm")
  }
  if (new_sso@misc$stan_algorithm == "NUTS") {
    new_sso@misc$max_td <- 11
    message("Note: max_treedepth cannot be recovered from ", sso_name, 
            " so using default RStan value.")
  }
  new_sso
}
