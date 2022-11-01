use PortfolioProject;

select *from coviddeaths
order by location,date;

Select Location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
order by Location,date;

--Looking at Total cases vs Total Deaths
--Shows likelihood of dying if you contract covid in India
Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location='india'
order by date;

--Shows what percentage of population affected with covid
Select Location,date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
from coviddeaths
order by location, date;

--Countries with Highest Infection Rate compared to Population
Select Location,population,Max(total_cases)as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
from coviddeaths
Group by Location,population
order by PercentPopulationInfected desc;

--Countries with Highest Death Count
Select Location,Max(cast(total_deaths as int))as TotalDeathCount
from coviddeaths
where continent is not null
group by location
order by TotalDeathCount desc;

--Continent wise DeathCountBreakdown
Select continent,Max(cast(total_deaths as int))as TotalDeathCount
from coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

--Global DeathPercentage
Select max(total_cases) as total_cases, max(cast(total_deaths as int)) as total_deaths, max(cast(new_deaths as int))/max(New_Cases)*100 as DeathPercentage
From coviddeaths
where continent is not null;

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;

Select *, (RollingPeopleVaccinated/Population)*100 as PercentVaccinated
From #PercentPopulationVaccinated


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.coviddeaths dea
Join PortfolioProject.dbo.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;






















