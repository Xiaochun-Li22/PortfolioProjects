--create table CovidDeaths
CREATE TABLE CovidDeaths (
    iso_code VARCHAR(255),
    continent VARCHAR(255),
    location VARCHAR(255),
    date VARCHAR(255),
    total_cases FLOAT,
    new_cases FLOAT,
    new_cases_smoothed FLOAT,
    total_deaths FLOAT,
    new_deaths FLOAT,
    new_deaths_smoothed FLOAT,
    total_cases_per_million FLOAT,
    new_cases_per_million FLOAT,
    new_cases_smoothed_per_million FLOAT,
    total_deaths_per_million FLOAT,
    new_deaths_per_million FLOAT,
    new_deaths_smoothed_per_million FLOAT,
    reproduction_rate FLOAT,
    icu_patients FLOAT,
    icu_patients_per_million FLOAT,
    hosp_patients FLOAT,
    hosp_patients_per_million FLOAT,
    weekly_icu_admissions FLOAT,
    weekly_icu_admissions_per_million FLOAT,
    weekly_hosp_admissions FLOAT,
    weekly_hosp_admissions_per_million FLOAT,
    new_tests FLOAT,
    total_tests FLOAT,
    total_tests_per_thousand FLOAT,
    new_tests_per_thousand FLOAT,
    new_tests_smoothed FLOAT,
    new_tests_smoothed_per_thousand FLOAT,
    positive_rate FLOAT,
    tests_per_case FLOAT,
    tests_units VARCHAR(255),
    total_vaccinations FLOAT,
    people_vaccinated FLOAT,
    people_fully_vaccinated FLOAT,
    new_vaccinations FLOAT,
    new_vaccinations_smoothed FLOAT,
    total_vaccinations_per_hundred FLOAT,
    people_vaccinated_per_hundred FLOAT,
    people_fully_vaccinated_per_hundred FLOAT,
    new_vaccinations_smoothed_per_million FLOAT,
    stringency_index FLOAT,
    population FLOAT,
    population_density FLOAT,
    median_age FLOAT,
    aged_65_older FLOAT,
    aged_70_older FLOAT,
    gdp_per_capita FLOAT,
    extreme_poverty FLOAT,
    cardiovasc_death_rate FLOAT,
    diabetes_prevalence FLOAT,
    female_smokers FLOAT,
    male_smokers FLOAT,
    handwashing_facilities FLOAT,
    hospital_beds_per_thousand FLOAT,
    life_expectancy FLOAT,
    human_development_index FLOAT
);



--check table
select *
from coviddeaths
where continent is not null
order by 3,4;



--create table CovidVaccinations
CREATE TABLE covidvaccinations (
    iso_code VARCHAR(255),
    continent VARCHAR(255),
    location VARCHAR(255),
    date VARCHAR(255),
    new_tests FLOAT,
    total_tests FLOAT,
    total_tests_per_thousand FLOAT,
    new_tests_per_thousand FLOAT,
    new_tests_smoothed FLOAT,
    new_tests_smoothed_per_thousand FLOAT,
    positive_rate FLOAT,
    tests_per_case FLOAT,
    tests_units VARCHAR(255),
    total_vaccinations FLOAT,
    people_vaccinated FLOAT,
    people_fully_vaccinated FLOAT,
    new_vaccinations FLOAT,
    new_vaccinations_smoothed FLOAT,
    total_vaccinations_per_hundred FLOAT,
    people_vaccinated_per_hundred FLOAT,
    people_fully_vaccinated_per_hundred FLOAT,
    new_vaccinations_smoothed_per_million FLOAT,
    stringency_index FLOAT,
    population_density FLOAT,
    median_age FLOAT,
    aged_65_older FLOAT,
    aged_70_older FLOAT,
    gdp_per_capita FLOAT,
    extreme_poverty FLOAT,
    cardiovasc_death_rate FLOAT,
    diabetes_prevalence FLOAT,
    female_smokers FLOAT,
    male_smokers FLOAT,
    handwashing_facilities FLOAT,
    hospital_beds_per_thousand FLOAT,
    life_expectancy FLOAT,
    human_development_index FLOAT
);



--check table 
select *
from covidvaccinations
order by 3,4; 



-- Select Data that we are going to be starting with
select location,date,total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1,2



-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
select location,date,total_cases, new_cases, total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from coviddeaths
where location = 'China'
and continent is not null
order by 1,2



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
select location,date,total_cases,(total_cases/population)*100 as percentagepopulationinfected
from coviddeaths
where location = 'China'
and continent is not null
order by 1,2;



-- Countries with Highest Infection Rate compared to Population
select Location, Population, max(total_cases) as highestinfectcount, max((total_cases/population))*100 as percentagepopulationinfected
from coviddeaths
where total_cases is not null and population is not null
group by Location, Population
order by percentagepopulationinfected desc;



-- Countries with Highest Death Count per Population
select Location, max(cast(total_deaths as int)) as totaldeathcount
from coviddeaths
where continent is not null and total_deaths is not null
group by Location
order by totaldeathcount desc;



-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population
select continent, max(cast(total_deaths as int)) as totaldeathcount
from coviddeaths
where continent is not null and total_deaths is not null
group by continent
order by totaldeathcount desc;



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
	on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3



-- Using CTE to perform Calculation on Partition By in previous query
with popvsvac as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
	on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 as percentagevac
from popvsvac



-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
	on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
