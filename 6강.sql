/*======================
정렬(order by)
======================*/

-- 도서를 이름순으로 검색하시오.
select *
from book
order by bookname;                 -- 해당 컬럼을 오름/내림으로 정렬. (오름- asc, 내림- desc)


-- 도서를 가격순으로 검색하고, 가격이 같으면 이름순으로 검색
select *
from book
order by price, bookname;


-- 오름차순/내림차순 지시
select *
from book
order by price desc, publisher asc;


-- 날짜순 정렬
select *
from orders
order by orderdate desc;                -- 날짜의 내림차순은, 최신순~


-- 판매가격이 10000 이상인 결과를 도서번호순으로 출력하시오
select *
from orders
where saleprice >= 10000
order by bookid;


-- 컬럼번호 2, 3번의 순서로 정렬
select *
from book
order by 2, 3;                         -- 2번컬럼 bookname먼저 정렬하고, 같은 값이 있으면 3번 컬럼 publisher로 정렬. 












/*======================
중복 배제(distinct)
======================*/

-- 주문 고객목록
select distinct custid from orders;                          -- orders 테이블에 있는 custid를 중복을 배제하고 정렬. 


-- 판매가격 목록
select distinct saleprice from orders;


-- 주문내역이 있는 고객의 수
select count(distinct custid) from orders;











/*======================
조건 제어(if, case)
======================*/

-- if
select if(100>200, '참', '거짓');                        -- 조건식이 참이면 순서대로 '참', 거짓이면 '거짓' 출력. (조건식, 참일 때 출력, 거짓일 때 출력)


-- 다중조건 case
-- 판매금액에 따라 고객등급을 출력하시오. 
select custid, sum(saleprice) as '총구매액',              -- custid의 saleprice의 합계를 구하여 '총구매액' 컬럼을 만든다~    변수같은 거 안됨ㅋㅋㅋ
case
when (sum(saleprice) >=60000) then '최우수고객'
when (sum(saleprice) >=40000) then '우수고객'
when (sum(saleprice) >=20000) then '일반고객'
else '유령고객'
end as '고객등급'
from orders group by custid;                            -- orders에서 custid로 그룹핑을 한 걸로 구분지어~
