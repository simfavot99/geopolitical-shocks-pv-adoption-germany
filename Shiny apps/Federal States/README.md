# Federal-state PV adoption Shiny app

A Shiny app for exploring how the 2026 Iran war affected solar-PV adoption across Germany's 16 federal states. Data: the German **MaStR** (Marktstammdatenregister) solar-unit registry, split into **balcony** and **non-balcony** plug-in PV systems.

------------------------------------------------------------------------

## 1. Controls

<img src="images/paste-1.png" width="600"/>

At the top you have the controls. Here is what each one does:

- **PV type** — Balcony or Non-balcony plug-in PV systems.
- **Outcome** — show the chart series as raw counts or per 100,000 inhabitants.
- **MA window — daily chart** — moving-average window (in days) for the top-right chart.
- **MA window — yearly chart** — moving-average window for the bottom-right chart.
- **Map outcome** — what the map colors show:
  - *Cumulative registrations* — total adoption over the whole sample.
  - *Post/Pre ratio (±30d around war start)* — within-2026 acceleration. Values \> 1 mean adoption sped up after 28 Feb 2026.
  - *YoY same-window ratio (2026 / 2025)* — same 30-day calendar window vs. 2025. Controls for seasonal patterns.
- **Date range — daily chart** — limit the top chart's x-axis to a chosen period.

------------------------------------------------------------------------

## 2. Map

<img src="images/paste-2.png" width="600"/>

A choropleth map of the 16 federal states, colored by the **Map outcome** you selected. Click any state to update the right-side charts. The map opens with **Baden-Württemberg** selected by default.

Hover a state to see its exact value. Empty values appear in grey ("no data").

------------------------------------------------------------------------

## 3. Plots

<img src="images/paste-3.png" width="600"/>

Two stacked charts for the selected state:

- **Top — daily registrations** Grey bars are daily registrations; the red line is the moving average (window controlled by the slider). The two black dashed vertical lines mark the **Iran-war start** (28 Feb 2026) and the **ceasefire** (8 Apr 2026).
- **Bottom — moving-average daily registrations per year** One line per year, Jan – May 7 (capped at May 7 because that's where 2026 ends). 2026 is drawn in **red**; other years use a viridis palette so you can still tell them apart.

Y-axis scales are held fixed across federal states (within the current PV-type / outcome choice), so clicking a different state gives a directly comparable view.

------------------------------------------------------------------------

## How to run it

1.  Open `2. shiny app.qmd` in RStudio.
2.  Make sure these two files sit next to it in the same folder:
    - `federalState.parquet` — federal-state polygon boundaries.
    - `state_day.parquet` — daily registrations per state (produced by `1. dataset.qmd`).
3.  Click **Run Document** (or run the code chunk directly).

## Data sources

- **Registrations** — German MaStR (Marktstammdatenregister) solar-unit registry.
- **Federal-state population** — Destatis GENESIS table `12411-0010` (reference date 31 Dec).
- **Federal-state boundaries** — Eurostat NUTS-1 polygons for Germany.

The full data-building pipeline lives in `1. dataset.qmd`.