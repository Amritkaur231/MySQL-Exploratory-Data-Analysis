 -- EXPLORATORY DATA ANALYSIS
 
SELECT 
    *
FROM
    layoffs_staging2;
 
SELECT 
    MAX(total_laid_off)
FROM
    layoffs_staging2;
 
SELECT 
    MAX(total_laid_off), MAX(percentage_laid_off)
FROM
    layoffs_staging2;
 
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    percentage_laid_off = 1
ORDER BY total_laid_off DESC;
 
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
 
SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
 
 
SELECT 
    MIN(date), MAX(date)
FROM
    layoffs_staging2;


SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
 
SELECT 
    industry, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
 
SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;
 

SELECT 
    YEAR(date), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 2 DESC;

SELECT 
    company, AVG(percentage_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
 
SELECT 
    SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off)
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY month
ORDER BY 1 ASC;
 
 with rolling_total as 
 (
 select substring(`date`,1,7) as month, sum(total_laid_off) as total_off
 from layoffs_staging2
 where substring(`date`,1,7) is not null
 group by `month` 
 order by 1 asc
 ) select `month`, sum(total_off) over(order by `month`) as rolling_total
  from rolling_total;
  
  
SELECT 
    company, YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company , YEAR(`date`)
ORDER BY 3 DESC;
  
 
  
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;
 
	