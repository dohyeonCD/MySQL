/*======================
샘플 데이터를 이용한 SQL 활용 (sakila)
======================*/

-- 각 테이블 확인 (배우, 나라..)
select count(*) from actor;
select count(*) from country;
select count(*) from customer;
select count(*) from film;
select count(*) from staff;
select count(*) from inventory;
select count(*) from rental;


-- 배우 이름 
desc actor;                                                             -- 구조 대충 확인(컬럼 확인~) describe의 줄임말.
select lower(concat(first_name, ' ', last_name)) '배우' from actor;


-- son으로 끝나는 성을 가진 배우 (성: last name)
select * from actor
where last_name like '%son';


-- 배우들이 출연한 영화
select lower(concat(first_name, ' ', last_name)) '배우',
	   group_concat(f.title separator ',') '제목'
from actor a, film f, film_actor fa
where a.actor_id = fa.actor_id and f.film_id = fa.film_id
group by 1;


-- 성 별 배우 숫자
select last_name, 
       count(*) '인원'
from actor
group by 1;


-- 특정 나라의 country_id 확인. (australia, germany)
select country_id, country 
from country
where country in ('australia', 'germany');








/*======================
샘플 데이터와 그룹화 SQL 활용 
======================*/

-- staff를 메인으로 하여 address 합치기
select concat(first_name, ' ', last_name) 'staff',
       a.address, a.city_id
from staff s
left join address a on s.address_id = a.address_id;         -- 왼쪽을 메인으로~


-- staff들 임금 비교하기 (2005년 7월)
select concat(first_name, ' ', last_name) 'staff',
	   sum(amount) 'payment'
from staff s
left join payment p on s.staff_id = p.staff_id
where year(payment_date) = 2005 and month(payment_date) = 7
group by 1;




-- 영화별 출연 배우의 수
select title '영화',
       count(*) '출연 배우 수'
from film f
inner join film_actor fa on f.film_id = fa.film_id
group by 1;


-- 특정영화에 출연한 배우들(love)
select title '영화',
	   group_concat(concat(first_name, ' ', last_name) separator ',') '배우'
from film f, actor a, film_actor fa
where f.film_id = fa.film_id and a.actor_id = fa.actor_id and title like '%love%'
group by 1;


-- indian love에 출연한 배우들
select title '영화',
	   group_concat(concat(first_name, ' ', last_name) separator ',') '배우'
from film f, actor a, film_actor fa
where f.film_id = fa.film_id and a.actor_id = fa.actor_id and lower(title) = 'indian love'
group by 1;
                        

-- join 사용해보기. (join 연속해서 쓸 수 있음. join의 on을 다 만족한 다음 where을 가기때문에, 같은 결과라면 on으로 끝내는 게 낫다고 함(where과 on 굳이 같이 쓰지 않기))
select title '영화',
	   group_concat(concat(first_name, ' ', last_name) separator ',') '배우'
from film_actor fa
join film f on f.film_id = fa.film_id
join actor a on a.actor_id = fa.actor_id and lower(title) = 'indian love';








-- 국가가 canada인 고객의 이름
-- 1. subquery (꼬리 물기. 서로 테이블끼리 연결되어있는 걸 이용해서. 캐나다의 country_id~ 가 동일한 city_id~ 가 동일한 address_id~ 가 동일한 고객...)
select group_concat(concat(first_name, ' ', last_name) separator ',') '고객명'
from customer
where address_id in (select address_id from address
					 where city_id in (select city_id from city
									   where country_id in (select country_id from country
															where lower(country) = 'canada')));


-- (where 조건절로 잇기)
select country '국가',
	   group_concat(concat(first_name, ' ', last_name) separator ',') '고객명'
from customer cu, address ad, city ci, country co
where lower(country) = 'canada' and co.country_id = ci.country_id and ci.city_id = ad.city_id and ad.address_id = cu.address_id
group by 1;




-- 2. join
select country '영화',
	   group_concat(concat(first_name, ' ', last_name) separator ',') '고객명'
from customer cu
join address ad on cu.address_id = ad.address_id
join city ci on ad.city_id = ci.city_id
join country co on ci.country_id = co.country_id and lower(country) = 'canada';








-- 영화 등급
select rating from film group by rating;


-- pg 또는 g 등급의 영화 수와 제목
select rating '등급',
	   count(*) '영화 수',
       group_concat(title separator ',') '영화 제목'
from film
where lower(rating) = 'pg' or lower(rating) = 'g'               -- rating 생략하지 말기~
group by 1;




-- 대여비 종류
select distinct rental_rate from film;


-- 대여비가 1 ~ 6 이하인 영화 제목과 등급
select title '영화 제목',
	   rating '등급',
       rental_rate '대여비'
from film
where rental_rate between 1 and 6;


-- 대여비가 1 ~ 6 이하인 등급별 영화의 수를 출력
select rating '등급',
       count(*) '영화 수'
from film
where rental_rate >=1 and rental_rate <=6
group by 1;


-- 등급별 영화 수와 대여비의 합계, 최소, 최대값
select rating '등급',
       count(*) '영화 수',
       sum(rental_rate) '합계 비용',
       min(rental_rate) '최소 비용',
       max(rental_rate) '최대 비용'
from film
group by 1;       


-- 등급별 영화 수와 대여비의 합계, 최소, 최대값을 조회하고 평균 대여비용으로 정렬 (내림차순 정렬: order by 컬럼 desc)
select rating '등급',
       count(*) '영화 수',
       avg(rental_rate) '평균 비용',                         -- 없어도 정렬은 되나, 구분이 어려우므로 컬럼 만들어주자~
       sum(rental_rate) '합계 비용',
       min(rental_rate) '최소 비용',
       max(rental_rate) '최대 비용'
from film
group by 1
order by 3;




-- 등급별 영화 수 랭킹 (기본은 asc 오름차순)
select rating '등급',
	   count(*) '영화 수',
       rank () over (order by count(*) desc) '랭킹(rank)',
	   dense_rank () over (order by count(*) desc) '랭킹(dense)',
       row_number() over (order by count(*) desc) '랭킹(row)'
from film
group by 1;


-- 대여비가 가장 높은 영화 등급별 분류
select rental_rate '대여비',
	   rating '등급',
	   group_concat(title order by title separator ',') '영화',
       count(*) '영화 수'
from film
where rental_rate in (select max(rental_rate) from film)
group by 2;

       
-- 등급, 대여비별로 구분하여 영화 수가 많은 순으로 랭킹화.
select rating '등급',
	   count(*) '영화 수',
       rental_rate '대여비',
       dense_rank () over (partition by rating order by count(*) desc) '랭킹(dense)'      -- partition by를 지정해야 등급별로 순위를 나눔. order by 순위를 매길 기준 
from film
group by 1, 3;                                                                           -- rating으로 그룹화하고, rental_rate로도 세부 그룹화.
