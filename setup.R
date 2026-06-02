# setup.R
# One-off bootstrap: installs and loads every R package the project's
# notebooks and Shiny apps depend on. Run once after cloning:
#
#     source("setup.R")
#
# Uses `pacman` so missing packages are installed from CRAN automatically.

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  # Project plumbing
  here,        # repo-relative paths
  pacman,      # the loader itself

  # Data I/O
  arrow,       # open_dataset(), read_parquet(), write_parquet(), collect()
  sfarrow,     # st_read_parquet() for spatial parquet
  readr,       # CSV I/O
  readxl,      # Excel I/O (Destatis manual exports)
  xml2,        # parsing the raw MaStR XML dump

  # Spatial
  sf,          # vector spatial data
  giscoR,      # Eurostat GISCO NUTS boundaries

  # Tidyverse-style data manipulation
  dplyr,       # rename, mutate, filter, joins, group_by, summarise, ...
  tidyr,       # complete(), pivot_*()
  tibble,      # tibble(), tribble()
  purrr,       # map(), pmap()
  stringr,     # str_pad() and friends
  lubridate,   # floor_date(), year(), make_date()

  # Plotting
  ggplot2,     # static charts
  leaflet,     # interactive maps (default mapping library — see CLAUDE.md)

  # Destatis (German statistical office) API
  restatis,    # gen_table(), gen_auth_save(), gen_logincheck()

  # Shiny apps
  shiny,       # shinyApp(), fluidPage(), reactive(), ...
  bslib,       # page_fluid(), bs_theme(), card(), layout_columns()
  htmltools,   # HTML(), tags$style(), tags$head()

  # Performance
  data.table   # fast aggregations / fwrite()
)
