use Bank_loan;
select * from Finance_1;
select * from Finance_2;


--Query_1) Year wise loan amount stats
select year(issue_d) as year, sum(loan_amnt) as Total_loan
from Finance_1
group by year(issue_d)
order by year;


--Query_2) Grade and Sub grade wise revol_bal
select f1.grade, f1.sub_grade, sum(f2.revol_bal) as revol_bal
from Finance_1 as f1
inner join Finance_2 as f2
on f1.id=f2.id
group by f1.grade, f1.sub_grade
order by f1.grade, f1.sub_grade;


--Query_3) Total Payment for Verified Status Vs Total Payment for Non Verified Status
select f1.verification_status, round(sum(f2.total_pymnt),2) as Sum_Total_Payment
from Finance_1  f1
join Finance_2  f2
	on f1.id = f2.id
where f1.verification_status = 'Verified' or f1.verification_status = 'Not Verified'
group by f1.verification_status;


--Query_4) State wise and last_credit_pull_d wise loan status
Select addr_state as state, year(last_credit_pull_d) as year, loan_status, sum(loan_amnt)
from Finance_1 as f1
inner join Finance_2 as f2
on f1.id = f2.id
group by addr_state, year(last_credit_pull_d ), loan_status
order by addr_state, year(last_credit_pull_d ), loan_status;


--Q5.Home Ownership Vs Last payment date stats
select f1.home_ownership, max(f2.last_pymnt_d) as Last_Payment_Date
from Finance_1 as f1
inner join Finance_2 as f2
on f1.id = f2.id
group by f1.home_ownership
order by f1.home_ownership;