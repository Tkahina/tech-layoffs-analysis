# 📊 Tech Layoffs Data Analysis


## 🔍 Overview
This project analyzes tech industry layoffs using MySQL, focusing on data cleaning, standardization, and exploratory data analysis (EDA). It processes a dataset of 2,362 entries to uncover insights into layoff trends across companies, industries, and countries.

## 🛠️ Data Cleaning Process
1. Remove duplicates
2. Standardize the data
3. Handle null and blank values
4. Remove unnecessary columns or rows

Key steps include:
- Creating staging tables
- Using ROW_NUMBER() for deduplication
- Trimming and standardizing text fields
- Converting date strings to proper DATE format
- Handling NULL values in critical fields

## 📈 Exploratory Data Analysis
Key analyses include:
- Maximum layoffs and percentage laid off
- Companies with highest total layoffs
- Industry and country-wise layoff totals
- Monthly and yearly layoff trends
- Rolling total of layoffs over time
- Top 5 companies with highest layoffs per year

Techniques used:
- Aggregate functions (SUM, MAX)
- Date and string functions
- Window functions for rolling totals and rankings
- Common Table Expressions (CTEs) for complex queries

## 🔗 Data Source
[Tech Layoffs Dataset](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv)
- Total Entries: 2,362
- Source: GitHub

## 🚀 Usage
1. Import dataset to MySQL
2. Run data cleaning script
3. Execute EDA queries


## 📁 Repository Structure
├── layoffs.csv
├── Data_Cleaning.sql
├── Exploratory_Data_Analysis.sql
├── README.md

## 🔧 Tools
- MySQL Workbench 8.0: Used for SQL development, data cleaning, and exploratory data analysis
