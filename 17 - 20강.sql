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
desc actor;                                                             -- 구조 대충 확인(컬럼 확인~)
select lower(concat(first_name, ' ', last_name)) '배우' from actor;


-- son으로 끝나는 성을 가진 배우 (성: last name)
select * from actor
where last_name like '%son';


-- 배우들이 출연한 영화
select lower(concat(first_name, ' ', last_name)) '배우',
	   group_concat(f.title separator ',') '제목'
from actor a, film f, film_actor m
where a.actor_id = m.actor_id and f.film_id = m.film_id
group by 1;


-- 성 별 배우 숫자
select last_name, 
       count(*) '인원'
from actor
group by 1;


-- 특정 나라의 country_id 확인.
select country_id, country 
from country
where country in ('australia', 'germany');








/*======================
샘플 데이터와 그룹화 SQL 활용 
======================*/

-- staff를 메인으로 하여 address 합치기
select concat(first_name, ' ', last_name) 'staff',
       ad.address, ad.district, ad.postal_code, ad.city_id
from staff s
left join address ad on s.address_id = ad.address_id;         -- 왼쪽을 메인으로~ (합칠 때 natural join: ,랑 where써서 묶는 거는 null이 있을 수도.) 


-- staff들 임금 비교하기
select concat(first_name, ' ', last_name) 'staff',
       sum(amount) 'pay'
from staff s
left join payment p on s.staff_id = p.staff_id
where year(p.payment_date) = 2005 and month(p.payment_date) = 7
group by 1;


-- 영화별 출연 배우의 수
select f.title '영화',
       count(*) '출연 배우 수'
from film f
inner join film_actor m on f.film_id = m.film_id
group by 1;


-- 특정영화에 출연한 배우들
select title, concat(first_name, ' ', last_name) '배우'
from actor a, film f, film_actor m
where title like '%love' and a.actor_id = m.actor_id and f.film_id = m.film_id;


-- indian love에 출연한 배우들
select concat(first_name, ' ', last_name) '배우'
from actor a
where actor_id in (select actor_id from film_actor m
                   where film_id in (select film_id from film f
									 where lower(title)= lower('indian love')));
                                     

-- join 사용해보기.  (아마도.. in이라는 함수 자체에 =를 포함하고 있어서, film_id를 구한 시점에 이미 같은 film_id를 갖는 actor_id를 구한듯?)
select concat(first_name, ' ', last_name) '배우'
from actor a
join film_actor m on a.actor_id = m.actor_id
where film_id in (select film_id from film f where lower(title) = lower('indian love'));       -- f.fill_id = m.fill_id 하면 오류 남. 
------------------------------------------------------------------------------------------------------------------------------------
select concat(first_name, ' ', last_name) '배우'
from actor a
join film_actor m on a.actor_id = m.actor_id
join film f on f.film_id = m.film_id                                   -- join 연속해서 쓸 수 있음...ㅋㄷㅋㄷ 위에 join where 같이 쓸 필요 없었음..
where lower(title) = lower('indian love');




-- 국가가 canada인 고객의 이름
-- 1. subquery (꼬리 물기.. 서로 테이블끼리 연결되어있는 걸 이용해서. 캐나다인 사람의 country_id~ 가 동일한 city_id~ 가 동일한 address_id~ 가 동일한 고객...)
select concat(first_name, ' ', last_name) '고객'
from customer
where address_id in (select address_id from address 
                     where city_id in (select city_id from city 
									   where country_id in (select country_id from country 
															where country = 'canada')));

-- 2. join (진짜 환상이다 환상 ㅋㅋㅋㅋ)
select concat(first_name, ' ', last_name) '고객'
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where co.country = 'canada';




-- 영화 등급
select rating from film group by rating;


-- 영화에서 pg 또는 g 등급
select rating, count(*) from film
where rating = 'pg' or rating = 'g'                -- rating 생략하지 말기~
group by rating;


-- 영화에서 pg 또는 g 등급 영화 제목
select rating, group_concat(title separator ',')
from film
where rating = 'pg' or rating = 'g'
group by rating;




-- 대여비 관련
select distinct rental_rate from film;


-- 대여비가 1 ~ 6 이하
select title, rating
from film
where rental_rate between 1 and 6;


-- 대여비가 1 ~ 6 이하인 등급별 영화의 수를 출력
select rating, count(*)
from film
where rental_rate between 1 and 6
group by rating;


-- 등급별 영화 수와 합계, 최고, 최소 비용
select rating '등급',
       count(*) '영화 수',
       sum(rental_rate) '합계 비용',
       min(rental_rate) '최소 비용',
       max(rental_rate) '최대 비용'
from film
group by 1;       


-- 등급별 영화 수와 합계, 최고, 최소 비용을 조회하고 평균 대여비용으로 정렬 (오름차순 정렬: order by 컬럼 desc)
select rating '등급',
       count(*) '영화 수',
       sum(rental_rate) '합계 비용',
       avg(rental_rate) '평균 비용',                         -- 없어도 정렬은 되나, 구분이 어려우므로 컬럼 만들어주자~
       min(rental_rate) '최소 비용',
       max(rental_rate) '최대 비용'
from film
group by 1
order by avg(rental_rate);   




-- 등급별 랭킹 (desc를 안 넣으니까 내림차순으로 해서.. 작은 걸 1등이라고 함...............)
select rating, count(*) '영화수',
       rank() over(order by count(*) desc) 'rank',
       dense_rank() over(order by count(*) desc) 'dense',
       row_number() over(order by count(*) desc) 'row'
from film
group by 1;


-- 가장 대여비가 높은 영화 분류
select rental_rate,  group_concat(title separator ',') '영화',
       rank() over(order by max(rental_rate) desc) 'rank',
       dense_rank() over(order by max(rental_rate) desc) 'dense',
       row_number() over(order by max(rental_rate) desc) 'row'
from film
group by rental_rate;
       

-- 등급별로 구분하여 영화 수가 많은 순으로 대여비 랭킹화.  
select rating '등급', 
       rental_rate '대여비',
       count(*) '수',
       dense_rank() over(partition by rating order by count(*) desc) 'dense'       -- order by 순위를 매길 기준 
from film
group by rating, rental_rate;                                                      -- rating으로 그룹화하고, rental_rate로도 세부 그룹화.
