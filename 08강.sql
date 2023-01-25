/*======================
날짜
======================*/

-- 현재 날짜시간 조회
select current_timestamp();
select now();
select sysdate();
select curdate();


-- 현재 날짜형식을 출력
select date_format(now(), '%Y.%m.%d');                    -- 지정한 포멧(.)에 맞춰서 날짜 출력. Y는 2022를 출력, y는 22를 출력.
select date_format(curdate(), '%m-%d, %Y');


-- orderdate 컬럼을 특정 형식(포멧)의 문자열로 변환하여 출력하기.
select date_format(orderdate, '%Y.%m.%d') from orders;


-- 문자열 날짜 데이터 형식을 date 형식으로
select cast('2022-10-27 09:55:05:' as date) as 'date 형식';                 -- cast('바꾸고 싶은 데이터' as 바꾸고 싶은 형식)
select cast(orderdate as datetime) as 'orderdate 활용' from orders;     -- 시분초까지 필요하다면 datetime. 




-- 날짜 및 시간 더하기/빼기
-- 기준날짜로부터 하루 뒤 날짜 조회
select adddate(now(), interval 1 day);
select subdate(now(), interval -1 day);


-- 기준날짜로부터 22일 전 날짜 조회
select adddate(now(), interval -22 day);
select subdate(now(), interval 22 day);

select adddate('1998-06-09', interval 10000 day);


-- order 테이블에서 주문일자의 한달 날짜 계산
select adddate(orderdate, interval 1 month) from orders;
select orderdate, date_add(orderdate, interval 1 month) from orders;         -- orderdate와 비교해보기 (adddate나 date_add나 같은 값 출력)


-- 분기
select quarter(orderdate) from orders;


-- orderdate에 3개월을 더한 분기 계산
select quarter(adddate(orderdate, interval 3 month)) as '분기' from orders;