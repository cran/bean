## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5,
  out.width = "90%"
)

## ----setup--------------------------------------------------------------------
library(bean)

## ----quickstart---------------------------------------------------------------
data(origin_dat_prepared, package = "bean")
env_vars <- c("bio_1", "bio_4", "bio_12", "bio_15")

# 1. Pick an objective grid resolution from the data
res <- find_env_resolution(origin_dat_prepared, env_vars = env_vars)
res

# 2. Thin in environmental space
thinned <- thin_env_nd(
  data = origin_dat_prepared,
  env_vars = env_vars,
  grid_resolution = res$suggested_resolution,
  seed = 1
)
thinned

