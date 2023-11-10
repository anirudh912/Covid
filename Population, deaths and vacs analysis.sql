--Total deaths data
select *
from Portfolioproject..covideaths$
where continent is not null
order by 3,4;

--Worldwide overview of cases and deaths
select location, date, total_cases, new_cases, total_deaths, population
from Portfolioproject..covideaths$
where continent is not null
order by 1,2;

--Overview of cases and deaths for India
select location, date, total_cases, new_cases, total_deaths, population
from Portfolioproject..covideaths$
where continent is not null and location like 'India'
order by 1,2;

--Total cases vs total deaths
select location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from Portfolioproject..covideaths$
where continent is not null
order by 1,2;

--Total cases vs total deaths for India
select location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from Portfolioproject..covideaths$
where location like 'India'
order by 1,2;

--Total cases vs population
select location, date, population, total_cases, (CONVERT(float, total_cases) / nullif(CONVERT(float, population), 0)) * 100 AS Infectionrate
from Portfolioproject..covideaths$
where continent is not null
order by 1,2;

--Cases vs population for India
select location, date, population, total_cases, (CONVERT(float, total_cases) / nullif(CONVERT(float, population),0)) * 100 AS Infectionrate
from Portfolioproject..covideaths$
where location like 'India'
order by 1,2;

--Countries with hightest Infection rate with respect to population
select location, population, max(convert(float,total_cases)) as TotalCases, max(CONVERT(float, total_cases) / nullif(CONVERT(float, population), 0)) * 100 AS HighestInfectionrate
from Portfolioproject..covideaths$
where continent is not null
group by location, population
order by HighestInfectionrate desc;

--Countries with highest deaths with respect to population
select location, population, max(convert(float,total_deaths)) as TotalDeaths
from Portfolioproject..covideaths$
where continent is not null
group by location, population
order by TotalDeaths desc;

--Analyse with respect to continents
select location, population, max(convert(float,total_deaths)) as TotalDeaths
from Portfolioproject..covideaths$
where continent is null and location not like '%income'
group by population, location
order by TotalDeaths desc;

--Analyse with respect to economic state
select location, population, max(convert(float,total_deaths)) as TotalDeaths
from Portfolioproject..covideaths$
where continent is null and location like '%income'
group by population, location
order by TotalDeaths desc;

--Global data on a day to day basis
select date, sum(convert(float,new_cases)) as Globalcases, sum(convert(float,new_deaths)) as Globaldeaths, ((sum(convert(float,new_deaths)) / nullif(sum(convert(float,new_cases)), 0))) * 100 as Globalmortalityrate
from Portfolioproject..covideaths$
where continent is not null 
group by date
order by 1,2;

--Global trend of change in mortality rate
select date, sum(convert(float,total_cases)) as Globaltotalcases, sum(convert(float,total_deaths)) as Globaltotaldeaths, ((sum(convert(float,total_deaths)) / nullif(sum(convert(float,total_cases)), 0))) * 100 as Globalmortalityrate
from Portfolioproject..covideaths$
where continent is not null 
group by date
order by 1,2;

--Total vaccination data
select *
from Portfolioproject..covivacs$
where continent is not null
order by 3,4;

--Total population vs vaccinations
select dea. continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Cumulativepeoplevaccinated
from Portfolioproject..covideaths$ dea
join Portfolioproject..covivacs$ vac 
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3;

--Use CTE
with popvsvac(Continent, Location, Date, Population, New_Vaccinations, CumulativePeopleVaccinated, PercentageVaccinated)
as(
select dea. continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CumulativePeopleVaccinated, (sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) / dea.population) * 100 as PercentageVaccinated
from Portfolioproject..covideaths$ dea
join Portfolioproject..covivacs$ vac 
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
select *
from popvsvac
order by 2,3;

--Creating view for later visualization
create view Percentpoplvac as
with popvsvac(Continent, Location, Date, Population, New_Vaccinations, CumulativePeopleVaccinated, PercentageVaccinated)
as(
select dea. continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CumulativePeopleVaccinated, (sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) / dea.population) * 100 as PercentageVaccinated
from Portfolioproject..covideaths$ dea
join Portfolioproject..covivacs$ vac 
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
select *
from popvsvac
--order by 2,3;