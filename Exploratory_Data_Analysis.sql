-- Exploratory Data Analysis

-- Overview of the cleaned dataset
select *
from layoffs_staging2;

-- Maximum layoffs and percentage laid off
select max(total_laid_off) , max(percentage_laid_off)
from layoffs_staging2;

-- Companies with 100% layoffs, ordered by total laid off
select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

-- Total layoffs by company, sorted by highest number
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- Date range of layoffs in the dataset
select min(`date`), max(`date`)
from layoffs_staging2;

-- Total layoffs by industry, sorted by highest number
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- Total layoffs by country, sorted by highest number
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- Total layoffs by company stage, sorted by highest number
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- Monthly trend of layoffs
select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_staging2
group by `Month`
order by 1 desc;

-- Rolling total of layoffs over time
with rolling_total as 
(
select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 desc
)
select  `Month`, total_off
,sum(total_off) over(order by `Month`) as Rolling_Total
from rolling_total;


select company, year(`date`) , sum(total_laid_off)
from layoffs_staging2
group by company ,year(`date`)
order by 3 desc;

-- Top 5 companies with highest layoffs per year
with company_year (company, years, totale_laid_off) as
( 
select company, year(`date`) , sum(total_laid_off)
from layoffs_staging2
group by company ,year(`date`)
), company_year_rank as
(select * , 
dense_rank() over (partition by years order by totale_laid_off desc) as ranking
from company_year
where years is not null)

select * 
from company_year_rank
where ranking <= 5;


