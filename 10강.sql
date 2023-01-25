/*======================
집계함수
======================*/
-- 총 주문량 조회
select count(*), count(saleprice) from orders;             -- null 없나봄.


-- null을 포함한 컬럼의 결과 비교
select count(*), count(phone) from customer;


-- 평균 구매 가격을 조회
select avg(o.saleprice), avg(b.price) from orders o, book b;               -- 평균주문가격과, 도서의 평균 가격. 각각 간편하게 나타낼 수 있음. 
select avg(o.saleprice) '평균주문가격' , avg(b.price) '평균가격' from orders o, book b;     

-- 총주문량과 평균판매가
select count(*) '총주문량', avg(saleprice) '평균판매가' from orders;        
select count(*) '총주문량', avg(ifnull(saleprice,0)) '평균판매가' from orders;                             -- 만약 null이 있으면-> 오류나니까 안전하게 ifnull로 대체값(0) 지정. 


-- 도서의 총 판매액, 평균값, 최저가, 최고가를 구하고 판매된 도서의 종류를 개수로 조회하자.
select sum(o.saleprice) '총 판매액', 
          avg(o.saleprice) '평균값',
          min(o.saleprice) '최저가',
          max(o.saleprice) '최고가',
          count(distinct o.bookid) '판매 도서수'                                  -- 중복 배제
from orders o, book b                                                                   -- as와 ''없이 별칭 지정.
where o.bookid = b.bookid;




-- group by  
-- (where 이 먼저 나오고 group by가 나와야 함. 그리고 having은 group by 뒤에만 올 수 있음.)
-- 고객별로 주문한 도서의 총 수량과 총 판매액을 구하시오.
select custid,
       count(*) '총 수량',
       sum(saleprice) '총 판매액'
from orders group by custid;                    -- group by 할 때, 그룹핑한 컬럼과 select하려는 컬럼이 동일한지 확인!


-- 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가와 고객아이디를 출력하시오.
select custid,
		  sum(saleprice) '총 판매액',
          avg(saleprice) '평균값',
          min(saleprice) '최저가',
          max(saleprice) '최고가'
from orders
group by custid;




-- 가격 8000 이상인 도서의 판매수량을 구하는데 단, 2권 이상 주문한 고객의 이름, 주문수량, 판매금액을 조회하자.
select o.custid '고객아이디',
          c.username '고객 이름',
          count(o.saleprice) '주문수량',
          sum(o.saleprice) '판매금액'
from orders o, customer c, book b
where b.price >= 8000 and b.bookid = o.bookid and c.custid = o.custid
group by o.custid
having count(o.saleprice) >= 2;