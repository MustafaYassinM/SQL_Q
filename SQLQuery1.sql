Select * 
From [Portfolio Project]..CovidDeaths
where continent is not null
Order By 3,4

Select * 
From [Portfolio Project]..CovidVaccination
Order By 3,4

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentge
From [Portfolio Project]..CovidDeaths
Where location like '%states%'
Order By 1,2 

Select Location,date,total_cases,population,(total_cases/population)*100 as DeathPercentge
From [Portfolio Project]..CovidDeaths
Order By 1,2 

Select Location,date,total_cases,population,(total_cases/population)*100 as PercentOfPopulationInfected
From [Portfolio Project]..CovidDeaths
Order By 1,2


Select Location,population, MAX(total_cases) AS highestInfectionCount,MAX(total_cases/population)*100 as PercentOfPopulationInfected
From [Portfolio Project]..CovidDeaths
Group By location, population
Order By PercentOfPopulationInfected desc


Select Location,MAX(cast(total_deaths as int)) AS TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is not null
Group By location
Order By TotalDeathCount desc


Select location,MAX(cast(total_deaths as int)) AS TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is null
Group By location
Order By TotalDeathCount desc

--showing the continent with the highest death count per population

Select continent,MAX(cast(total_deaths as int)) AS TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is not null
Group By continent
Order By TotalDeathCount desc


-- global numbers

Select date,SUM(new_cases)As total_cases,Sum(cast(total_deaths as int)) As total_death ,Sum(cast(total_deaths as int))/SUM(New_Cases) *100 as DeathPercentge
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
where continent is not null
Group By date
Order By 1,2

--Total cases And Deaths in global

Select SUM( new_cases) as total_cases, SUM(cast(new_deaths as int)) As total_deaths, SUM(cast(new_deaths as int))/SUM( new_cases) *100 as DeathPercentage --,total_deaths As total_deaths
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
where continent is not null
--Group By date
Order By 1,2


--looking at total population vs Vaccination
with PopvsVac (continent, location,date,population,new_vaccinations,PeopleVaccinated) as
(
   select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
   SUM(CONVERT(INT,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
   as PeopleVaccinated
   From [Portfolio Project]..CovidDeaths dea
   Join [Portfolio Project]..CovidVaccination vac
        on dea.location= vac.location
	    and dea.date = vac.date
        where dea.continent is not null
)

Select * , (PeopleVaccinated/population)*100
from PopvsVac




--create a a temp table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations nvarchar(255) ,  
PeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as PeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccination vac
     on dea.location= vac.location
	 and dea.date = vac.date
where dea.continent is not null


Select * , (PeopleVaccinated/population)*100
from #PercentPopulationVaccinated






SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 

