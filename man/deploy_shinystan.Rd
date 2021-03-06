% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/deploy_shinystan.R
\name{deploy_shinystan}
\alias{deploy_shinystan}
\title{Deploy a ShinyStan app to shinyapps.io}
\usage{
deploy_shinystan(sso, appName, account = NULL, ...)
}
\arguments{
\item{sso}{shinystan object.}

\item{appName}{The name to use for the application. Application names must be
at least four characters long and may only contain letters, numbers, dashes
and underscores.}

\item{account}{ShinyApps account username. Only required if more than one
ShinyApps account is configured on the system. See
\url{http://www.shinyapps.io/} for help configuring your account.}

\item{...}{Optional arguments. See Details.}
}
\description{
Requires a (free or paid) ShinyApps account. Visit
\url{http://www.shinyapps.io/} to sign up.
}
\details{
In \code{...}, the arguments \code{ppcheck_data} and
  \code{ppcheck_yrep} can be specified. \code{ppcheck_data} should be a
  vector of observations to use for graphical posterior predictive checking
  and \code{ppcheck_yrep} should be a character string naming the parameter
  in \code{sso} containing the posterior predictive simulations/replications.
  The value of \code{ppcheck_yrep} is only used to preselect the appropriate
  parameter/generated quantity to use for the posterior predictive checking.
  \code{ppcheck_yrep} (but not \code{ppcheck_data}) can also be set
  interactively on shinyapps.io when using the app.
}
\note{
See the 'Deploying to shinyapps.io' vignette for a more detailed
  example.
}
\examples{
\dontrun{
# For this example assume my_sso is the name of the shinystan object for
# the model you want to use. Assume also that you want to name your app
# 'my-model' and that your ShinyApps username is 'username'.

deploy_shinystan(sso = my_sso, appName = "my-model", account = "username")

# If you only have one ShinyApps account configured then you can also omit
# the 'account' argument.

deploy_shinystan(sso = my_sso, appName = "my-model")
}
}

