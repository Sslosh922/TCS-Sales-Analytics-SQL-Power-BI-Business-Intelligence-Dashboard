create table clients (
client_id int primary key,
client_name varchar(100),
industry varchar(50),
region varchar(50)
);

create table employees (
emp_id int primary key,
role varchar(50),
experience_level varchar(30),
cost_per_hour numeric(10,2)
);

create table projects (
project_id int primary key,
client_id int,
service_line varchar(50),
start_date date,
end_date date,
foreign key (client_id)
references clients(client_id)
);

create table billing (
billing_id int primary key,
project_id int,
emp_id int,
billing_date date,
hours int,
cost numeric(12,2),
revenue numeric(15,2),
foreign key (project_id)
references projects(project_id),
foreign key (emp_id)
references employees(emp_id)
);


--1.Find the total revenue, total cost, and profit.

select 
sum(revenue) as total_revenue,
sum(cost) as total_cost,
sum(revenue-cost) as total_profit
from billing;

-- 2.Count the number of unique client_id, project_id, and emp_id.

select 
(select count(distinct client_id) from clients) as unique_clients ,
(select count(distinct emp_id) from employees)as unique_emp ,
(select count(distinct project_id)from projects)as unique_projects 

--3.Get the total revenue grouped by client_id
select * from billing limit 10;
select * from clients limit 10;
select * from projects limit 10;

select sum(revenue)  as total_revenue, client_id
from billing b1 
join projects p1
on p1.project_id = b1.project_id
group by client_id; 

--4. Get the total revenue grouped by region.
	
select sum(revenue) as total_revenue,region
from billing b1 
join projects p1
on p1.project_id = b1.project_id
join clients c1
on c1.client_id = p1.client_id
group by region;


-- 5. Get the total revenue grouped by service_line.
select sum(revenue)  as total_revenue, service_line
from billing b1 
join projects p1
on p1.project_id = b1.project_id
group by service_line; 

-- 6.Find the top client_id based on total revenue.

select c1.client_id , sum(revenue) as  total_revenue
from billing b1
join projects p1 
on p1.project_id = b1.project_id
join clients c1
on c1.client_id = p1.client_id
group by c1.client_id
order by sum(revenue) desc  limit 1;

-- 7.Find the project_id with highest profit.

select p1.project_id , sum(revenue-cost)
from billing b1
join 
projects p1 
on p1.project_id =b1.project_id
group by p1.project_id
order by sum(revenue-cost) desc limit 1;

-- 8.Find the emp_id with highest total billed hours.

select  emp_id , sum(hours) as  total_billed_hours
from billing b1 
join projects p1
on p1.project_id = b1.project_id
join clients c1
on c1.client_id = p1.client_id
group by emp_id
order by  sum(hours) desc limit 1;


-- 9. Calculate profit margin for each project_id.
select p1.project_id , round(sum(revenue-cost)/sum(revenue) * 100,2) as profit_margin
from billing b1
join 
projects p1 
on p1.project_id =b1.project_id
group by p1.project_id
order by round(sum(revenue-cost)/sum(revenue) * 100,2) desc;


-- 10.Get total revenue for each billing_date

select billing_date , sum(revenue) as total_revenue
from billing
group by billing_date
order by sum(revenue) desc limit 10 ;

--11. Find project_id where total cost > total revenue
select p1.project_id , sum(revenue)as total_revenue, sum(cost) total_cost
from billing b1
join 
projects p1 
on p1.project_id =b1.project_id
 group by p1.project_id
having sum(b1.cost)  > sum(b1.revenue)
 -- (
 -- select sum(revenue)
 -- from billing
 -- );

 -- 12. Identify client_id contributing highest share of revenue
 select  c1.client_id , sum(revenue) as  total_revenue
from billing b1 
join projects p1
on p1.project_id = b1.project_id
join clients c1
on c1.client_id = p1.client_id
group by c1.client_id
order by  sum(revenue) desc limit 1;

-- 13.Find emp_id with high hours but low revenue.
select  emp_id , sum(hours) as  total_hours,sum(revenue) total_revenue
from billing b1 
join projects p1
on p1.project_id = b1.project_id
join clients c1
on c1.client_id = p1.client_id
group by emp_id
order by  sum(hours) desc , sum(revenue) asc limit 10;

--14.Identify region with high revenue but low profit.

select region,sum(revenue) as total_revenue,sum(revenue-cost) as total_profit
from billing b1 
join projects p1
on p1.project_id = b1.project_id
join clients c1
on c1.client_id = p1.client_id
group by region
order by sum(revenue) desc , sum(revenue-cost) asc limit 10;

-- 15. Find projects with long duration but low revenue.

select   p1.project_id,(p1.end_date - p1.start_date) as duration_days , sum(revenue) as total_revenue
from billing b1
join projects p1
on p1.project_id = b1.project_id
group by p1.project_id
order by (p1.end_date - p1.start_date) desc , sum(revenue) asc limit 20;

--16.Calculate monthly revenue trend using billing_date

select to_char(date_trunc('month',billing_date),'mon yyyy') as monthly_trend ,
sum(revenue) as revnue_per_month
from billing
group by date_trunc('month',billing_date)
order by sum(revenue) desc;

-- 17.Calculate monthly profit trend.
select to_char(date_trunc('month',billing_date),'mon yyyy') as monthly_trend ,
sum(revenue-cost) as profit_per_month
from billing
group by date_trunc('month',billing_date)
order by sum(revenue-cost) desc;


-- 18. Identify top 3 months with highest revenue.
select to_char(date_trunc('month',billing_date),'mon yyyy') as monthly_trend ,
sum(revenue) as revnue_per_month
from billing
group by date_trunc('month',billing_date)
order by sum(revenue) desc limit 3;



