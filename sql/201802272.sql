--create table alphabet_tmp (c varchar2(1));

insert into alphabet_tmp values ('A');
commit;
insert into alphabet_tmp values ('B');
commit;
insert into alphabet_tmp values ('C');
commit;
insert into alphabet_tmp values ('D');
commit;
insert into alphabet_tmp values ('E');
commit;
insert into alphabet_tmp values ('F');
commit;
insert into alphabet_tmp values ('G');
commit;
insert into alphabet_tmp values ('H');
commit;
insert into alphabet_tmp values ('J');
commit;
insert into alphabet_tmp values ('K');
commit;
insert into alphabet_tmp values ('L');
commit;
insert into alphabet_tmp values ('M');
commit;
insert into alphabet_tmp values ('N');
commit;
insert into alphabet_tmp values ('P');
commit;
insert into alphabet_tmp values ('Q');
commit;
insert into alphabet_tmp values ('R');
commit;
insert into alphabet_tmp values ('S');
commit;
insert into alphabet_tmp values ('T');
commit;
insert into alphabet_tmp values ('U');
commit;
insert into alphabet_tmp values ('V');
commit;
insert into alphabet_tmp values ('W');
commit;
insert into alphabet_tmp values ('X');
commit;
insert into alphabet_tmp values ('Y');
commit;
insert into alphabet_tmp values ('Z');
commit;

SELECT row_number() over(order by A.C || B.C || C.C || D.C || E.C) rn,
       A.C || B.C || C.C || D.C || E.C str
  FROM alphabet_tmp A,
       alphabet_tmp B,
       alphabet_tmp C,
       alphabet_tmp D,
       alphabet_tmp E;

--create table alphabet_tmp1(s number);

declare
  in_quantity number := 24 * 24 * 24 * 24 * 24;
  in_count    number := 0;
  cur_int     number;
  is_exists   number(1);
begin
  while in_count < in_quantity loop
    select trunc(dbms_random.value(1, in_quantity))
      into cur_int
      from dual;
    select count(1)
      into is_exists
      from alphabet_tmp1 a
     where a.s = cur_int;
    if is_exists = 0
    then
      insert into alphabet_tmp1 values (cur_int);
      commit;
      in_count := in_count + 1;
    end if;
  end loop;
end;
/

drop table alphabet_tmp1;
drop table alphabet_tmp;
