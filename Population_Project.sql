


Delete from projectP..Data1
where District is NULL

Delete from projectP..Data1
where Growth is NULL

select * from projectP..Data1

-- Find the Total No.of Rows in Column
Select Count(*) from projectP..Data1
Select Count(*) from projectP..Data2

Select * from Population_project..Data1  -- Way to write query without dbo

-- DataSet for Uttar Pradesh, Uttarakhand 

Select * from projectP..Data1 where State in ('Uttar Pradesh' ,'Uttarakhand')

select * from projectP..Data1 where state in ('Jharkhand' ,'Bihar')


-- Population of India

Select sum(Population) from projectP..Data2


-- Average growth of India

Select avg(Growth)*100 as avg_growth from projectP..Data1

-- Average Growth % for States in India

Select State, avg(Growth)*100 as avg_growth from projectP..Data1
group by State 
order by avg_growth Desc


--  Average Sex ratio for India

select avg(Sex_Ratio) from projectP..Data1

-- State wise Average Sex Ratio 

select state, round(avg(Sex_Ratio), 0) as avg_sexr from projectP..Data1
group by State
order by avg_sexr desc


-- Average Literacy rate of India

Select round(avg(Literacy), 2) as Literracy_rate from projectP..Data1

-- Statewise Average Literacy rate 

Select State, round(avg(Literacy), 2) as Literracy_rate from projectP..Data1
group by State
order by Literracy_rate desc


-- find the Staes which have above 90 Literacy Rate
Select State, round(avg(Literacy), 2) as Literracy_rate from projectP..Data1
group by State
Having round(avg(Literacy), 2) > 90
order by Literracy_rate desc

-- top 3 States Having Highest avg Growth rate

Select Top 3 State, avg(Growth)*100 as avg_growth from projectP..Data1
group by State 
order by avg_growth Desc

-- OR MySQL Limit function 
Select State , avg(Growth)*100 as avg_growth from projectP..Data1
group by State 
order by avg_growth Desc 
limit 3

-- Bottom 3 states showing the Sex Ratio

select Top 4 state, round(avg(Sex_Ratio), 0) as avg_sexr from projectP..Data1
group by State
order by avg_sexr 

-- Display Top and Bottam 5 states in Literacy rate
-- Creating Temporary Table
Drop Table if exists #upliteracy
create Table #upliteracy 
(state varchar(260),
toplitrate float)

Insert into #upliteracy 
Select  State, round(avg(Literacy), 2) as Literracy_rate from projectP..Data1
group by State
order by Literracy_rate desc

select Top 5 * from #upliteracy
order by #upliteracy.toplitrate Desc



Drop Table if exists #Bottoliteracy
create Table #Bottoliteracy 
(state varchar(260),
Bottomlitrate float)

Insert into #Bottoliteracy 
Select  State, round(avg(Literacy), 2) as Literracy_rate from projectP..Data1
group by State
order by Literracy_rate Asc

select Top 5 * from #Bottoliteracy
order by #Bottoliteracy.Bottomlitrate Asc

Select * from (select Top 5 * from #upliteracy
order by #upliteracy.toplitrate Desc) as d

union

select * from (select Top 5 * from #Bottoliteracy
order by #Bottoliteracy.Bottomlitrate Asc) A


-- Find the States Starting with letter A

Select Distinct State from projectP..Data1
where State Like 'A%'

-- States Starting with letter A or B
Select Distinct State from projectP..Data1
where lower(State) like 'a%' OR lower(state) like 'b%'


-- find the states ending with the letter d or starting with letter a.
Select Distinct State from projectP..Data1
where lower(State) like 'a%' OR lower(state) like '%d'

-- Find the district starting with a and ending with d
Select Distinct District from projectP..Data1
where lower(District) like 'a%' AND lower(District) like '%a'


select * from projectP..Data1

select * from projectP..Data2

--Find Total Number of males and female per State...
-- joining both the table

--sex_ratio - No.of Females per 1000 Males
-sx = f/m  f = m*sx/1000   p = f + m  f = p+m   m*sx/1000= p + m -- p= m(sx/1000 -1 ), m = p/(sx/1000 -1 )
-- Total No. Of Males
-- sx = f/m , m = f/sx  , p = f + m , f = p + m, f = p*sx/ (sx + 1000)
f = 

-- Joining both Tables
select d.state, sum(d.males) total_males, sum(d.females) total_females from 
(Select c.district, c.state,c.population, round(c.population/(1+ c.sex_ratio/1000), 0) as males, 
round(c.population* c.sex_ratio/(c.sex_ratio + 1000),0) 
as females from 
(select a.district, a.state ,a.sex_ratio, b.population from projectP..Data1 a inner join projectP..Data2 b 
on a.district = b.district) as c) d
group by d.State


-- finding Literacy Rate 
-- Literacy_ratio = total literate people/ Population 
-- total literate people =  Literacy_ratio * Population 
-- total_illiterate people = p - lp = p - lp*pop = p(1 - lp)
select c.state, sum(c.literate_people) as literate_plpl, sum(c.illiterate_people) as illeterate_plpl from
(select d.district, d.state, round(d.literacy_ratio*d.population, 0) as literate_people, 
round(d.population*(1- d.literacy_ratio),0) as illiterate_people from 
(select a.district, a.state, a.literacy/100 as literacy_ratio, b.population from projectP..Data1 a inner join projectP..Data2 b
on a.district = b.District)d ) c
group by c.state

select * from projectP..Data1

--Population in privious YEAR

-- PYP + growth*PYP = population 
-- PYP(1+growth) = pop  
-- PYP = pop/(1+growth)
select sum(m.pYp) as PYPop, sum(m.CYP) CYPOP from
(select d.state, sum(d.Pre_year_pop) as pYp, sum(d.current_yr_pop) as CYP from 
(Select c.state, c.district, round(c.population/(1+c.growth),0) Pre_year_pop, c.population  current_yr_pop from 
(select a.district, a.state, a.growth*100 as growth, b.population from projectP..Data1 a inner join projectP..Data2 b
on a.district = b.district) c) d
group by d.state)m

-- population vs Area 
select z.total_area_km2/PYPop as Pyp, z.total_area_km2/CYPOP as cyp from
(select q.*, n.total_area_km2 from 
(select '1' as keyd, n.* from 
(select sum(m.pYp) as PYPop, sum(m.CYP) CYPOP from
(select d.state, sum(d.Pre_year_pop) as pYp, sum(d.current_yr_pop) as CYP from 
(Select c.state, c.district, round(c.population/(1+c.growth),0) Pre_year_pop, c.population  current_yr_pop from 
(select a.district, a.state, a.growth*100 as growth, b.population from projectP..Data1 a inner join projectP..Data2 b
on a.district = b.district) c) d
group by d.state)m) n) q inner join 

(select '1' as keyd, x.* from
(select sum(Area_km2) total_area_km2 from projectP..Data2) x) n  on q.keyd = n.keyd) z

-- find Top 3 district from each state with highest literacy rate
Select * from 
(Select  district, state, literacy, 
Dense_rank() over ( partition by state order by Literacy desc) nomber from projectP..Data1 ) A
where A.nomber in (1,2,3) order by state

---- find Bottom 3 district from each state with min literacy rate
select * from 
(select district, state, literacy, RANK() over (partition by state order by Literacy Asc) nmb from projectP..Data1) V
where nmb in (1,2,3) 
order by V.state



















































































































 














































