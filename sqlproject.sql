create schema ev;
select * from dim_date;
select * from electric_vehicle_sales_by_makers;
select * from electric_vehicle_sales_by_state;


select * from dim_date join electric_vehicle_sales_by_makers on dim_date.date=electric_vehicle_sales_by_makers.date;

#1.	List the top 3 and bottom 3 makers for the fiscal years 2023 and 2024 in terms of the number of 2-wheelers sold. 
select fiscal_year,vehicle_category,maker,sum(electric_vehicles_sold) As bottom_3
from electric_vehicle_sales_by_makers join dim_date on electric_vehicle_sales_by_makers.date=dim_date.date
where fiscal_year in (2023,2023) and vehicle_category='4-Wheelers'
group by fiscal_year,vehicle_category,maker
order by fiscal_year,bottom_3 desc limit 3  ;
#Bottom
select fiscal_year,vehicle_category,maker,sum(electric_vehicles_sold) As top_3
from electric_vehicle_sales_by_makers join dim_date on electric_vehicle_sales_by_makers.date=dim_date.date
where fiscal_year in (2023,2023) and vehicle_category='2-Wheelers'
group by fiscal_year,vehicle_category,maker
order by fiscal_year,top_3 desc limit 3 ;
 
 #2.Find the overall penetration rate in India for 2023 and 2022
select fiscal_year,(sum(electric_vehicles_sold)/sum(total_vehicles_sold))*100 as percentage 
from dim_date join electric_vehicle_sales_by_state 
on dim_date.date =electric_vehicle_sales_by_state.date
where fiscal_year in("2023","2022")
group by fiscal_year;

#3.	Identify the top 5 states with the highest penetration rate in 2-wheeler and 4-wheeler EV sales in FY 2024. 
select state,(sum(electric_vehicles_sold)/sum(total_vehicles_sold))* 100 as penetration
from dim_date join electric_vehicle_sales_by_state on dim_date.date=electric_vehicle_sales_by_state.date
where fiscal_year = 2024
group by state 
order by penetration desc limit 5;

#4.	List the top 5 states having highest number of EVs sold in 2023
select state,sum(electric_vehicles_sold)as total_ev_sale
from dim_date join electric_vehicle_sales_by_state on dim_date.date=electric_vehicle_sales_by_state.date 
where fiscal_year  =2023
group by state
 order by total_ev_sale ;
 
 # 5.	List the states with negative penetration (decline) in EV sales from 2022 to 2024? 
select state,fiscal_year,`quarter`,(sum(electric_vehicles_sold)/sum(total_vehicles_sold))*100 As penetration
from dim_date join electric_vehicle_sales_by_state on dim_date.date=electric_vehicle_sales_by_state.date
where fiscal_year  between 2022 and  2024 
group by  state, fiscal_year,`quarter`
order by state,fiscal_year,`quarter` ;

#6.	Which are the Top 5 EV makers in India?
select maker,sum(electric_vehicles_sold) from  electric_vehicle_sales_by_makers
group by maker 
order by sum(electric_vehicles_sold) desc limit  5;

#7.	How many EV makers sell 4-wheelers in India?
select maker from electric_vehicle_sales_by_makers
where  vehicle_category="4-Wheelers"
group by maker;

#8.	What is ratio of 2-wheeler makers to 4-wheeler makers?
select count(case when vehicle_category='2-Wheelers' then 1 end ) AS two_wheeler_count,
count(case when vehicle_category = '4-Wheelers' then 1 end ) AS four_wheeler_count,
(count(case when vehicle_category='2-Wheelers' THEN 1 END )*1.0/
COUNT(CASE WHEN vehicle_category='4-Wheelers' then 1 end)) AS two_wheeler_to_four_wheeler_ratio
from electric_vehicle_sales_by_makers;
 
#9.	What are the quarterly trends based on sales volume for the top 5 EV makers (4-wheelers) from 2022 to 2024? 
select maker,quarter, fiscal_year,sum(electric_vehicles_sold) As quarterly_trends
from dim_date join electric_vehicle_sales_by_makers on dim_date.date=electric_vehicle_sales_by_makers.date 
where  vehicle_category='4-Wheelers' and fiscal_year between 2022 and 2024
group by  maker, quarter,fiscal_year
order by maker,fiscal_year,quarter desc limit 5;

# 10. How do the EV sales and penetration rates in Maharashtra compare to Tamil Nadu for 2024? 
select state,sum(electric_vehicles_sold),(sum(electric_vehicles_sold)/sum(total_vehicles_sold))*100 As penetration_rate
 from electric_vehicle_sales_by_state join dim_date on electric_vehicle_sales_by_state.date=dim_date.date 
where state in("Maharashtra","Tamil Nadu") and fiscal_year="2024"
group by state ;


#11.List down the compounded annual growth rate (CAGR) in 4-wheeler units for the top 5 makers from 2022 to 2024. 
with top5makers As(select maker,sum(electric_vehicles_sold) as total_EV_sale from electric_vehicle_sales_by_makers 
join dim_date on electric_vehicle_sales_by_makers.date=dim_date.date
where vehicle_category="4-Wheelers" and fiscal_year between 2022 and 2024 
group by maker 
order by total_EV_sale desc limit 5)
select 
t1.maker,power(t3.total_EV_sale/t1.total_EV_sale,1/2)-1 As CAGR
from (select maker,sum(electric_vehicles_sold) as total_EV_sale from electric_vehicle_sales_by_makers
 join dim_date on electric_vehicle_sales_by_makers.date=dim_date.date
where fiscal_year=2022 group by maker)t1
join 
(select maker,sum(electric_vehicles_sold) as total_EV_sale from electric_vehicle_sales_by_makers 
join dim_date on electric_vehicle_sales_by_makers.date=dim_date.date
where fiscal_year=2024
group by maker)t3 on t1.maker=t3.maker
join top5makers t5 on t1.maker =t5.maker;

#12.List down the top 10 states that had the highest compounded annual growth rate (CAGR) from 2022 to 2024 in total vehicles sold. 
with StateSales as (
select 
state,
sum(case when fiscal_year =2022  then total_vehicles_sold else 0 end) As sales_2022,
sum(case when fiscal_year =2024 then  total_vehicles_sold else 0 end) As sales_2024
from dim_date join electric_vehicle_sales_by_state on dim_date.date=electric_vehicle_sales_by_state.date 
where fiscal_year in(2022,2024)
group by state
)
select 
state, 
power(sales_2024 / sales_2022, 1 / 2)-1 as CAGR
from StateSales
order by CAGR desc limit 10;
#####################################################################################
select * from dim_date;	
#change the string to date single
select month(str_to_date('01-May-21', '%d-%b-%y')) ;

# change the string to date 
update dim_date
SET Month = MONTH(STR_TO_DATE(date, '%d-%b-%y'));
SELECT * FROM dim_date;
#####################################################################################

#13.	What are the peak and low season months for EV sales based on the data from 2022 to 2024? 
WITH MonthlySales AS (
    SELECT
        fiscal_year, month,
        SUM(electric_vehicles_sold) AS total_sales
    FROM dim_date JOIN  electric_vehicle_sales_by_makers ON dim_date.date= electric_vehicle_sales_by_makers.date
    WHERE fiscal_year BETWEEN 2022 AND 2024
    GROUP BY fiscal_year, month)
    SELECT
    fiscal_year,
	month,
    total_sales,
    CASE
        WHEN total_sales > AVG(total_sales) OVER () THEN 'Peak'
        WHEN total_sales < AVG(total_sales) OVER () THEN 'Low'
        ELSE 'Average'
    END AS season_wise
FROM MonthlySales
ORDER BY fiscal_year, month;

select * from dim_date;	
#change the string to date single
select month(str_to_date('01-May-21', '%d-%b-%y')) ;

# change the string to date 
update dim_date
SET Month = MONTH(STR_TO_DATE(date, '%d-%b-%y'));

















 