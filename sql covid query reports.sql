

select * from portfolioproject..coviddeaths$
order by 3, 4


--select * from portfolioproject..covidvaccination$
--order by 3, 4


select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..coviddeaths$
order by 1, 2

--total_cases vs total_deaths
--show likelihooh of dying if you contract the virus in nigeria

select location, date, total_cases, total_deaths, (total_cases/total_deaths)*100 as Deathpercentage
from portfolioproject..coviddeaths$
where location like '%Nigeria%'
order by 1, 2

--total_cases vs population
--show what percentage of population got covid

select location, date, total_cases, population, (total_cases/population)*100 as percentpopulationinfected
from portfolioproject..coviddeaths$
where location like '%Nigeria%'
order by 1, 2


-- looking at countries with the highest infection rate

select location, population, MAX(total_cases) as Highestinfectioncount, MAX((total_cases/population))*100 as percentpopulationinfected
from portfolioproject..coviddeaths$
--where location like '%Nigeria%'
group by location, population
order by percentpopulationinfected desc

--showing countries with the highest death count

select location, MAX(cast(Total_deaths as int)) as Totaldeathcount
from portfolioproject..coviddeaths$
--where location like '%Nigeria%'
where continent is not null
group by location 
order by Totaldeathcount desc

-- BREAKING IT DOWN TO CONTINENT.

select Continent, MAX(cast(Total_deaths as int)) as Totaldeathcount
from portfolioproject..coviddeaths$
--where location like '%Nigeria%'
where continent is not null
group by Continent 
order by Totaldeathcount desc



--Global Deaths

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
 (new_deaths))/SUM(new_cases)*100 as Deathpercentage
 from portfolioproject..coviddeaths$
 where continent is not null
 --Group by date
 order by 1,2


--total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from portfolioproject..coviddeaths$ dea
join portfolioproject..covidvaccination$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,
  dea.date) as Rollingpeoplevaccinated
from portfolioproject..coviddeaths$ dea
join portfolioproject..covidvaccination$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3



---USE CTE

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, Rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,
  dea.date) as Rollingpeoplevaccinated
from portfolioproject..coviddeaths$ dea
join portfolioproject..covidvaccination$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (Rollingpeoplevaccinated/population)*100
from PopvsVac


--TEMP TABLE
DROP Table if exists #percentpopulationvaccinated
Create Table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
Rollingpeoplevaccinated numeric
)

insert into percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,
  dea.date) as Rollingpeoplevaccinated
  --,Rollingpeoplevaccinated/population)*100
from portfolioproject..coviddeaths$ dea
join portfolioproject..covidvaccination$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (Rollingpeoplevaccinated/population)*100
from percentpopulationvaccinated


--creating views for later visualisation

Create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,
  dea.date) as Rollingpeoplevaccinated
from portfolioproject..coviddeaths$ dea
join portfolioproject..covidvaccination$ vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3


SELECT *
from percentpopulationvaccinated













































