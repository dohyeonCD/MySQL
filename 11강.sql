/*======================
join(테이블 관계)
======================*/

-- 일반조인(동등조인, inner조인)
-- 두 테이블에서 조회
select * from book, customer;

-- 세 테이블에서 조회
select * from book, customer, orders;




-- 조건문과 정렬을 함께 사용해보자. 고객 이름, 고객 주문 도서의 판매 가격을 출력
select username, saleprice
from customer c, orders o
where c.custid = o.custid;

-- inner join을 사용하여 같은 값을 출력한다면?
select username, saleprice
from customer c                                      -- from 뒤에, 조건의 기준이 되는 테이블 지정. 
join orders o on c.custid = o.custid;                -- join 뒤에 결합을 할 테이블. on에는 결합조건.


-- 도서 가격이 20000원 이상인 도서를 주문한 고객의 이름, 주문 도서 이름을 출력
select username '고객명', bookname '도서명'
from customer c, orders o, book b
where o.custid = c.custid and o.bookid = b.bookid and b.price >=20000;


-- group by를 함께 사용할 수 있다.
-- 고객별로 주문 도서의 총 판매액, 고객이름을 주문일자로 정렬. 
select username, sum(o.saleprice) '총 판매액', o.orderdate
from customer c, orders o 
where c.custid = o.custid
group by c.username                                               -- group by는 보통 from 뒤에 있지만, 조건절 where가 있다면 where 뒤에 쓰임.
order by o.orderdate;




-- 외부조인
-- 도서를 구매하지 않은 고객을 포함해 고객이름, 전화번호와 주문 도서의 판매 가격을 출력.
select username, phone, o.saleprice
from customer c
left outer join orders o on c.custid = o.custid;                    -- outer join은 left나 right에 중점을 두고 결합. 중점 둔 곳은 무조건 살림.




-- cross join (상호 존재하는 행을 모두 반환, 많은쪽 행 수만큼 반환 (10개와 2개가 있다면, 10개를 기준으로 2개를 다 결합시켜서 10개의 결과가 출력.))
-- 도서를 구매한 이력이 있는 고객 이름, 판매 도서의 가격을 출력하시오.
select username, saleprice
from customer c
cross join orders o on c.custid = o.custid;
