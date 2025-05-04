use bank_analysis;
select * from finance_1;
select * from finance_2;
select * from finance_1 as f1 join finance_2 as f2 on f1.id = f2.id;

#KPI 1  Year wise loan amount & no.of loans

select year(issue_d) as loan_year , 
concat(round(sum(loan_amnt)/1000000,1),"M") as total_loan_amount, 
count(*) as number_of_loans from finance_1 group by Loan_Year order by loan_year;


#KPI 2 Grade & sub grade wise total_revol_bal and average_revol_bal

select grade ,
sub_grade , 
concat(round(sum(revol_bal)/1000000,2),"M") as total_rev_bal,
concat(round(avg(revol_bal)/1000,2),"K") as avg_revol_bal
from finance_1 as f1 join finance_2 as f2 on f1.id = f2.id 
group by grade , sub_grade order by grade;


#KPI 3 Total Payment for verified vs not verified

select 
  verification_status ,
  concat(round(sum(total_pymnt)/1000000,2),"M") as Total_Payment ,
  concat(round((sum(total_pymnt)/(
     select sum(total_pymnt) from finance_1 as f1 
     join finance_2 as f2 on f1.id = f2.id 
     ))*100,2),"%") as Percentage
from finance_1 as f1
join finance_2 as f2 on f1.id = f2.id 
where verification_status IN("Verified","Not Verified") 
group by verification_status;



#KPI 4 State & last_credit_pull_d wise loan_status and no_of_loans

select addr_state as State , 
last_credit_pull_d, 
loan_status,
count(*) as num_of_loans 
from finance_1 as f1
join finance_2 as f2 on f1.id = f2.id 
group by State,last_credit_pull_d,loan_status ;



#KPI 5 home_ownership vs last_payment_d (payment_amount)

select home_ownership, last_pymnt_d as last_payment_d,
case when sum(last_pymnt_amnt) > '1000000' then concat('$',(format(sum(last_pymnt_amnt)/100000,2)),'M')
     when sum(last_pymnt_amnt) > '100000' then concat('$',(format(sum(last_pymnt_amnt)/100000,2)),'L')
     when sum(last_pymnt_amnt) > 1000 then concat('$',(format(sum(last_pymnt_amnt)/1000,2)),'K')
     else sum(last_pymnt_amnt)
end as payment_amount from finance_1 as f1
join finance_2 as f2 on f1.id = f2.id group by home_ownership, last_payment_d ;


####Extra KPIs
#KPI 6 count_of_home_ownership and average_interest_rate per type

select home_ownership ,
count(home_ownership) as count_of_home_ownership , 
concat(format(avg(int_rate),2),'%') as Average_interest_rate 
from finance_1 group by home_ownership;



#KPI 7 Purpose vs Loan amount - average_loan_amount , highest & lowest loan amount

select purpose , 
format(avg(loan_amnt),2)  as avg_loan_amount, 
format(max(loan_amnt),2) as highest_loan_amount,
min(loan_amnt) as lowest_loan_amount 
from finance_1 group by purpose;



#KPI 8 Total_loan, total_funded, avg_int_rate, total_revol_bal, no_of_customers 

select concat(format(sum(loan_amnt)/1000000,2),'M') as Total_loan_amount, 
concat(format(sum(funded_amnt)/1000000,2),'M') as Total_funded_amount, 
concat(format(avg(int_rate),2),'%') as Average_interest_rate_overall, 
concat(format(sum(revol_bal)/1000000,2),'M') as Total_revol_bal,
count(*) as Total_number_of_customers from finance_1 as f1 join finance_2 as f2 on f1.id = f2.id;
