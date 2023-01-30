/*======================
View
======================*/

-- 레코드를 몇개 더 추가하자.
INSERT INTO Book VALUES(12, 'OpenCV 파이썬', '포웨이', 23500);
INSERT INTO Book VALUES(13, '자연어 처리 시작하기', '투시즌', 20000);
INSERT INTO Book VALUES(14, 'SQL 이해', '새미디어', 22000);

INSERT INTO Customer VALUES (6, '박보영', '서울 서초구', '010-8214-9010');
INSERT INTO Customer VALUES (7, '오정세', '서울 중구', '010-5190-1090');
INSERT INTO Customer VALUES (8, '이병헌', '서울 성북구', NULL);

INSERT INTO Orders VALUES (11, 6, 12, 23500, STR_TO_DATE('2020-02-01','%Y-%m-%d')); 
INSERT INTO Orders VALUES (12, 6, 14, 44000, STR_TO_DATE('2020-02-03','%Y-%m-%d'));
INSERT INTO Orders VALUES (13, 8, 13, 20000, STR_TO_DATE('2020-02-03','%Y-%m-%d')); 
INSERT INTO Orders VALUES (14, 3, 13, 20000, STR_TO_DATE('2020-02-04','%Y-%m-%d')); 
INSERT INTO Orders VALUES (15, 4, 12, 23500, STR_TO_DATE('2020-02-05','%Y-%m-%d'));
INSERT INTO Orders VALUES (16, 5, 8, 35000, STR_TO_DATE('2020-02-07','%Y-%m-%d'));

select * from book
where bookid in (12,13,14);              -- bookid가 12, 13, 14에 해당하는 값 출력. 




-- view 이해하고 사용하기. (view는 별도의 가상 테이블 공간.)
create view v_orders
as select orderid, o.custid, username, o.bookid, saleprice, orderdate           -- 컬럼 지정. 테이블에 공통되는 컬럼이 있으면 구분을 해주고(c.) 유일한 컬럼이면 냅둠.
   from book b, customer c, orders o
   where b.bookid = o.bookid and c.custid = o.custid;
   
select * from v_orders;                                       -- 만들어진 view는 테이블처럼 사용가능. 

select username, sum(saleprice) from v_orders                 -- 테이블로 했으면 복잡할 구문(o.누구랑 c.랑 같고~)을 view로 편하게 호출할 수 있음.
group by username;


-- create or replace view
-- 도서 가격이 20000이상인 레코드로 변경 (뷰를 마음껏 변경할 수 있음. 없으면 추가~ 있으면 수정~)
create or replace view v_orders
as select c.custid, username, address, price
   from book b, customer c, orders o
   where price >= 20000 and b.bookid = o.bookid;
   
   
-- 고객 구매 뷰
create or replace view v_cust_purchase
as select c.username '고객명', sum(o.saleprice) '구매액'
from customer c, orders o
where c.custid = o.custid
group by 고객명
order by 구매액 desc;                                           -- desc는 내림차순. 디폴트는 오름차순.

select * from v_cust_purchase;


-- 뷰 삭제 (삭제를 해도, 원본테이블은 변함 없음.)
drop view v_orders;
drop view v_cust_purchase;
