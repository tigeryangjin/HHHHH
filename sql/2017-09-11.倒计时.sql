WITH tmp AS
 (SELECT to_timestamp('2017-09-30 18:00:00', 'yyyy-mm-dd hh24:mi:ss') -
         systimestamp AS t
    FROM dual)
SELECT '����żٻ���: '||extract(DAY FROM(t)) || '��' || extract(hour FROM(t)) || 'Сʱ' ||
       extract(minute FROM(t)) || '��' || floor(extract(second FROM(t))) || '��' ����ʱ
  FROM tmp
