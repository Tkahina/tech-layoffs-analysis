-- Data Cleaning Process for Tech Layoffs Dataset

-- 1. Remove duplicates 
-- 2. Standardize the data 
-- 3. Handle null and blank values 
-- 4. Remove unnecessary columns or rows

-- Create a staging table with the same structure as the original table
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging SELECT * FROM layoffs;
SELECT * FROM layoffs_staging;

--  Identify and remove duplicates
-- Using ROW_NUMBER() to assign unique identifiers to potential duplicates
WITH duplicates_cte AS (
-- CTE to identify duplicate rows
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
                            `date`, stage, country, funds_raised_millions
               ORDER BY company
           ) AS row_num
    FROM layoffs_staging
)
SELECT * 
FROM duplicates_cte
WHERE row_num > 1; -- Preview duplicate rows

-- Create new table for cleaned data
CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--  Insert unique rows into the new table
INSERT INTO layoffs_staging2 (company, location, industry, total_laid_off, percentage_laid_off,
                              `date`, stage, country, funds_raised_millions, row_num)
SELECT company, location, industry, total_laid_off, percentage_laid_off,
       `date`, stage, country, funds_raised_millions,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
                        `date`, stage, country, funds_raised_millions
           ORDER BY company
       ) AS row_num
FROM layoffs_staging;

-- Delete duplicate rows from the new table
SET SQL_SAFE_UPDATES = 0;
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;
SET SQL_SAFE_UPDATES = 1;
--  Verify cleaned data
SELECT * FROM layoffs_staging2;



-- Standardizing data 

-- Trim whitespace from company names
select company, trim(company)
FROM layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;
update layoffs_staging2
set company = trim(company);

-- Standardize 'Crypto' industry entries
select * 
FROM layoffs_staging2
where industry LIKE 'Crypto%';

Update layoffs_staging2
set industry = 'Crypto' 
where industry like 'Crypto%' ;

select distinct industry 
from layoffs_staging2;


select distinct country, trim( trailing '.' from country)  
from layoffs_staging2
order by 1;

-- Standardize country names (remove trailing periods)
Update layoffs_staging2
set country = trim( trailing '.' from country)
where country like 'united states%' ;

select *
from layoffs_staging2;

-- Convert date strings to proper DATE format
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

Update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y') ;

#Check if it works 
select `date`
from layoffs_staging2;

alter table layoffs_staging2
modify column `date` Date;


-- Handling null and blank values

-- Set empty industry values to NULL

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


update layoffs_staging2
set industry = null 
where industry = ''; 



select *
from layoffs_staging2
where industry is null
or industry = '';


select *
from layoffs_staging2
where company = 'Airbnb';



select T1.industry, T2.industry
from layoffs_staging2 T1 
join layoffs_staging2 T2
	on T1.company = T2.company
where (T1.industry is null or T1.industry = '' )
And T2.industry is not null ;

-- Fill NULL industry values with known values for the same company
update layoffs_staging2 T1 
join layoffs_staging2 T2
	on T1.company = T2.company
set T1.industry = T2.industry
where T1.industry is null 
And T2.industry is not null;

select *
from layoffs_staging2;


select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- Remove rows with no layoff data
delete 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2;

-- Remove unnecessary column
ALTER TABLE layoffs_staging2
drop column row_num;





