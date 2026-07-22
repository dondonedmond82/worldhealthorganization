# Health Campaign Data Analysis

A data analyst notebook that explores health campaign scheduling, duration, and category mix using the `Health_Camp_Detail` dataset.

## Overview

This project follows a standard data analyst workflow — **load → inspect → clean → transform → explore → visualize → summarize** — to understand patterns in how health campaigns are scheduled and categorized over time.

## Workflow

The notebook (`health_analysis.ipynb`) is organized into the following stages:

1. **Import Libraries** — pandas, numpy, matplotlib, seaborn, plotly
2. **Load the Data** — read the raw CSV into a DataFrame
3. **Initial Data Understanding** — shape, dtypes, missing values, duplicates
4. **Data Cleaning** — parse dates, drop unparseable/duplicate rows, flag invalid date ranges
5. **Feature Engineering** — derive `Duration_Days`, `Year`, `Month`, `YearMonth`
6. **Descriptive Statistics / KPIs** — campaign counts, average/median/min/max duration, date range
7. **Univariate Analysis** — distribution of campaigns across `Category1` / `Category2`
8. **Time-Based Analysis** — campaign trend over time and monthly seasonality heatmap
9. **Key Insights & Summary** — takeaways from the analysis
10. **(Optional) Export Cleaned Data** — save the cleaned, feature-engineered dataset

## Dataset

`data/Health_Camp_Detail.csv` contains the following columns:

| Column | Description |
|---|---|
| `Health_Camp_ID` | Unique identifier for the health camp |
| `Camp_Start_Date` | Start date of the campaign |
| `Camp_End_Date` | End date of the campaign |
| `Category1` | Primary campaign category |
| `Category2` | Secondary campaign category |
| `Category3` | Tertiary campaign category |

## Getting Started

### Prerequisites

- Python 3.9+
- Jupyter Notebook / JupyterLab

### Installation

```bash
git clone https://github.com/dondonedmond82/worldhealthorganization.git
cd worldhealthorganization
pip install -r requirements.txt
```

### Usage

Launch the notebook:

```bash
jupyter notebook health_analysis.ipynb
```

Run the cells in order from top to bottom. The notebook reads its input from `./data/Health_Camp_Detail.csv`, so make sure the `data/` folder is in place relative to the notebook (this is already the case in this repo).

Optionally, the last section of the notebook exports a cleaned version of the dataset to `./data/Health_Camp_Detail_cleaned.csv` for reuse in downstream analysis or dashboards.

## Project Structure

```
worldhealthorganization/
├── health_analysis.ipynb   # Main analysis notebook
├── data/
│   └── Health_Camp_Detail.csv
├── requirements.txt
└── README.md
```

## License

This project is provided as-is for data analysis and educational purposes.
