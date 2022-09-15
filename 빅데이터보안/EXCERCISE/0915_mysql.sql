use testdb_ewhabs2;
create table countries(
	COUNTRY_ID varchar(2),
    COUNTRY_NAME varchar(40),
    REGION_ID decimal(10,0)
);
desc countries;

/*task2 - 중복 테이블 여부 조사 후 테이블 생성*/
create table if not exists dup_countries like countries(
	COUNTRY_ID varchar(2),
    COUNTRY_NAME varchar(40),
    REGION_ID decimal(10,0)
);

/*task3 - 테이블 구조 복사*/
create table if not exists dub_countries like countries;

/*task4 - 테이블 구조와 데이터 복사*/
create table if not exists dup_countries select * from countries;

/*task 5 - not null*/
create table countries2(
	COUNTRY_ID varchar(2) not null,
    COUNTRY_NAME varchar(40) not null,
    REGION_ID decimal(10,0) not null
);

/*task 6 - create table*/
create table jobs(
	JOB_ID varchar(10) not null,
    JOB_TITLE varchar(35) not null,
    MIN_SALARY decimal(6,0),
	MAX_SALARY decimal(6,0) ,
    check(MAX_SALARY<=2500)
);

desc jobs;

/*task 7 - 데이터 삼입*/
insert into countries(COUNTRY_ID, COUNTRY_NAME, REGION_ID) values ('C1', 'India', 1001);
insert into countries values('C2', 'India-1',1001);
select * from countries;

/*task 8 - 데이터 두개만 삽입*/
insert into countries(COUNTRY_ID, COUNTRY_NAME) values ('C1', 'India');
select * from countries;

/*task 9 - 3개의 값 삽입*/
show databases;
insert into countries value('C1','India',1001),('C2','USA',1007),('C3','UK',1003);
select * from countries;

/*task 10 - 테이블 생성한 뒤 region_id 열 추가*/
create table locations(
	LOCATION_ID decimal(4,0),
    STREET_ADDRESS varchar(40),
    POSTAL_CODE varchar(12),
    CITY varchar(30),
    STATE_PROVINCE varchar(25),
    COUNTRY_ID varchar(2)
);

alter table locations add column region_id int(11);
desc locations;

