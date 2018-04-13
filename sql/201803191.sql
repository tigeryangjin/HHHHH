declare
  val     varchar2(50);
  junk    varchar2(2000);
  piece   varchar2(20);
  randval number;
  j       binary_integer;
  mytemp  number;
  type num_array is table of number index by binary_integer;
  mem num_array;
begin
  val  := to_char(sysdate, 'MM-DD-YYYY HH24:MI:SS') || user ||
          userenv('SESSIONID');
  junk := to_single_byte(val);
  for i in 0 .. 54 loop
    piece   := substr(junk, 1, 19);
    randval := 0;
    j       := 1;
    for j in 1 .. 19 loop
      randval := 1e2 * randval + nvl(ascii(substr(piece, j, 1)), 0.0);
    end loop;
    randval := randval * 1e-38 +
               i * .01020304050607080910111213141516171819;
    mem(i) := randval - trunc(randval);
    junk := SUBSTR(junk, 20);
  end loop;
  --.55096418732782369146005509641873278226
  randval := mem(54);
  FOR j IN 0 .. 10 LOOP
    FOR i IN 0 .. 54 LOOP
    
      -- barrelshift mem(i-1) by 24 digits
      randval := randval * 1e24;
      mytemp  := TRUNC(randval);
      randval := (randval - mytemp) + (mytemp * 1e-38);
    
      -- add it to mem(i)
      randval := mem(i) + randval;
      IF (randval >= 1.0)
      THEN
        randval := randval - 1.0;
      END IF;
    
      -- record the result
      mem(i) := randval;
    
    END LOOP;
  END LOOP;
  dbms_output.put_line(mem(0));
end;
