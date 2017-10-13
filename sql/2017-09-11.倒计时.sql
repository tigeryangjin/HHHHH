WITH tmp AS
 (SELECT to_timestamp('2017-09-30 18:00:00', 'yyyy-mm-dd hh24:mi:ss') -
         systimestamp AS t
    FROM dual)
SELECT '距离放假还有: '||extract(DAY FROM(t)) || '天' || extract(hour FROM(t)) || '小时' ||
       extract(minute FROM(t)) || '分' || floor(extract(second FROM(t))) || '秒' 倒计时
  FROM tmp
