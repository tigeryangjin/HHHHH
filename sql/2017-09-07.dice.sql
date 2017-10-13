DECLARE
  DICE_VALUE  NUMBER(1); /*���ӵ���*/
  FREQ_COUNT  NUMBER(8) := 500; /*ѭ������*/
  MATCH_COUNT NUMBER(8) := 0; /*����������ͬ�ļ���*/
  I           NUMBER(8) := 1; /*������*/
  AVG_COUNT   NUMBER;
  VALUE1      NUMBER(1);
  VALUE2      NUMBER(1);
  VALUE3      NUMBER(1);
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);
  WHILE I <= FREQ_COUNT LOOP
    SELECT TRUNC(DBMS_RANDOM.VALUE(1, 7)) INTO DICE_VALUE FROM DUAL;
    IF MOD(I, 3) = 1
    THEN
      VALUE1 := DICE_VALUE;
    ELSIF MOD(I, 3) = 2
    THEN
      VALUE2 := DICE_VALUE;
    ELSIF MOD(I, 3) = 0
    THEN
      VALUE3 := DICE_VALUE;
    END IF;
    IF VALUE1 = VALUE2 AND VALUE1 = VALUE3
    THEN
      MATCH_COUNT := MATCH_COUNT + 1;
    END IF;
    DBMS_OUTPUT.PUT_LINE('��' || I || '��,���ӵ���:' || DICE_VALUE ||
                         ' ,value_1:[' || VALUE1 || '] ,value_2:[' ||
                         VALUE2 || '] ,value_3:[' || VALUE3 || ']');
    I := I + 1;
  END LOOP;
  SELECT DECODE(MATCH_COUNT, 0, 0, FREQ_COUNT / MATCH_COUNT)
    INTO AVG_COUNT
    FROM DUAL;
  DBMS_OUTPUT.PUT_LINE('ҡ����' || FREQ_COUNT || '��,��������������ͬ����' ||
                       MATCH_COUNT || '��, ƽ��' || AVG_COUNT || '�γ��֡�');
END;
/