SELECT 88           FILTER_ID,
       C.MEMBER_KEY MEMBER_BP,
       D.VID        VID,
       D.OPEN_ID    OPENID,
       D.PUSH_ID    PUSHID
  FROM (SELECT DISTINCT A.MEMBER_KEY
          FROM MEMBER_LABEL_LINK A
         WHERE (M_LABEL_ID = 223 OR M_LABEL_ID = 224 OR M_LABEL_ID = 225)
           AND EXISTS (SELECT 1
                  FROM MEMBER_LABEL_LINK A1
                 WHERE A1.MEMBER_KEY = A.MEMBER_KEY
                   AND _NOT_IN(M_LABEL_ID = 401))
           AND EXISTS (SELECT 1
                  FROM MEMBER_LIKE_MATXL_SYN M
                 WHERE M.MEMBER_KEY = A.MEMBER_KEY
                   AND M.MATXL IN (450101,
                                   450102,
                                   450103,
                                   450104,
                                   450105,
                                   450106,
                                   450107,
                                   450201,
                                   450202,
                                   450301,
                                   450302,
                                   450303,
                                   450401,
                                   450402,
                                   450501,
                                   450502,
                                   510601,
                                   510602))) C,
       ML_MEMBER_MAPPING_SYN D
 WHERE C.MEMBER_KEY = D.MEMBER_KEY(+);

SELECT 88           FILTER_ID,
       C.MEMBER_KEY MEMBER_BP,
       D.VID        VID,
       D.OPEN_ID    OPENID,
       D.PUSH_ID    PUSHID
  FROM (SELECT DISTINCT A.MEMBER_KEY
          FROM MEMBER_LABEL_LINK A
         WHERE (M_LABEL_ID = 223 OR M_LABEL_ID = 224 OR M_LABEL_ID = 225)
           AND NOT EXISTS (SELECT 1
                  FROM MEMBER_LABEL_LINK A1
                 WHERE A1.MEMBER_KEY = A.MEMBER_KEY
                   AND M_LABEL_ID = 401)
           AND EXISTS (SELECT 1
                  FROM MEMBER_LIKE_MATXL_SYN M
                 WHERE M.MEMBER_KEY = A.MEMBER_KEY
                   AND M.MATXL IN (450101,
                                   450102,
                                   450103,
                                   450104,
                                   450105,
                                   450106,
                                   450107,
                                   450201,
                                   450202,
                                   450301,
                                   450302,
                                   450303,
                                   450401,
                                   450402,
                                   450501,
                                   450502,
                                   510601,
                                   510602))) C, 
       ML_MEMBER_MAPPING_SYN D
 WHERE C.MEMBER_KEY = D.MEMBER_KEY(+);
