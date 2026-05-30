## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse  = TRUE,
  comment   = "#>",
  fig.width = 7,
  fig.height = 5,
  out.width = "90%"
)
has_terra   <- requireNamespace("terra",   quietly = TRUE)
has_ggplot2 <- requireNamespace("ggplot2", quietly = TRUE)

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

## ----eval = has_terra---------------------------------------------------------
library(terra)
env <- terra::rast(system.file("extdata", "thai_env.tif", package = "bean"))

env_scaled <- terra::scale(env)

origin_pred <- predict(
  object = origin_ellipse,
  newdata = env_scaled,
  include_suitability = TRUE,
  suitability_truncated = FALSE,
  include_mahalanobis = FALSE
)

stochastic_pred <- predict(
  object = stochastic_ellipse,
  newdata = env_scaled,
  include_suitability = TRUE,
  suitability_truncated = FALSE,
  include_mahalanobis = FALSE
)

deterministic_pred <- predict(
  object = deterministic_ellipse,
  newdata = env_scaled,
  include_suitability = TRUE,
  suitability_truncated = FALSE,
  include_mahalanobis = FALSE
)

## ----eval = has_terra, fig.width = 9, fig.height = 4--------------------------
suit_stack <- c(origin_pred[["suitability"]],
                stochastic_pred[["suitability"]],
                deterministic_pred[["suitability"]])
names(suit_stack) <- c("Raw (unthinned)",
                       "Stochastic thinning",
                       "Deterministic thinning")

terra::plot(suit_stack, nc = 3, mar = c(2, 2, 2.5, 4))

## ----eval = has_terra, fig.width = 9, fig.height = 4--------------------------
origin_trunc <- predict(origin_ellipse,env_scaled,
                        include_suitability = FALSE,
                        suitability_truncated = TRUE,
                        include_mahalanobis = FALSE)
stoch_trunc <- predict(stochastic_ellipse, env_scaled,
                        include_suitability = FALSE,
                        suitability_truncated = TRUE,
                        include_mahalanobis = FALSE)
det_trunc <- predict(deterministic_ellipse, env_scaled,
                        include_suitability = FALSE,
                        suitability_truncated = TRUE,
                        include_mahalanobis = FALSE)

trunc_stack <- c(origin_trunc[["suitability_trunc"]],
                 stoch_trunc[["suitability_trunc"]],
                 det_trunc[["suitability_trunc"]])
names(trunc_stack) <- c("Raw (unthinned)",
                        "Stochastic thinning",
                        "Deterministic thinning")
terra::plot(trunc_stack, nc = 3, mar = c(2, 2, 2.5, 4))

## ----eval = has_terra---------------------------------------------------------
summary_df <- data.frame(
  model = c("Raw", "Stochastic", "Deterministic"),
  mean_suit = sapply(list(origin_pred, stochastic_pred, deterministic_pred),
                        function(p) mean(terra::values(p[["suitability"]]), na.rm = TRUE)),
  median_suit = sapply(list(origin_pred, stochastic_pred, deterministic_pred),
                        function(p) median(terra::values(p[["suitability"]]), na.rm = TRUE))
)
summary_df

