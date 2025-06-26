-- exploratory data analysis project

select * from layoffs_staging2;


select max(total_laid_off) from layoffs_staging2;
select max(percentage_laid_off) from layoffs_staging2;
select * from layoffs_staging2 
where percentage_laid_off=1;

select * from layoffs_staging2 
where percentage_laid_off=1
order by total_laid_off desc;

select * from layoffs_staging2 
where percentage_laid_off=1
order by funds_raised_millions desc;

select company,sum(total_laid_off)
from layoffs_staging2
group by company;

select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


select min(`date`), max(`date`) 
from layoffs_staging2;

select industry,sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country,sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select year( `date`) ,sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select stage ,sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select substring(`date`,1,7) as `new_date` ,sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `new_date`
order by  1 asc;

with rolling_total_cte as
(
select substring(`date`,1,7) as `new_date` ,sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `new_date`
order by  1 asc

)
select `new_date`,total_off, sum(total_off) over(order by `new_date`)
from rolling_total_cte;


select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`) 
order by company asc;

with company_years as
(

select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)

)

select * from company_years;



with company_years (company,years,total_laid_off_sum)  as
(

select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)

)

select *, dense_rank() over(partition by years order by total_laid_off_sum desc ) as ranking
from company_years
where years is not null
order by ranking asc;






with company_years (company,years,total_laid_off_sum)  as
(

select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)

)

,

company_year_rank as
(

select *, dense_rank() over(partition by years order by total_laid_off_sum desc ) as ranking
from company_years
where years is not null

)
select * from company_year_rank
where ranking<=5;

