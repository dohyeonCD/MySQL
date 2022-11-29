show variables;

show variables like 'char_%';

show databases;

use world;

show tables;

--
drop database lecture;

show databases;

create database lecture;

use lecture;

show tables;



-- booklibrary 테이블 생성

create table booklibrary (
bookid     integer,
bookname   varchar(20), 
publisher  varchar(20), 
price      integer
);

drop table booklibrary;              -- 주구장창 이거 재사용할 수 있음 ㅋㄷㅋㄷ



-- 제약조건

create table booklibrary (
bookid     integer,
bookname   varchar(20), 
publisher  varchar(20), 
price      integer,
primary key (bookid)
);

create table booklibrary (
bookid     integer primary key,
bookname   varchar(20), 
publisher  varchar(20), 
price      integer
);

create table booklibrary (
bookid     integer,
bookname   varchar(20), 
publisher  varchar(20), 
price      integer,
primary key (bookid, bookname)      -- 복합키 설정할 때는 따로 이렇게 묶어서 처리해야 함.
);

-- bookname은 null 값을 가질 수 없고, publisher는 같은 값이 있으면 안되도록.
-- price에 값이 입력되지 않으면 기본값은 10,000으로 하고, 최소 5,000 이상이 되도록.

create table booklibrary (
bookid     integer,
bookname   varchar(20) not null, 
publisher  varchar(20) unique, 
price      integer default 10000 check(price>5000),
primary key (bookid, bookname)  
);

-- booklibrary 테이블에 varchar(30)의 자료형을 가진 inventory 속성을 추가하시오.

alter table booklibrary add inventory varchar(30);

-- integer형으로 변경하시오.

alter table booklibrary modify inventory integer;

-- inventory 속성을 삭제하시오.

alter table booklibrary drop column inventory;
