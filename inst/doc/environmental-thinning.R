## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5,
  out.width = "90%"
)
has_ggplot2 <- requireNamespace("ggplot2", quietly = TRUE)

## ----setup--------------------------------------------------------------------
library(bean)
data(origin_dat_prepared, package = "bean")
env_vars <- c("bio_1", "bio_4", "bio_12", "bio_15")

## -----------------------------------------------------------------------------
res <- find_env_resolution(
  data = origin_dat_prepared,
  env_vars = env_vars,
  method = "sheather-jones"
)
res

## ----fig.width = 8, fig.height = 6--------------------------------------------
plot(res)

## -----------------------------------------------------------------------------
sapply(c("sheather-jones", "silverman", "scott"), function(m) {
  find_env_resolution(origin_dat_prepared, env_vars, method = m)$suggested_resolution
})

## -----------------------------------------------------------------------------
thinned_stochastic <- thin_env_nd(
  data = origin_dat_prepared,
  env_vars = env_vars,
  grid_resolution = res$suggested_resolution,
  seed = 1
)
thinned_stochastic

## -----------------------------------------------------------------------------
thinned_deterministic <- thin_env_center(
  data = origin_dat_prepared,
  env_vars = env_vars,
  grid_resolution = c(0.5, 0.5, 0.5, 0.5)
)
thinned_deterministic

## ----eval = has_ggplot2, fig.width = 8, fig.height = 6------------------------
library(ggplot2)
plot_compare <- rbind(
  data.frame(origin_dat_prepared[, env_vars], Status = "Original"),
  data.frame(thinned_stochastic$thinned_data[, env_vars], Status = "Stochastic"),
  data.frame(thinned_deterministic$thinned_points[, env_vars], Status = "Deterministic")
)
plot_compare$Status <- factor(plot_compare$Status,
                              levels = c("Original", "Stochastic", "Deterministic"))

ggplot(plot_compare, aes(bio_1, bio_12, colour = Status)) +
  geom_point(alpha = 0.5, size = 3) +
  facet_wrap(~Status, nrow = 1) +
  scale_colour_manual(values = c(Original = "#ef476f",
                                 Stochastic = "#118ab2",
                                 Deterministic = "#06d6a0"),
                      guide = "none") +
  theme_classic() +
  labs(title = "Occurrences in environmental space",
       x = "bio_1 (scaled)", y = "bio_12 (scaled)")

## ----fig.width = 8, fig.height = 8--------------------------------------------
plot_bean(
  original_data = origin_dat_prepared,
  thinned_object = thinned_stochastic,
  env_vars = env_vars
)

## ----fig.width = 8, fig.height = 8--------------------------------------------
plot_bean(
  original_data = origin_dat_prepared,
  thinned_object = thinned_deterministic,
  env_vars = env_vars
)

