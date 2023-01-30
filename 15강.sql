/*======================
기본 통계
======================*/

-- 고객의 전체 주문횟수, 합계, 평균, 최소/최대 구매액을 조회하시오. (join 사용)
select username '고객명',
	   count(saleprice) '주문횟수',
       format(sum(saleprice),0) '합계',                         -- sum은 정수였지만, 0(정수)을 지정해주면 쉼표(,)가 생김.
       format(avg(saleprice),1) '평균',                         -- format (x,d) x형식의 문자열~을 소수점 d자리수로 맞춘다. 날짜 형식으로도 가능.
       min(saleprice) '최소 구매액',
       max(saleprice) '최대 구매액'
from customer c
join orders o on c.custid = o.custid
group by 1;


-- 년도별 주문량, 주문 합계, 평균, 최대 및 최소 값을 계산하시오. 
select year(orderdate) '년도',
       count(saleprice) '주문횟수',
       format(sum(saleprice),0) '합계',                    
       format(avg(saleprice),1) '평균',                         -- 소수점을 나타내는 것은 round로도 가능(쉼표 X). 하지만 format을 하면 쉼표까지 표시됨.
       min(saleprice) '최소 구매액', 
       max(saleprice) '최대 구매액'
from orders o
group by 년도;


-- 주문 금액의 합계, 평균, 최소, 최대, 분산, 표준편차 
select format(sum(saleprice),0) '합계',
	   format(avg(saleprice),1) '평균',
       min(saleprice) '최소',
       max(saleprice) '최대',
       format(variance(saleprice),1) '분산',                      -- variance 분산
       format(std(saleprice),1) '표준편차'                         -- std 표준편차
from orders;








/*======================
사분위수
======================*/

-- group_concat 함수로 데이터를 합쳐서 분위수에 해당하는 수치를 구해 substring_index함수로 데이터를 추출하는 방법이다. 
-- 합쳐지는 데이터가 많을 경우 꼭 set group_concat_max_len = 10485760; 와 같은 설정이 필요함




-- 가격 개수를 이용한 사분위수

-- 1단계
-- group_concat(컬럼이름 separator '구분자') : 컬럼 값을 '구분자'로 분리하여 한 줄로 결합
select publisher, group_concat(bookname separator ',')
from book
group by 1;                                                    -- 출판사별로 가지고 있는 도서들을 한 행에 정리. 


-- 2단계: 
-- 모든 가격을 결합한다.
select group_concat(saleprice order by saleprice , '..' )       -- 한 컬럼을 가지고 결합할 때는 이렇게. 정렬을 먼저 시키고 구분하기~ 합쳐진 이후에는 정렬을 할 수 없음..
from orders;


-- 3단계: 전체 레코드 수를 25%~100% 까지 계산해 본다.
select 25/100 * count(saleprice) '25%',
       50/100 * count(saleprice) '50%',
       75/100 * count(saleprice) '75%',
       count(saleprice) '100%'
from orders;


-- 4단계: 
-- substring_index(문자, 구분자, count) : 문자열을 구분자로 분리해서 배열로 만든 후 count 만큼만 보여준다.
-- count 가 양수값이면 처음부터 count만큼 보여주고 음수값이면 마지막부터 count만큼 보여준다.
select substring_index('안녕.하세요', '.', 1);
select substring_index('안녕.하세요', '.', -1);


-- 5단계: final
select min(saleprice) 'min',
       substring_index
       (substring_index(group_concat(saleprice order by saleprice separator ','), ',', count(saleprice) * 25/100)
       ,',',-1) '25%',                        -- -1을 한 이유는 최소의 최대값을 구하려고.
       substring_index
       (substring_index(group_concat(saleprice order by saleprice separator ','), ',', count(saleprice) * 50/100)
       ,',',-1) '50%',
       format(avg(saleprice),1) '평균',
       substring_index
       (substring_index(group_concat(saleprice order by saleprice separator ','), ',', count(saleprice) * 75/100)
       ,',',-1) '75%',
       max(saleprice) 'max'
from orders;




-- 전체 가격 범위 표현 (판매가들의 합산 가격을 사분위로 표현)
select min(saleprice) 'min',
	   format(sum(saleprice) * 25/100, 1) '25%',
       format(sum(saleprice) * 50/100, 1) '50%',
       format(avg(saleprice), 1) 'mean',
       format(sum(saleprice) * 75/100, 1) '75%',
       sum(saleprice) 'sum'
from orders;
