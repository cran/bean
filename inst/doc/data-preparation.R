## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5,
  out.width = "90%"
)
has_terra <- requireNamespace("terra",   quietly = TRUE)
has_ggplot2 <- requireNamespace("ggplot2", quietly = TRUE)

## ----eval = has_terra, message = FALSE, warning = FALSE-----------------------
library(bean)
library(terra)

occ_file <- system.file("extdata", "Rusa_unicolor.csv", package = "bean")
env_file <- system.file("extdata", "thai_env.tif",     package = "bean")

occ_data_raw <- read.csv(occ_file)
env <- terra::rast(env_file)

head(occ_data_raw)
env

## ----eval = has_terra, fig.width = 9, fig.height = 7--------------------------
plot(env, mar = c(1.5, 1.5, 2, 4))

## ----eval = has_terra && has_ggplot2, fig.width = 7, fig.height = 6-----------
library(ggplot2)
env_df <- as.data.frame(env[[1]], xy = TRUE)

ggplot(occ_data_raw, aes(x, y)) +
  geom_raster(data = env_df, aes(x, y, fill = .data[[names(env)[1]]])) +
  geom_point(alpha = 0.6, colour = "darkred", size = 1.4) +
  scale_fill_gradient(low = "grey95", high = "grey55", guide = "none") +
  coord_fixed() +
  labs(title = "Raw occurrence points",
       subtitle = sprintf("n = %d records", nrow(occ_data_raw))) +
  theme_classic()

## ----eval = has_terra---------------------------------------------------------
prepared <- prepare_bean(
  data = occ_data_raw,
  env_rasters = env,
  longitude = "x",
  latitude = "y",
  transform = "scale"
)
head(prepared)
summary(prepared[, -(1:3)])

## ----eval = has_terra && has_ggplot2, fig.width = 7, fig.height = 6-----------
ggplot() +
  geom_raster(data = env_df, aes(x, y, fill = .data[[names(env)[1]]])) +
  geom_point(data = occ_data_raw, aes(x, y),
             colour = "red", size = 1.4, alpha = 0.5) +
  geom_point(data = prepared, aes(x, y),
             colour = "#118ab2", size = 1.4, alpha = 0.8) +
  scale_fill_gradient(low = "grey95", high = "grey55", guide = "none") +
  coord_fixed() +
  labs(title = "Prepared occurrence points (blue) vs. raw (grey)",
       subtitle = sprintf("retained %d of %d records",
                          nrow(prepared), nrow(occ_data_raw))) +
  theme_classic()

## -----------------------------------------------------------------------------
data(origin_dat_prepared, package = "bean")
head(origin_dat_prepared)

