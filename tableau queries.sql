/*

Queries used for Tableau Project

*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolioproject..covideaths$
where continent is not null 
--Group By date
order by 1,2

-- 2. 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Portfolioproject..covideaths$
Where continent is null 
and location not in ('World', 'European Union', 'International') and location not like '%income'
Group by location
order by TotalDeathCount desc

-- 3.

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Portfolioproject..covideaths$
Where continent is null 
and location not in ('World', 'European Union', 'International') and location like '%income'
Group by location
order by TotalDeathCount desc

-- 4.

Select Location, Population, MAX(convert(int, total_cases)) as HighestInfectionCount,  Max((convert(int, total_cases)/population))*100 as PercentPopulationInfected
From Portfolioproject..covideaths$
Group by Location, Population
order by PercentPopulationInfected desc

-- 5.

select location, population, max(convert(float,total_cases)) as TotalCases, max(CONVERT(float, total_cases) / nullif(CONVERT(float, population), 0)) * 100 AS HighestInfectionrate
from Portfolioproject..covideaths$
where continent is not null
group by location, population
order by HighestInfectionrate desc;

-- 6.

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
from Portfolioproject..covideaths$
Group by Location, Population, date
order by PercentPopulationInfected desc

-- 7.

select date, new_cases
from Portfolioproject..covideaths$ 
where continent is not null
group by date, new_cases
order by date;

-- 8.

select date, new_deaths
from Portfolioproject..covideaths$ 
where continent is not null
group by date, new_deaths
order by date;

-- 9.

select date, sum(convert(float, new_cases)) over (order by date) as CumulativeCases
from Portfolioproject..covideaths$ 
where continent is not null
group by date, new_cases
order by CumulativeCases;

-- 10.

select date, sum(convert(float, new_deaths)) over (order by date) as CumulativeDeathToll
from Portfolioproject..covideaths$ 
where continent is not null
group by date, new_deaths
order by CumulativeDeathToll;


