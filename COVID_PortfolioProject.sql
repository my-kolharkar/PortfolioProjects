use PortfolioProject;
select location, date, total_cases, new_cases, (total_deaths/total_cases)*100 as Death_Percentage
from CovidDeaths

--Query 1
--looking at total cases vs total deaths
select location, date, total_cases, new_cases, (total_deaths/total_cases)*100 as Death_Percentage
from CovidDeaths
where location like '%germany%'
order by 1,2

--Query 2
--looking at total  cases vs Population
--shows what percentage of population got covid
select location, date, total_cases, population, (total_cases/population)*100 as percentage_of_population
from CovidDeaths
where location like '%india%'
order by 1,2

--Query 3
--Lookin gat country with highest infection
select Location, population, max(total_cases)as Highest_infection_Count, max((total_cases/population))*100 as percentage_of_population
from CovidDeaths
group by location,population
order by percentage_of_population desc

--Query 4
--Looking at countires with Highest death count
select location, max(cast(total_deaths as int))as Highest_death_count 
from CovidDeaths
where continent is not null
group by location
order by Highest_death_count desc

--Query 5
--Global Numbers
select sum(new_cases)as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from CovidDeaths
where continent is not null
order by 1,2


select date, sum(new_cases)as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from CovidDeaths
where continent is not null
group by date
order by 1,2

--Query 6
-- Looking at Total population VS Total Vaccination

--CTE Method
with popVSvac(continent, location, date, population, new_vaccinations, Rolling_People_Vac)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over( partition by dea.location order by dea.location,dea.date) as Rolling_People_Vac
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select *, (Rolling_People_Vac/population)*100 as percent_of_pop_vac
from popVSvac


--temp table Method
Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccination numeric,
Rolling_People_Vac numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over( partition by dea.location order by dea.location,dea.date) as Rolling_People_Vac
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by2,3

select *, (Rolling_People_Vac/population)*100 as percent_of_pop_vac
from #PercentPopulationVaccinated

--Create View
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over( partition by dea.location order by dea.location,dea.date) as Rolling_People_Vac
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by2,3