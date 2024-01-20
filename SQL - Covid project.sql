
--SELECT *
--FROM CovidDeaths$
--WHERE Continent is not null AND population is not null
--ORDER BY 3,4;

--SELECT *
--FROM CovidVaccinations$
--WHERE Continent is not null AND population is not null
--ORDER BY 3,4;


-- Select Data that we are going to be using

USE PortfolioProject;

SELECT
Location,
Date,
Total_cases,
New_cases,
Total_deaths,
population
FROM CovidDeaths$
ORDER BY 1,2;

-- Total cases vs Total deaths

SELECT
Location,
Date,
Total_cases,
Total_deaths,
(total_deaths / total_cases)*100 AS Death_Precentage 
FROM CovidDeaths$
ORDER BY 1,2;


-- Shows likelihood of dying of you contract covid in your country

SELECT
Location,
Date,
Total_cases,
Total_deaths,
(total_deaths / total_cases)*100 AS Death_Precentage 
FROM CovidDeaths$
WHERE location like '%states%' AND Continent is not null AND population is not null
ORDER BY 1,2;

-- Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT
Location,
Date,
Population,
Total_cases,
(Total_cases / population)*100 AS Cases_To_Population
FROM CovidDeaths$
WHERE location like '%states%' AND Continent is not null AND population is not null
ORDER BY 1,2;

-- Looking at countries with highest infection rate compared to population

SELECT
Location,
Population,
MAX(Total_cases) AS Highest_Infection_Count,
MAX((Total_cases / population)*100) AS Percent_Population_Infected
FROM CovidDeaths$
WHERE Continent is not null AND population is not null
GROUP BY Location,Population
ORDER BY Percent_Population_Infected DESC

-- Showing the highest death count per population

SELECT
Location,
Population,
MAX(cast(total_deaths as int)) AS Total_Death_Count,
MAX((Total_deaths / population)*100) AS Percent_Population_Died
FROM CovidDeaths$
WHERE Continent is not null AND population is not null
GROUP BY Location,Population
ORDER BY 3 DESC

-- LET'S BREAK THINGS DOWN BY CONTINENT
-- Showing the continents with highest death count per population

SELECT
Location,
MAX(cast(total_deaths as int)) AS Total_Death_Count,
MAX((Total_deaths / population)*100) AS Percent_Population_Died
FROM CovidDeaths$
WHERE Continent is null AND population is not null
GROUP BY location
ORDER BY 2 DESC

-- GLOBAL NUMBERS

SELECT
Date,
SUM(new_cases) as total_cases,
SUM(cast(new_deaths as int)) as total_deaths,
(SUM(cast(new_deaths as int)) / SUM(new_cases))*100 AS Death_Precentage 
FROM CovidDeaths$
WHERE Continent is not null AND population is not null
GROUP BY date
ORDER BY 1,2;



-- Joining CovidDeaths and CovidVaccination tables

SELECT *
FROM CovidDeaths$ dea
INNER JOIN CovidVaccinations$ vac
	ON dea.location = vac.location AND
	dea.date = vac.date
WHERE Continent is not null AND population is not null;


-- Looking at Total Population vs Vaccinations

SELECT
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location ,dea.date) as rolling_count_vaccinated,
FROM CovidDeaths$ dea
INNER JOIN CovidVaccinations$ vac
	ON dea.location = vac.location AND
	dea.date = vac.date
WHERE dea.continent is not null AND dea.population is not null
ORDER BY 2,3

-- CONVERT(int, vac.new_vaccinations)
-- Play with Partition by and CTEs , need some practice here


-- Using CTE **  Common Table Expression 

With PopVsVac(
Continent,
Location,
Date,
Population,
New_Vaccinations,
rolling_count_vaccinated)
AS
(
SELECT
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location ,dea.date) as rolling_count_vaccinated
FROM CovidDeaths$ dea
INNER JOIN CovidVaccinations$ vac
	ON dea.location = vac.location AND
	dea.date = vac.date
WHERE dea.continent is not null AND dea.population is not null
-- ORDER BY 2,3
)
SELECT
*,
rolling_count_vaccinated / Population *100 as percentage_vaccinated 
FROM PopVsVac

-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
rolling_count_vaccinated numeric
)


INSERT INTO #PercentPopulationVaccinated

SELECT
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location ,dea.date) as rolling_count_vaccinated
FROM CovidDeaths$ dea
INNER JOIN CovidVaccinations$ vac
	ON dea.location = vac.location AND
	dea.date = vac.date
WHERE dea.continent is not null AND dea.population is not null;

SELECT
*,
rolling_count_vaccinated / Population *100 as percentage_vaccinated 
FROM #PercentPopulationVaccinated;

-- Create a view to store data for future data vizualization

CREATE VIEW PercentPopulationVaccinated AS
SELECT
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location ,dea.date) as rolling_count_vaccinated
FROM CovidDeaths$ dea
INNER JOIN CovidVaccinations$ vac
	ON dea.location = vac.location AND
	dea.date = vac.date
WHERE dea.continent is not null AND dea.population is not null;

SELECT *
FROM PercentPopulationVaccinated;
