/*======================
순위
======================*/
-- SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES';           -- group by 할 때 발생하는 에러코드 1055 해결방법.


-- 도서 주문 가격별 랭킹
-- rank() over : (공동 순위만큼 건너뜀. 1,2,2,4,5)
select bookname, saleprice,                                   
       rank() over(order by saleprice) '랭킹'                 -- order by로 순위를 매길 컬럼 지정. (정렬하고 순위 매기는 거)
from book b, orders o
where b.bookid = o.bookid
group by 1;                                                  -- 도서 중복 안되게(판매 수량과 상관없이 가격만으로 비교할 수 있도록)~
           

-- dense_rank() over : (공동 순위를 건너뛰지 않음. 1,2,2,3,4)
select bookname, saleprice,
       dense_rank() over(order by saleprice) '랭킹'
from book b, orders o
where b.bookid = o.bookid
group by 1;


-- row_number() over : (공동 순위를 무시함. 1,2,3,4,5)
select bookname, saleprice, 
       row_number() over(order by saleprice) '랭킹'
from book b, orders o
where b.bookid = o.bookid
group by 1;



-- 고객별 주문한 도서들의 가격 랭킹 (1번 고객이 주문한 도서들의 가격 랭킹~ 2번 ~~)
select o.custid, bookname, saleprice,
	   dense_rank() over (partition by o.custid order by saleprice) '랭킹'           -- partition by로 그룹화할 컬럼을 지정해 집합 만들 수 있음. 
from book b, orders o
where b.bookid = o.bookid
group by 2;









/*======================
rollup을 이용한 소계(한 부분의 합계)
======================*/

-- 방법1 : group by rollup(그룹컬럼)              이 방법은 MySQL에서 안됨.
-- 방법2 : group by 그룹컬럼 with rollup          MYSQL에서는 이 방법 사용.
 
 
-- 지역별로 판매된 도서의 수량을 조회하자.
select address '주소', bookname '도서명', count(saleprice) '수량'
from customer c, book b, orders o
where c.custid = o.custid and b.bookid = o.bookid
group by address with rollup;                         -- (그냥 group by c.address와 차이점: null 값 포함, 자동 ㄱㄴㄷ순 정렬)


-- having 그룹컬럼 is not null (null 값 제외됨.)
select address '주소', bookname '도서명', count(saleprice) '수량'
from customer c, book b, orders o
where c.custid = o.custid and b.bookid = o.bookid
group by address with rollup
having address is not null;
