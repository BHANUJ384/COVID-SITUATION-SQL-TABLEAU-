SELECT * 
FROM [COVID DEATH PROJECT]..covidDeaths$
where location like 'european%'
order by 3,4


--SELECT * 
--FROM [COVID DEATH PROJECT]..covidVaccinations$
--order by 3,4


select location,date,total_cases,new_cases,total_deaths,population
from [COVID DEATH PROJECT]..covidDeaths$
where continent is not null
order by 1,2


select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [COVID DEATH PROJECT]..covidDeaths$
where continent is not null
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [COVID DEATH PROJECT]..covidDeaths$
--where location like 'india'
where continent is not null
order by 1,2


select location,date,total_cases,total_deaths,population,
(total_deaths/population)*100 as PercentagePopolationInfected
from [COVID DEATH PROJECT]..covidDeaths$
---where location like 'india'
where continent is not null
order by 1,2

--table 3
select location,population,max(total_cases) as HighestInfectionCount,
max((total_cases/population))*100 as PercentagePopulationInfected
from [COVID DEATH PROJECT]..covidDeaths$
---where location like 'india'
group by location,population
order by PercentagePopulationInfected desc

--TABLE 4

select location,population,date,max(total_cases) as HighestInfectionCount,
max((total_cases/population))*100 as PercentagePopulationInfected
from [COVID DEATH PROJECT]..covidDeaths$
---where location like 'india'
group by location,population, date
order by PercentagePopulationInfected desc


--table 1
select location,max(cast(total_deaths as int)) as TotalDeathCount
from [COVID DEATH PROJECT]..covidDeaths$
---where location like 'india'
where continent is not null
group by location
order by TotalDeathCount desc

--table 2
select location,SUM(cast(total_deaths as int)) as TotalDeathCount
from [COVID DEATH PROJECT]..covidDeaths$
---where location like 'india'
where continent is null
AND location not in ('World','European Union','International')
group by location
order by TotalDeathCount desc

select continent,max(cast(total_deaths as int)) as TotalDeathCount
from [COVID DEATH PROJECT]..covidDeaths$
---where location like 'india'
where continent is not null
group by continent
order by TotalDeathCount desc


select date,sum(new_cases)--total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [COVID DEATH PROJECT]..covidDeaths$
--where location like 'india'
where continent is not null
group by date
order by 1,2

select sum(new_cases)as TotalCase,sum(cast(new_deaths as int)) as TotalDeaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [COVID DEATH PROJECT]..covidDeaths$
where continent is not null
order by 1,2

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from [COVID DEATH PROJECT]..covidDeaths$ as dea
join [COVID DEATH PROJECT]..covidVaccinations$ as vac
    on dea.location=vac.location and dea.date=vac.date
	--where dea.location like 'india'
	where dea.continent is not null
	order by 2,3


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated,
------(RollingPeopleVaccinated/population)*100
from [COVID DEATH PROJECT]..covidDeaths$ as dea
join [COVID DEATH PROJECT]..covidVaccinations$ as vac
    on dea.location=vac.location and dea.date=vac.date
	--where dea.location like 'india'
	where dea.continent is not null
	order by 2,3

--USE CTE

with popvsvac(continent,location,date,population,new_vaccination,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
------(RollingPeopleVaccinated/population)*100
from [COVID DEATH PROJECT]..covidDeaths$ as dea
join [COVID DEATH PROJECT]..covidVaccinations$ as vac
    on dea.location=vac.location and dea.date=vac.date
	--where dea.location like 'india'
	where dea.continent is not null
)
select *,(RollingPeopleVaccinated/population)*100
from popvsvac

---TEMP TABLE

drop table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated

------(RollingPeopleVaccinated/population)*100
from [COVID DEATH PROJECT]..covidDeaths$ as dea
join [COVID DEATH PROJECT]..covidVaccinations$ as vac
    on dea.location=vac.location and dea.date=vac.date
	--where dea.location like 'india'
	where dea.continent is not null

select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


-----create a view for later visualization


create view PercentPopulationVaccinated as

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated

------(RollingPeopleVaccinated/population)*100
from [COVID DEATH PROJECT]..covidDeaths$ as dea
join [COVID DEATH PROJECT]..covidVaccinations$ as vac
    on dea.location=vac.location and dea.date=vac.date
	--where dea.location like 'india'
	where dea.continent is not null

select *
from PercentPopulationVaccinated






