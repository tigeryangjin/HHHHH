select e.value1, (e.value2 - trunc(e.value2)) + (trunc(e.value2) * 1e-38)
  from (select d.value1, d.value2 * 1e24 value2
          from (select c.value1, c.value2 - trunc(c.value2) value2
                  from (select b.value1,
                               b.value2 * 1e-38 +
                               54 * .01020304050607080910111213141516171819 value2
                          from (select a.value1,
                                       to_number(nvl(ascii(substr(a.value2,
                                                                  1,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  2,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  3,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  4,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  5,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  6,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  7,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  8,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  9,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  10,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  11,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  12,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  13,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  14,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  15,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  16,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  17,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  18,
                                                                  1)),
                                                     0.0) ||
                                                 nvl(ascii(substr(a.value2,
                                                                  19,
                                                                  1)),
                                                     0.0)) value2
                                  from (select dbms_random.value value1,
                                               substr(TO_SINGLE_BYTE(TO_CHAR(SYSDATE,
                                                                             'MM-DD-YYYY HH24:MI:SS') || USER ||
                                                                     USERENV('SESSIONID')),
                                                      1,
                                                      19) value2
                                          from dual) a) b) c) d) e;
