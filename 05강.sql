/*=======================================
 조건절 사용
 ========================================*/




use bookstore;

-- 숫자 비교
-- 가격이 22,000원 미만인 도서를 검색하시오.
select *
from  book
where price<22000;


-- 가격이 10,000 보다 크고 20,000 이하인 도서를 검색하시오.
select *
from book
where price>10000 and price<=20000;

-- between과 복합조건식 사잇값을 비교할 때 유리
select *
from book
where price between 10000 and 20000;           -- between은 이상, 이하가 기본인 것 같음. 


-- 문자 비교
-- 주문일자가 2021/02/01에서 2021/02/09인 주문을 출력
select *
from orders
where orderdate between '2021-02-01' and '2021-02-09';      -- 입력하거나 찾을 때는 문자열처럼 사용하니까 '' 따옴표 써주기. 

select *
from orders
where orderdate >= '2021-02-01' and orderdate <='2021-02-09';








-- 여러 연산자에 따른 결과
-- 도서번호가 3,4,5,6인 주문 목록을 출력
select *
from orders
where bookid in (3,4,5,6);

select *
from orders
where bookid between 3 and 6;

select *
from orders
where bookid >=3 and bookid <=6;








-- 조건 매칭(like)
-- 박씨 성을 가진 고객을 출력하시오.
select username                     -- username 컬럼만 가져옴
from customer
where username like '박%';           -- 박으로만 시작하고 뒤에 뭐가 오든 상관 없이 찾기.   %a%는 어디든지 'a'가 포함되어 있는 것 찾기. %박은 앞에 뭐가 오든 박으로만 끝나는 것 찾기.


-- 2번째 글자가 '지'인 고객을 출력하시오.
select username
from customer
where username like '_지%';         -- _는 글자수 1개를 지정함.








-- 연산자 결합
-- '썬'으로 일치하는 도서 중 가격이 5,000원 이상인 도서를 검색
select *
from book
where bookname like '%썬%' and price>=5000;


-- 출판사 이름이 '정론사' 혹은 '새미디어'인 도서를 검색
select *
from book
where publisher= '정론사' or publisher= '새미디어';                     -- 영어 하는 것마냥 publisher 중복으로 들어간다고 지우면 안됨 ㅋㅋ. ==도 오류가 남. 파이썬이랑은 다른가봄?





















/*=======================================
 Null 처리의 중요성.
 ========================================*/





-- book의 price 컬럼이 null 인 레코드를 추가해보자.
insert into book
values (11, 'SQL 기본기 다지기', 'MS출판사', null);


-- 다음 결과를 확인해보자.
-- 레코드 11번에 price에 1000을 올려서 출력
select price+1000              -- 다른 정상적인 컬럼에 넣으면 price에 1000원이 추가된 값으로 출력됨. 원본값에는 변화 없고 출력만 그렇게 되는 것.
from book
where bookid=11;



-- null인 레코드를 찾아보자. (is 비교 연산자 사용)
select *
from book
where price is null;            -- null값이 있는지 궁금한 컬럼을 꼭 지정해줘야 찾을 수 있음. 전체 다 찾으려고 * 하면 오류.




-- 비교해보자.
select *
from book
where price ='';                -- 안 나옴.


-- 집계함수 사용.
-- price 컬럼에 집계함수를 실행해보자.
select sum(price), avg(price), count(*), count(price)
from book;                                                   -- null은 모든 컬럼을 계산할 때는 나오지만, price로 지정을 했을 때는 null이 제외된 값들을 count 함. 


-- 위 결과와 아래를 비교해보자.
select sum(price), avg(price), count(*), count(price)
from book
where bookid < 11;


-- ifnull() 내장함수                                                   -- null인 경우에 null을 대체하는 값을 지정하여, 새로운 값들로 이루어진 데이터를 만들 수 있음.
select username as '이름', ifnull(phone, '연락처 없음') '전화번호'         -- username의 컬럼이름을 '이름'으로, phone의 컬럼이름을 '전화번호'로 바꿈. (select해서 나오는 컬럼에 as 별칭주기.)
from customer;


select username as '이름2', phone as '전화번호2' from customer;        -- as는 생략 가능

select ifnull(phone, '연락처 없엉') from customer;