Select *
From Portfolioproject..CovidDeaths
order by  3,4

Select *
From Portfolioproject..CovidVaccination
order by  3,4

select location,date, total_cases,new_cases,total_deaths,population
from Portfolioproject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total deaths
-- Shows likelihoood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Portfolioproject..CovidDeaths
Where location like '%states%'
order by 1,2

-- Looking at the total Cases vs Population
Select Location, date, Population, total_cases, (total_cases/population)*100 as Percentofpopulation_infected
From Portfolioproject..CovidDeaths
--Where location like '%states%'
order by 1,2

-- Looking at Couuntries with Higherst Infectonrate compared to Population
Select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as Percentofpopulation_infected
From Portfolioproject..CovidDeaths
Group by Location, population
-- Where location like '%states%'
order by Percentofpopulation_infected desc


-- Showing Countries with Highest Death Count per Population
Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From Portfolioproject..CovidDeaths
where continent is not null
Group by Location
order by 2 desc


-- Let's Break things down by continent



-- Showing continents with the highest death count per population
Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From Portfolioproject..CovidDeaths
where continent is not null
Group by continent
order by 2 desc


-- Global Numbers
Select date, sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
From Portfolioproject..CovidDeaths
Where continent is not null
group by date
order by 1,2

-- Looking at Total Population vs Vaccinations.
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Portfolioproject..CovidDeaths dea
Join Portfolioproject..CovidVaccination vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3


-- USE CTE
with PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as
(
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Portfolioproject..CovidDeaths dea
Join Portfolioproject..CovidVaccination vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
)
select *,(RollingPeopleVaccinated/Population) as RollingVacSum
from PopvsVac



-- TEMP TABLE
DROP TABLE if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Portfolioproject..CovidDeaths dea
Join Portfolioproject..CovidVaccination vac
	On dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not null

select *
from #PercentPopulationVaccinated


-- Creating a view to store data for later visualizations
Create view PercentPopulationVaccinated as
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Portfolioproject..CovidDeaths dea
Join Portfolioproject..CovidVaccination vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
-- order by 2,3













































