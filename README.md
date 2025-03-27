# Fundamental Analysis of A-Share Firms and Valuation Strategy

This project uses firm-level data from the CSMAR database to analyze financial indicators of A-share listed companies in China and build a basic valuation-based investment strategy. All data processing and analysis are done using STATA.

## Project Goals

- Clean and merge accounting and market data for A-share firms
- Construct valuation indicators such as P/B, P/E, ROE, and R&D investment
- Use panel data regression to examine the relationship between fundamentals and future returns
- Build and backtest grouped portfolios based on valuation metrics

## Tools and Data

- STATA for all data processing, regression, and portfolio analysis
- Raw data is from the CSMAR (China Stock Market & Accounting Research) database

## Folder Structure

- `raw data/` – Original datasets from CSMAR
- `processed data/` – Cleaned and transformed variables
- `scripts/` – Main `.do` file for STATA analysis
- `output/` – Regression results and generated plots

## Method Summary

1. Filter the sample to include only common stocks in A-share markets
2. Calculate firm-level valuation indicators
3. Sort firms into portfolios based on valuation criteria
4. Backtest portfolio returns and compare performance
5. Use panel regression to analyze statistical relationships

## Notes

This project was originally completed as part of a course assignment. It is now organized and uploaded to GitHub for documentation purposes.

Due to data license restrictions, raw data files are not publicly shared.
