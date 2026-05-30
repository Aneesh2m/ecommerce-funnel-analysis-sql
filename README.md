# E-commerce Funnel Analysis using SQL

## Project Overview

This project analyzes user behavior across an e-commerce conversion funnel using SQL.

The analysis tracks how users move through different stages:

* Product View
* Add to Cart
* Checkout
* Payment
* Purchase

The goal was to identify conversion drop-offs, evaluate marketing channel performance, and generate business insights.

---

## Tools Used

* SQL
* Common Table Expressions (CTEs)
* Aggregate Functions
* CASE WHEN Statements

---

## Key Analyses Performed

### 1. Funnel Stage Analysis

Calculated the number of unique users at each funnel stage.

### 2. Conversion Rate Analysis

Measured conversion efficiency between:

* View → Cart
* Cart → Checkout
* Checkout → Payment
* Payment → Purchase

### 3. Marketing Channel Analysis

Compared traffic sources such as:

* Social Media
* Email
* Organic
* Paid Ads

### 4. Time-to-Conversion Analysis

Measured average time taken for users to move from viewing a product to completing a purchase.

### 5. Revenue Funnel Analysis

Calculated:

* Average Order Value (AOV)
* Revenue per Buyer
* Revenue per Visitor

---

## Key Business Insights

* Checkout and payment stages showed strong conversion performance.
* Social media generated high traffic but lower purchase conversion.
* Email marketing delivered stronger conversion efficiency.
* Revenue metrics highlighted the importance of comparing CAC with AOV.

---

## Files Included
* `Dashboard.png` → Dashboard
* `funnel_analysis.sql` → SQL queries used for analysis
* `README.md` → Project documentation

---

## Future Improvements

* Create an interactive dashboard using Excel or Power BI
* Add visualization for funnel conversion trends
* Perform cohort and retention analysis
