/*======================
공공 데이터를 이용한 SQL 활용
======================*/

-- 0. 임시 스키마 생성 (seoul_data)
-- 1. 테이블 생성
create table if not exists `bicycle_202101` ( 
  `자전거번호` varchar(12),
  `대여일시` datetime,
  `대여소번호` int,
  `대여소명` varchar(100),
  `대여거치대` int default null, 
  `반납일시` datetime,
  `반납대여소번호` int,
  `반납대여소명` varchar(100),
  `반납거치대` int default null,
  `이용시간` int default null,
  `이용거리` double default null
) engine=InnoDB default charset=utf8mb4;

-- 2. 데이터 들여오기 (server -> data import -> self~ -> 스키마 지정)
-- 3. 데이터 살펴보기
select count(*) from bicycle_202012;
select count(*) from bicycle_202101;


-- 4. view 생성 (bicycle_rental)
create or replace view bicycle_rental as
select * from bicycle_202012;


-- view 합치기 (2020, 2021)
create or replace view bicycle_rental as
select * from bicycle_202012
union all select * from bicycle_202101;


select * from bicycle_rental limit 10;                               -- head 느낌




-- 대여소 숫자
select count(distinct 대여소번호) '대여소 수', count(*) '레코드 수'
from bicycle_rental;


-- 자전거 수량
select count(distinct 자전거번호) '자전거 수량' from bicycle_rental;


-- 대여소별 사용한 자전거 수량
select 대여소명, count(distinct 자전거번호) '자전거 수량'
from bicycle_rental
group by 대여소명
order by 2 desc;


-- 대여소별 이용량이 많은 곳. (이용시간 기준)
select 대여소번호, 대여소명, sum(이용시간) '이용시간',
dense_rank() over (order by sum(이용시간) desc) '대여 순위'                    -- 이렇게 해도 되고, 어차피 시간은 같은 값 나오기 어려우니까, order by도 O
from bicycle_rental
group by 대여소번호;


-- 12월 이용 통계
select date_format(대여일시, '%Y-%m') '12월',
       count(대여일시) '총 대여 수',
       sum(이용시간) '총 이용시간',
       avg(이용시간) '평균 이용시간',
       min(이용시간) '최소 이용시간',
       max(이용시간) '최대 이용시간',
       avg(이용거리) '평균 이용거리'
from bicycle_rental
group by 1;       


-- 자전거별 12월 이용 통계
select 자전거번호 '자전거',
       date_format(대여일시, '%Y-%m') '12월',
       count(대여일시) '총 대여 수',
       sum(이용시간) '총 이용시간',
       avg(이용시간) '평균 이용시간',
       min(이용시간) '최소 이용시간',
       max(이용시간) '최대 이용시간',
       avg(이용거리) '평균 이용거리'
from bicycle_rental
group by 1
order by 4 desc; 


-- 대여소로 분류한 후, 12월 자전거별 대여횟수
select date_format(대여일시, '%Y-%m') '12월',
       대여소명, 자전거번호,
       count(대여일시) '총 대여 수'
from bicycle_rental
group by 대여소명, 자전거번호
order by 4 desc;


-- 총 이용시간별 대여소 등급
select 대여소번호, 대여소명,
       sum(이용시간) '총 이용시간',
case
    when (sum(이용시간) > 80000) then '최우수'
    when (sum(이용시간) > 40000) then '우수'
    when (sum(이용시간) > 20000) then '일반'
    else '기타'
end as '등급'
from bicycle_rental
group by 대여소명
order by 3 desc;




-- 소계 이용
-- ifnull 활용
select ifnull(대여소명, '소계'),
       ifnull(자전거번호, '소계'),
       sum(이용시간)
from bicycle_rental
where date_format(대여일시, '%Y-%m-%d') between '2020-12-01' and '2020-12-05'
group by 대여소명, 자전거번호 with rollup;                                            -- 대여소명 총 이용시간을 자동으로 합계해줌. 신한은행~ 소계. 4125 ~




-- 대여소별 이용량이 많은 곳에 대한 top10
-- 1 대여소별 순위
select 대여소번호, 대여소명,
       count(*) '이용량',
       dense_rank() over (order by count(*) desc) '순위'
from bicycle_rental
group by 1;                                                          -- group by를 할 컬럼 제일 앞에 오도록! 대여소명(2)으로 하려니까 계속 오류남...


-- 2 대여소별 순위에서 TOP10
select * 
from (select 대여소번호, 대여소명,
             count(*) '이용량',
             dense_rank() over (order by count(*) desc) '순위'
      from bicycle_rental
      group by 1) a                                                   -- a라고 지정을 해줘야 함.
where 순위 <= 10;
