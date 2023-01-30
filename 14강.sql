/*======================
view를 통한 집계
======================*/

-- 숫자집계함수
-- greatest(최고값. 언어는 유니코드 높은 순으로~)
SELECT GREATEST(29, -100, 34, 8, 25);
SELECT GREATEST("windows.com", "microsoft.com", "apple.com", '마이에스큐엘', '가나다라');


-- celing(무조건 반올림하여 정수로 표현. 정수면 그대로 반환.)
SELECT CEILING(30.75);
SELECT CEILING(40.25);
SELECT CEILING(40.0284);
SELECT CEILING(40);


-- round(반올림해서 소수점 1자리까지. 반올림이 안되는 경우면 그냥 1자리까지.)
SELECT ROUND(30.74, 1);
SELECT ROUND(100.925, 2);



-- 평균도서가격
select ceiling(sum(price)/count(price)) '평균1' , 
       sum(price)/count(price) '평균2', 
       round(sum(price)/count(price),2) '평균3'
from book;




-- 날짜 집계함수
-- WEEKOFYEAR, YEARWEEK      (둘 다 해당연도의 몇째주에 해당하는지. yearweek은 모드를 설정할 수 있음.)
select weekofyear('2022-10-30');           -- 날짜 입력할 때는 항상 문자형식으로~
select weekofyear('2022-12-31');           -- 2022년의 52주에 해당.
select yearweek('2022-12-31');             -- '202252' 로 표현함.

select week('2022-10-30', 1);              -- 모드값을 따로 지정 가능. (mode는 주의 시작을 일요일로 볼지~ 월요일로 볼지에 따라 다양함) weekofyear과 비슷(월).


-- dayofyear(해당연도의 몇번째 날인지.)
select dayofyear('2022-10-30');
select dayofyear('2022-01-01');


-- 주문한 년도별 가격과 평균가격
select year(orderdate) '년도', ceiling(sum(saleprice)/count(saleprice)) '평균가격'
from orders
group by 년도;

select year(orderdate) '년도', ceiling(sum(saleprice)/count(saleprice)) '평균가격'
from orders
group by 1;                         -- 해당 컬럼의 번호를 지정해도 됨.




-- view와 집계 함수
-- 주별 최소/최대 판매가 집계를 view로 만들기.
create or replace view v_weekly
as select yearweek(orderdate) '주',
	      min(saleprice) '최소판매가',
	      max(saleprice) '최대판매가'
from orders
group by 주;


-- 간편하게 사용 가능.
select * from v_weekly
where 최소판매가 >= 20000;




-- 특정 기간에 대한 요일별 판매량
-- 요일별 판매량 보고서는 특정 기간동안 Sun에서 Sat 요일별 판매량을 리포팅 해줍니다

-- 1. 수량 처리
select count(orderid) from orders;


-- 2. 요일별 수량 처리 
-- dayofweek는 해당날짜의 요일반환 (1:일 ~ 7:토)
select
case dayofweek(orderdate)                 -- case로 조건 제어..?
     when 1 then '일'
     when 2 then '월'
     when 3 then '화'
     when 4 then '수'
     when 5 then '목'
     when 6 then '금'
     when 7 then '토'
     end '요일',
count(orderid) '수량'
from orders
group by 요일;                           -- 컬럼이름으로 해도 됨. ''따옴표는 빼고. 


-- 3. 기간별 통계(2021년)
-- date_format(데이터형식(문자형식)을 날짜형식 속성으로 변환.)
select
case dayofweek(orderdate)
     when 1 then '일'
     when 2 then '월'
     when 3 then '화'
     when 4 then '수'
     when 5 then '목'
     when 6 then '금'
     when 7 then '토'
end '요일',
count(orderid) '수량'
from orders
where date_format(orderdate, '%Y-%m-%d') between '2021-01-01' and '2021-12-31'
group by 요일;
