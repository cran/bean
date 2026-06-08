## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse  = TRUE,
  comment   = "#>",
  fig.width = 7,
  fig.height = 5,
  out.width = "90%"
)

## ----setup--------------------------------------------------------------------
library(bean)
data(origin_dat_prepared,    package = "bean")
data(thinned_stochastic,     package = "bean")
data(thinned_deterministic,  package = "bean")
env_vars <- c("bio_1", "bio_4", "bio_12", "bio_15")

## -----------------------------------------------------------------------------
origin_ellipse <- fit_ellipsoid(
  data     = origin_dat_prepared,
  env_vars = env_vars,
  method   = "covmat",
  level    = 0.95
)

stochastic_ellipse <- fit_ellipsoid(
  data     = thinned_stochastic$thinned_data,
  env_vars = env_vars,
  method   = "covmat",
  level    = 0.95
)

deterministic_ellipse <- fit_ellipsoid(
  data     = thinned_deterministic$thinned_points,
  env_vars = env_vars,
  method   = "covmat",
  level    = 0.95
)

origin_ellipse
stochastic_ellipse
deterministic_ellipse

## ----fig.width = 6, fig.height = 6--------------------------------------------
plot(origin_ellipse,        dims = c("bio_1", "bio_12"))
plot(stochastic_ellipse,    dims = c("bio_1", "bio_12"))
plot(deterministic_ellipse, dims = c("bio_1", "bio_12"))

## -----------------------------------------------------------------------------
origin_ellipse$centroid
origin_ellipse$cov_matrix
origin_ellipse$dimensions
origin_ellipse$var_names
head(origin_ellipse$points_in_ellipse)

## ----eval = FALSE-------------------------------------------------------------
# # Installing and loading packages
# if (!require("devtools")) install.packages("devtools")
# 
# # To install the package use
# devtools::install_github("castanedaM/nicheR")
# 
# library(nicheR)

## ----eval = FALSE-------------------------------------------------------------
# library(terra)
# 
# env <- terra::rast(system.file("extdata", "thai_env.tif", package = "bean"))
# 
# # 'origin_ellipse' is the bean_ellipsoid we fitted above.
# suit <- predict(
#   origin_ellipse,
#   newdata               = env,
#   include_suitability   = TRUE,
#   suitability_truncated = TRUE,
#   include_mahalanobis   = FALSE
# )
# terra::plot(suit)

