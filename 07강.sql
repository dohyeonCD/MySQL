/*======================
SQL 연산
======================*/

select 1;
select 1+1;
select 0.1;
select 100+0.2;                 -- 실수랑 연산을 하면 실수가 가지는 데이터의 범위가 커서 실수형으로 반환이 됨.
select 100/20 as 'result';    -- 컬럼의 이름을 바꿀 수 있음. 나누기는 실수로 변환이 되는듯?
select 5.0/2;
select 1+1 as 'plus', 100/20, 5.0/2 as 'division';


-- book 테이블의 price에 0.05를 곱한다.
select price*0.05 from book;


-- book 테이블의 price에 2를 나누고 결과에 100을 곱한다.
select (price/2)*100 from book;                     -- 우선순위는 ()로 묶음.


-- 비교연산(참이면 1, 거짓이면 0)
select 1>100;
select 1<100;
select 10=10;
select 101<>100;            -- <>는 같지 않다는 뜻.
select 101!=100;


-- 논리연산
select (10<100) and (10=10);
select (10>100) and (10=10);
select (10>100) or (10=10);        -- or은 둘 중 하나만 참이 있어도 참.
select (10>100) or (10!=10);   
select not (10!=10);










/*======================
내장함수
======================*/

-- 북스토어의 도서 판매 건수를 구하시오.
select count(*) from orders;      -- count 에서 와일드카드('*')를 사용하는 이유는 null 값 때문. *를 하면 null 값까지 같이 카운트되지만, 컬럼을 지정하면 null 값이 제외됨.


-- 고객이 주문한 도서의 총 판매액을 구하시오.
select sum(saleprice) from orders;

-- 숫자열이 아닐 때 sum
select sum(bookname) from book;   -- 오류는 안 나지만 전혀 다른 결과 도출.... sum은 숫자형태로 있을 때에만 정확한 결과가 출력됨.


-- 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가를 구하시오.
select sum(saleprice) as '총 판매액',
avg(saleprice) as '평균값',
min(saleprice) as '최저가',
max(saleprice) as '최고가'
from orders;










/*======================
문자열
======================*/

-- trim() : 문자열 좌우 공백 제거
select trim('     안녕하세요     ');


-- ltrim() : 문자열 좌측 공백 제거
select ltrim('     안녕하세요     ');


-- rtrim() : 문자열 우측 공백 제거
select rtrim('     안녕하세요     ');


-- (leading) : 문자열 좌측 문자 제거
select trim(leading '안' from '안안안녕하세요안');           -- from 뒤에 있는 문자열 중에 해당하는 ''문자열을 좌측에서 다 지워줌.


-- (trailing) : 문자열 우측 문자 제거
select trim(trailing '요' from '요안녕하세요요요'); 




-- length : 문자열 갯수 세기.
-- byte 단위
select length('hello hi');   
select length('안녕');              -- 글자 하나하나당 1byte임.

-- 문자 단위
select char_length('hello hi');  
select char_length('안녕');
select character_length('안녕');




-- 문자열 변환
-- upper() : 대문자로 변환
select upper('Happy');


-- lower() : 소문자로 변환
select lower('Happy');




-- 문자열 결합(concat)
select concat('홍길동','모험');                  -- 고냥고냥 붙여버림~

select concat_ws(',', '홍길동','모험');       -- 구분자를 두고(',') 문자열을 결합.
select concat_ws('-', '2022','10','27');


select concat('도서명: ', bookname) from book;


-- book 테이블에서 도서이름과 출판사를 ':'로 연결해 출력
select concat_ws(':', bookname, publisher) from book;


-- 위와 아래의 결과를 비교해보자.
select bookname, ':', publisher from book;




-- 문자열 추출
select substring('안녕하세요', 2,3);                        -- 2번 위치부터 3글자 추출. mid()와 동일.

select substring_index('안.녕.하.세.요', '.', 4);        -- 문자열을 '.' 구분자로 분리하여, index 위치까지 추출.
select substring_index('안.녕,하.세.요', ',', 1);        -- ','를 기준으로 1, 2번 index로 분리되고, 거기서 1번 인덱스를 추출.


select left('안녕하세요', 2);
select right('안녕하세요', 3);