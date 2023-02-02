/*======================
공공 데이터를 이용한 SQL 활용
======================*/

-- 0. 임시 스키마 생성 (seoul_data)
-- 1. 테이블 생성 (생성한 후에 덤프 데이터를 import 해야 함. 테이블명 확인~)
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
create or replace view v_bicycle_rental
as select * from bicycle_202012;


-- view 합치기 (2020, 2021)
create or replace view v_bicycle_rental
as select * from bicycle_202012
union all select * from bicycle_202101;


select * from v_bicycle_rental limit 10;                               -- head 느낌




-- 대여소 숫자
select count(distinct 대여소번호) '대여소 수', count(*) '레코드 수'
from v_bicycle_rental;


-- 자전거 수량
select count(distinct 자전거번호) '자전거 수량' from v_bicycle_rental;


-- 대여소별 사용한 자전거 수량 (자전거 수량이 많은 순으로 정렬)
select 대여소번호, 
	   count(자전거번호) 
from v_bicycle_rental
group by 1
order by 2 desc;


-- 대여소별 이용량이 많은 곳. (이용시간 기준)
select * from v_bicycle_rental limit 10;

select 대여소번호, 
	   대여소명,
	   sum(이용시간) '이용량(h)',
       dense_rank() over (order by sum(이용시간) desc) '대여 순위'        -- partition by를 하니까 안됐음. 아마 전에 partition~ 하고 group~ 됐던 건 그룹핑을 2번 해야 해서인듯.
from v_bicycle_rental
group by 1;




-- 12월 이용 통계
select date_format(대여일시, '%Y-%m') '12월',
	   format(count(대여일시),0) '이용횟수',
       format(sum(이용시간),0) '이용시간(h)',
       format(avg(이용시간),2) '평균 이용시간(h)',
	   format(sum(이용거리),2) '이용거리',
       format(avg(이용거리),2) '평균 이용거리'
from v_bicycle_rental
where date_format(대여일시, '%m') = '12';


-- 자전거별 12월 이용 통계
select 자전거번호,
	   date_format(대여일시, '%Y-%m') '12월',
       count(대여일시) '이용횟수',
       format(sum(이용시간),0) '이용시간(h)',
       format(avg(이용시간),2) '평균이용시간(h)',
	   format(sum(이용거리),2) '이용거리',
       format(avg(이용거리),2) '평균 이용거리'
from v_bicycle_rental
where date_format(대여일시, '%m') = '12'
group by 1
order by 3 desc;


-- 대여소로 분류한 후, 12월 자전거별 대여횟수
select * from v_bicycle_rental;

select 대여소번호, 
	   대여소명,
       date_format(대여일시, '%Y-%m') '12월',
       자전거번호,
       format(count(대여일시),0) '대여횟수'
from v_bicycle_rental
where date_format(대여일시, '%m') = '12'
group by 1, 4
order by 5 desc;




-- 총 이용시간별 대여소 등급(8, 4, 2)
select 대여소번호,
	   대여소명,
       format(sum(이용시간),0) '이용시간(h)',
       case
			when (sum(이용시간) > 80000) then '최우수'
            when (sum(이용시간) > 40000) then '우수'
            when (sum(이용시간) > 20000) then '보통'
            else '기타'
	   end as '대여소 등급'
from v_bicycle_rental
group by 1
order by sum(이용시간) desc;                               -- 이렇게 하는 이유: format을 하면 ',' 쉼표를 의식해서 12,000과 130 중에 130이 크다고 인식을 함...
														 -- 그러므로 테이블상에는 가시성을 위해 format을 하고, 조건절에는 sum으로 정확한 조건을 걸어두자.




-- 소계 이용
-- ifnull 활용
select ifnull(대여소명, '소계'),
       ifnull(자전거번호, '소계'),
       sum(이용시간)
from v_bicycle_rental
where date_format(대여일시, '%Y-%m-%d') between '2020-12-01' and '2020-12-05'
group by 대여소명, 자전거번호 with rollup;                                            -- 대여소별 총 이용시간을 자동으로 산출해줌. 신한은행~ 소계: 4125 ~




-- 대여소별 이용량이 많은 곳에 대한 Top10
-- 1. limit
select 대여소번호, 
	   대여소명,
       count(대여일시) '이용량',
       dense_rank() over (order by count(대여일시) desc) '순위'
from v_bicycle_rental
group by 1                                                          -- group by를 할 컬럼 제일 앞에 오도록!
limit 10;


-- 2. SubQuery
select * from (
	select 대여소번호,
		   대여소명,
		   count(대여일시) '이용량',
		   dense_rank() over (order by count(대여일시) desc) '순위'
	from v_bicycle_rental
	group by 1) as sub_Q
where 순위 <= 10;                                                    -- 그냥 쿼리에서 '순위' 컬럼을 조건으로 걸면, 아직 만들어지지 않은 컬럼명이기때문에 인식을 못함.
																	-- 하지만 서브쿼리를 만들고 이름을 지정해놓는다면, 서브쿼리를 먼저 수행하고 메인쿼리를 수행하기때문에
																	-- '순위' 라는 컬럼을 인식할 수 있음 (서브쿼리를 사용하려면 서브쿼리 이름 지정!).