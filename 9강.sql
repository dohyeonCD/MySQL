/*======================
서브쿼리
======================*/

-- 새 테이블에서 테스트(lecture)
-- 샘플 테이블과 데이터
create table product(
code int, 
name varchar(20),
price int
);

insert into product values(1, '녹차', 2300);
insert into product values(2, '홍차', 3000);
insert into product values(3, '유자차', 1800);
insert into product values(4, '보리차', 2500);


-- 아래는 오류 발생(where은 찾기만 할 수 있어서, 저기에 함수를 넣거나 하면 오류 발생)
select * from product
where avg(price)> 2000;

-- 평균을 구하는 방법.
select avg(price) from product;


-- 서브쿼리
-- 제품 판매 가격이 평균보다 큰 제품은?
select * from product
where price > (select avg(price) from product);


-- 이름별로 제품을 분류하여, 최고가격이 평균가보다 낮은 제품을 구하시오. 
select name, max(price) 
from product group by name
having max(price) < (select avg(price) from product);           -- having 구문은 공통적인 데이터들이 묶여진 그룹 중, 주어진 주건에 맞는 그룹들을 추출




-- inline view (view는 임시 테이블 역할. 서브쿼리 결과를 from에 사용.)
-- 가격이 2000원 이상인 제품들 중에 최고가를 구하시오.
select max(price)
from (select * from product 
where price > 2000) as c_price ;     -- 서브쿼리로 임시 테이블을 만들고(c_price) 그 임시테이블을 from에 사용. 

select * from product                -- 이런식의 데이터를 임시 테이블로 지정한다는 뜻. 
where price > 2000;


select max(price) from product       -- 이렇게 해도 출력이 되긴 함. 하지만 이건 임시 테이블을 사용하지 않고, product 테이블을 사용한 것. 
where price > 2000;     




-- safe updates
set sql_safe_updates=0;               -- safe_updates 옵션 해제.
update product set price=3000;        -- 모든 price를 3000으로 지정하려고 함. 이런 실수를 막아주는 게 safe_updates. 


-- 모든 레코드 삭제
delete from product;                   -- 테이블 구조는 남겨두고, values만 삭제
drop table product;                    -- 테이블 자체를 삭제. safe_updates가 1이어도 삭제됨. 




-- 상관부속질의(메인쿼리와 서브쿼리의 컬럼이 서로 관계를 맺음.)
use bookstore;

-- 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오. (평균이어서 1개씩 있는 출판사는 출력되지 않음.)
select * from book b1
where b1.price > (select avg(b2.price) 
                  from book b2 
                  where b1.publisher = b2.publisher);       -- where을 안 해주면, 모든 price의 평균 구함-> 잘못된 결과 추출됨.
                                                            -- where 조건을 넣으면 평균을 구한 b2를 복사본 b1의 publisher끼리 같도록 하여, 
                                                            -- b1의 모든 publisher의 평균(b2)을 구하는 것. 


select publisher, price from book group by publisher        -- group by를 하면 publisher의 도서들을 최소값으로 그룹핑을 함...(오름차순때문인가..?)
having price > (select avg(price) from book);               -- 모든 price의 평균 구함-> 평균가를 넘는 도서들 중 출판사별로 제일 싼 도서를 추출...
