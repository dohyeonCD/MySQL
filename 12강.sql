/*======================
집합연산자, 다중행연산자
======================*/

-- 도서 주문에서 고객 주소가 서울인 고객의 이름, 전화번호를 출력하자.
select username, phone
from customer
where address like '%서울%' and username in 
(select username from customer c, orders o where c.custid = o.custid);                -- 아까 2개씩 나오는 거 in 써서 해결함. in은 밑에 있음.


-- union(합집합)
-- 1. 서울이 주소인 고객
select username, phone from customer
where address like '%서울%';

-- 2. 주문이 있는 고객
select username, phone from customer c, orders o
where c.custid = o.custid;
select username, phone from customer
where custid in (select custid from orders);                   -- in을 사용하여 일치하는 값만 반환-> 중복을 배제시킴. 


-- union 사용
select username, phone from customer
where address like '%서울%'
union
select username, phone from customer
where custid in (select custid from orders);




-- minus 대체, not in
-- 대한민국에 거주하는 고객의 이름에서 도서를 주문한 고객의 이름을 제외하고 출력.
select username from customer
where address like '%대한민국%' 
and username not in (select username from customer c, orders o where c.custid = o.custid);


-- intersect 대체, in(교집합) in이든 not in 이든 비교하려는 대상이 같아야 함. 예를 들어서 username (not) in ~ username. 
select username from customer
where address like '%대한민국%' 
and username in (select username from customer c, orders o where c.custid = o.custid);




-- 주문이 있는 고객의 이름, 주소를 출력해보자.
-- exists (존재하는 것만 메인쿼리에 반영. 비교판단을 거침)
select username, address
from customer c                                                     -- 여기에도 orders o 쓰니까 결과가 중복이 되었음. 정말 딱 쓰는 테이블만 쓰자!
where exists (select * from orders o where c.custid = o.custid);




-- 주문일자가 2021-02-05 이전 주문 금액보다 비싼 모든 도서를 출력하시오.
-- all (서브쿼리의 결과와 메인쿼리의 비교를 모두 비교. 합집합 느낌~)
select * from book
where price > all (select saleprice from orders where orderdate > '2021-02-09');




-- 주문 테이블에서 주문가격이 5000 이상 20000 사이 도서의 도서 이름, 도서 가격을 출력하시오.
-- any (그 중에 하나. 서브쿼리의 결과들을 메인 쿼리 어떤 값이든 하나하나 비교)
select bookname, price from book
where price = any(select saleprice from orders where saleprice between 5000 and 20000);
