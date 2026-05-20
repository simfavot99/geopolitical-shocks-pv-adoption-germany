# geopolitical-shocks-pv-adoption-germany

Impact of geopolitical energy shocks on balcony PV adoption in Germany.

## Research question

Did the **2026 Iran war** measurably accelerate (or change the dynamics of) balcony PV adoption in Germany? The project measures this across several geographic levels (whole country, federal state, district, municipality) and compares the Iran-war shock to an earlier reference shock (the **Russian invasion of Ukraine**).

## Data

- **MaStR (Marktstammdatenregister)** — German solar-unit registry, used as the unit of observation. Two snapshots: [01_data/1.1. April 2026/](01_data/1.1.%20April%202026/) and [01_data/1.2. May 7 2026/](01_data/1.2.%20May%207%202026/), with a snapshot diff in [01_data/1.3. comparison/](01_data/1.3.%20comparison/).
- **Population covariates** — pulled from the Destatis `regio` GENESIS API via [restatis](https://cran.r-project.org/package=restatis) in [03_covariates/03_API_load.qmd](03_covariates/03_API_load.qmd) and stored under [03_covariates/03_01_population/](03_covariates/03_01_population/). Used to express counts per 100k inhabitants.
- **Spatial maps** — federal-state / district / municipality / postal-code polygons under [6. Maps/6.1. Dataset/](6.%20Maps/6.1.%20Dataset/), produced by [6. Maps/1. load maps.qmd](6.%20Maps/1.%20load%20maps.qmd) and [6. Maps/2. generate the maps.qmd](6.%20Maps/2.%20generate%20the%20maps.qmd).

## Key classification rule: balcony vs. non-balcony PV

Plug-in solar systems (`TypeOfSolarSystem == 2961`) are split into **Balcony** vs **Non-Balcony** using the **2024-05-16** German reform date:

- Before 2024-05-16: balcony ⇔ `AssignedActivePowerInverter ≤ 0.6 kW`
- From 2024-05-16: balcony ⇔ `AssignedActivePowerInverter ≤ 0.8 kW` AND `GrossCapacity ≤ 2.0 kW`

All other `TypeOfSolarSystem` values are kept under their original label, but downstream analyses collapse everything that is not "Balcony PVs" into a single "Non-balcony PVs" group.

## Iran war window

The Iran-war analyses use:

- `sample_start   = 2026-01-01`
- `iran_war_start = 2026-02-28`

Observations earlier than `sample_start` are discarded in the municipality-level pipelines that feed the Shiny apps.

## Repository layout

```
01_data/         raw MaStR snapshots (April 2026, May 7 2026) + comparison
02_report/       written reports / inputs for drafts
03_covariates/   population data and API loaders
4. datasets/     processed parquet datasets by geographic level
  4.1. all germany/
  4.2. federal state/
5. analysis/     analyses keyed by question
  5.1. Iran war dynamics
  5.2. Iran war and russian war comparison
  5.4. Input claude
6. Maps/         spatial maps (load + generate) and the spatial parquet dataset
7. Analysis/     additional analyses (dynamics, previous years, event-study plot)
8. shiny app/    interactive Shiny apps for exploring municipality- and state-level series
ignore/          large local-only assets (gitignored)
```

Folder names use the convention **`<number>. <name>`** (numeric prefix, dot, space). Paths with spaces must be quoted in the shell.

## Pipeline (per geographic level)

The processing pipeline is the same at every geographic level. Inputs are the MaStR parquet and the population table; outputs are per-frequency aggregated parquet files used by reports, maps, and the Shiny apps.

1. Open the MaStR parquet with `arrow::open_dataset()`.
2. Rename ~70 columns from German to English (explicit mapping).
3. Coerce types (XML parsing yields all-character columns).
4. Join lookup tables (`TypeOfSolarSystem`, `Country`, `FederalState`) and the district-code map.
5. Derive `solar_category` using the 2024-05-16 reform rule, then collapse to `Balcony PVs` / `Non-balcony PVs`.
6. Filter to Germany.
7. Floor `RegistrationDate` and `CommissioningDate` to day / week / month / quarter / year.
8. Zero-pad `MunicipalityCode` to 8 characters.
9. Aggregate by `(geo, solar_category, date)` and fill missing date slots with `tidyr::complete()`; compute running cumulative counts.
10. Join `population` and compute `n_per100k` and `n_cumulative_per100k`.
11. Write one parquet per `(geo_level × frequency)` for downstream apps.

## Shiny apps

[8. shiny app/8.1. shiny apps/](8.%20shiny%20app/8.1.%20shiny%20apps/) hosts interactive apps:

- `1/` — federal-state level.
- `2/` — municipality level, with population-adjusted series and a typeahead picker.

Each app folder contains a `1. dataset.qmd` (builds and saves the parquet) and a `2. shiny app.qmd` (loads the parquet and serves the UI).

## R packages

No `renv` / `DESCRIPTION` is tracked; install as needed. Core packages used across notebooks: `arrow`, `sfarrow`, `sf`, `dplyr`, `tibble`, `tidyr`, `lubridate`, `stringr`, `here`, `restatis`, `shiny`, `data.table`.

## Running a notebook

```bash
quarto render "4. datasets/4.1. all germany/2. report/1. dataset.qmd"
```

```bash
quarto preview "8. shiny app/8.1. shiny apps/2/1. dataset.qmd"
```
