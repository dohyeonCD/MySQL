-- unsafe update 호출 (booklibrary 테이블 안에 있는 bookname이 모두 '대한민국 부산'으로 바뀔 위험이 있음)
update booklibrary
set    bookname='대한민국 부산';


-- unsafe 해제
-- 1. 업데이트 구문 + 조건절을 설정 (광범위하게~. 서버가 시작하는 시점부터 해제시키는 방법.)   
-- 2. 무조건 조건절(where) 사용.(사용할 때마다)
set sql_safe_updates=0;


update booklibrary
set    bookname='대한민국 부산'
where  custid=5;               -- 조건절 다는 게 안전하긴 함.




--  root 계정으로 접속-> bookstore 데이터베이스 생성-> 샘플 데이터 삽입

-- 자료 생성
 
USE bookstore;

CREATE TABLE Book  (
  bookid      INTEGER PRIMARY KEY,
  bookname    VARCHAR(40),
  publisher   VARCHAR(40),
  price       INTEGER 
);

CREATE TABLE  Customer (
  custid      INTEGER PRIMARY KEY,  
  username    VARCHAR(40),
  address     VARCHAR(50),
  phone       VARCHAR(20)
);



CREATE TABLE Orders (
  orderid INTEGER PRIMARY KEY,
  custid  INTEGER ,
  bookid  INTEGER ,
  saleprice INTEGER ,    -- 구매 총액
  orderdate DATE,        -- 날짜 형식. 입력을 할 때는 문자형태로 쓰지만, str_to_date 함수를 사용해야 함. 
  FOREIGN KEY (custid) REFERENCES Customer(custid),     -- 외부 테이블과 관계를 맺음. customer의 custid가 변경이 되면, orders의 custid도 자동으로 변경이 됨.
  FOREIGN KEY (bookid) REFERENCES Book(bookid)
);




-- insert bulk. 대량의 데이터를 삽입하는 것. 


INSERT INTO Book VALUES(1, '철학의 역사', '정론사', 7500);                  -- insert into 다음의 해당테이블에 values 값들이 삽입. 컬럼의 순서대로 자동으로 입력됨.
-- INSERT INTO Book(bookid, bookname) VALUES(1, '철학의 역사')        -- 해당하는 컬럼에만 값을 넣고 싶을 때는 이런 방식으로. 


INSERT INTO Book VALUES(2, '3D 모델링 시작하기', '한비사', 15000);
INSERT INTO Book VALUES(3, 'SQL 이해', '새미디어', 22000);
INSERT INTO Book VALUES(4, '텐서플로우 시작', '새미디어', 35000);
INSERT INTO Book VALUES(5, '인공지능 개론', '정론사', 8000);
INSERT INTO Book VALUES(6, '파이썬 고급', '정론사', 8000);
INSERT INTO Book VALUES(7, '객체지향 Java', '튜링사', 20000);
INSERT INTO Book VALUES(8, 'C++ 중급', '튜링사', 18000);
INSERT INTO Book VALUES(9, 'Secure 코딩', '정보사', 7500);
INSERT INTO Book VALUES(10, 'Machine learning 이해', '새미디어', 32000);

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '010-1234-1010');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '010-1223-3456');  
INSERT INTO Customer VALUES (3, '장미란', '대한민국 강원도', '010-4878-1901');
INSERT INTO Customer VALUES (4, '추신수', '대한민국 부산', '010-8000-8765');
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전',  NULL);


INSERT INTO Orders VALUES (1, 1, 1, 7500, STR_TO_DATE('2021-02-01','%Y-%m-%d'));        -- 날짜는 무조건 '-'로 구분됨. 연도는 Y 대문자로.
INSERT INTO Orders VALUES (2, 1, 3, 44000, STR_TO_DATE('2021-02-03','%Y-%m-%d'));
INSERT INTO Orders VALUES (3, 2, 5, 8000, STR_TO_DATE('2021-02-03','%Y-%m-%d')); 
INSERT INTO Orders VALUES (4, 3, 6, 8000, STR_TO_DATE('2021-02-04','%Y-%m-%d')); 
INSERT INTO Orders VALUES (5, 4, 7, 20000, STR_TO_DATE('2021-02-05','%Y-%m-%d'));
INSERT INTO Orders VALUES (6, 1, 2, 15000, STR_TO_DATE('2021-02-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (7, 4, 8, 18000, STR_TO_DATE( '2021-02-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (8, 3, 10, 32000, STR_TO_DATE('2021-02-08','%Y-%m-%d')); 
INSERT INTO Orders VALUES (9, 2, 10, 32000, STR_TO_DATE('2021-02-09','%Y-%m-%d')); 
INSERT INTO Orders VALUES (10, 3, 8, 18000, STR_TO_DATE('2021-02-10','%Y-%m-%d'));





select * from book;          -- select 컬럼이름을 하거나 all(*) from 테이블 이름. 
select * from customer;
select * from orders;