## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5,
  out.width = "90%"
)
has_terra <- requireNamespace("terra", quietly = TRUE)
has_nicheR <- requireNamespace("nicheR", quietly = TRUE)

## ----setup--------------------------------------------------------------------
library(bean)
data(origin_dat_prepared, package = "bean")
data(thinned_stochastic, package = "bean")
data(thinned_deterministic, package = "bean")
env_vars <- c("bio_1", "bio_4", "bio_12", "bio_15")

## -----------------------------------------------------------------------------
origin_ellipse <- fit_ellipsoid(
  data = origin_dat_prepared,
  env_vars = env_vars,
  method = "covmat",
  level = 0.95
)

stochastic_ellipse <- fit_ellipsoid(
  data = thinned_stochastic$thinned_data,
  env_vars = env_vars,
  method = "covmat",
  level = 0.95
)

deterministic_ellipse <- fit_ellipsoid(
  data = thinned_deterministic$thinned_points,
  env_vars = env_vars,
  method = "covmat",
  level = 0.95
)

origin_ellipse
stochastic_ellipse
deterministic_ellipse

## ----fig.width = 6, fig.height = 6--------------------------------------------
plot(origin_ellipse, dims = c("bio_1", "bio_12"))
plot(stochastic_ellipse, dims = c("bio_1", "bio_12"))
plot(deterministic_ellipse, dims = c("bio_1", "bio_12"))

## -----------------------------------------------------------------------------
origin_ellipse$centroid
origin_ellipse$cov_matrix
origin_ellipse$dimensions
origin_ellipse$var_names
head(origin_ellipse$points_in_ellipse)

## ----eval = FALSE-------------------------------------------------------------
# install.packages("nicheR")
# library(nicheR)

## ----eval = has_nicheR && has_terra, fig.width = 9, fig.height = 4------------
library(nicheR)
library(terra)

# Load the raster and scale each layer to mean 0, SD 1 — matching how
# the ellipsoids were trained.
env <- terra::rast(system.file("extdata", "thai_env.tif",
                               package = "bean"))
env_scaled <- terra::scale(env)

# Project each ellipsoid back into geographic space.
origin_suit <- predict(
  origin_ellipse,
  newdata             = env_scaled,
  include_suitability = TRUE,
  include_mahalanobis = FALSE
)

stochastic_suit <- predict(
  stochastic_ellipse,
  newdata             = env_scaled,
  include_suitability = TRUE,
  include_mahalanobis = FALSE
)

deterministic_suit <- predict(
  deterministic_ellipse,
  newdata             = env_scaled,
  include_suitability = TRUE,
  include_mahalanobis = FALSE
)

# Three-panel comparison: Original / Stochastic / Deterministic.
# A shared colour scale (range = [0, 1]) makes the panels directly
# comparable; the same legend applies to all three.
op <- par(mfrow = c(1, 3), mar = c(2.5, 2.5, 3, 4))
terra::plot(origin_suit[["suitability"]],
            main  = "Original (unthinned)",
            range = c(0, 1))
terra::plot(stochastic_suit[["suitability"]],
            main  = "Stochastic thinning",
            range = c(0, 1))
terra::plot(deterministic_suit[["suitability"]],
            main  = "Deterministic thinning",
            range = c(0, 1))
par(op)

