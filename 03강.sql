show variables;

show variables like 'char_%';

show databases;




/* user1 계정 생성 (쿼리 작성으로 만드는 방법)
MySQL Workbench에서 초기화면에서 +를 눌러 root connection을 만들어 접속한다.
DROP DATABASE IF EXISTS  bookstore;
DROP USER IF EXISTS  user1@localhost;

create user user1@localhost identified WITH mysql_native_password  by '012345';
create database bookstore;
grant all privileges on user1.* to user1@localhost with grant option;
commit;
*/




use world;

show tables;


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
price      integer default 10000 check(price>=5000),
primary key (bookid, bookname)  
);




describe booklibrary;                     -- 이걸로 테이블의 세부내용을 출력할 수 있음.




-- booklibrary 테이블에 varchar(30)의 자료형을 가진 inventory 컬럼을 추가하시오.

alter table booklibrary add inventory varchar(30);


-- integer형으로 변경하시오.

alter table booklibrary modify inventory integer;


-- inventory 속성을 삭제하시오.

alter table booklibrary drop column inventory;