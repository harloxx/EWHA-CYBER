create database test_encrypt;
use test_encrypt;
drop table if exists `encrypt_test`;

-- 1. create mew table
create table `encrypt_test`(
`user_id` varchar(100) not null,
`password` varchar(100) not null
);

select * from `encrypt_test`;

-- 2. lock tabes 'encrypt_test' write;
insert into `encrypt_test` values('userA',hex(aes_encrypt('testpw1','a')));
insert into `encrypt_test` values('userB',hex(aes_encrypt('testpw2','b')));
insert into `encrypt_test` values('userC',hex(aes_encrypt('testpw3','c')));

select * from `encrypt_test`;

-- 3. decrypt values
select user_id, cast(aes_decrypt(unhex('password'),'a') as char) from `encrypt_test`;
