--1.
SELECT P.*
/*BULK COLLECT
INTO VAR_ARRAY*/
  FROM (SELECT A.MEMBER_KEY
          FROM FACT_VISITOR_REGISTER A
         WHERE A.MEMBER_KEY <> 0
           AND A.CREATE_DATE_KEY = &IN_POSTING_DATE_KEY
         GROUP BY A.MEMBER_KEY) P
 WHERE NOT EXISTS (SELECT 1
          FROM MEMBER_LABEL_LINK B
         WHERE B.M_LABEL_ID BETWEEN 42 AND 47
           AND P.MEMBER_KEY = B.MEMBER_KEY);

--2.
SELECT --MEMBER_LABEL_LINK_SEQ.NEXTVAL,
 ORD.MEMBER_KEY,
 MLH.M_LABEL_ID,
 MLH.M_LABEL_TYPE_ID,
 SYSDATE CREATE_DATE,
 'yangjin' CREATE_USER_ID,
 SYSDATE LAST_UPDATE_DATE,
 'yangjin' LAST_UPDATE_USER_ID
  FROM (SELECT A.MEMBER_KEY,
               A.ORDER_KEY,
               MIN(A.GOODS_COMMON_KEY) GOODS_COMMON_KEY,
               A.ORDER_AMOUNT
          FROM FACT_GOODS_SALES A
         WHERE A.ORDER_STATE = 1
           AND A.GOODS_COMMON_KEY IS NOT NULL
           AND EXISTS
         (SELECT 1
                  FROM (SELECT C.MEMBER_KEY, MIN(C.ORDER_KEY) ORDER_KEY
                          FROM FACT_GOODS_SALES C
                         WHERE C.ORDER_STATE = 1
                           AND C.GOODS_COMMON_KEY IS NOT NULL
                         GROUP BY C.MEMBER_KEY) B
                 WHERE A.MEMBER_KEY = B.MEMBER_KEY
                   AND A.ORDER_KEY = B.ORDER_KEY)
           AND EXISTS (SELECT 1
                  FROM (SELECT C.MEMBER_KEY,
                               C.ORDER_KEY,
                               MAX(C.ORDER_AMOUNT) ORDER_AMOUNT
                          FROM FACT_GOODS_SALES C
                         WHERE C.ORDER_STATE = 1
                           AND C.GOODS_COMMON_KEY IS NOT NULL
                         GROUP BY C.MEMBER_KEY, C.ORDER_KEY) D
                 WHERE A.MEMBER_KEY = D.MEMBER_KEY
                   AND A.ORDER_KEY = D.ORDER_KEY
                   AND A.ORDER_AMOUNT = D.ORDER_AMOUNT)
           AND A.MEMBER_KEY IN (1401632327,
                                1620017388,
                                1613937310,
                                1501451683,
                                603009225,
                                709350322,
                                1101235532,
                                1500458631,
                                1500505717,
                                1622775963,
                                1007439638,
                                1500252777,
                                1622784222,
                                609092821,
                                1622784491,
                                1622788473,
                                1500367203,
                                1612906957,
                                1622777642,
                                1622789331,
                                1622787753,
                                1500835189,
                                1622449004,
                                1006525068,
                                1500384467,
                                1622789526,
                                1212267996,
                                1303577444,
                                701136501,
                                1106606463,
                                1404829173,
                                1622777088,
                                1622774863,
                                1611055922,
                                1622780293,
                                811808484,
                                1622773691,
                                905988719,
                                1620735260,
                                1622784873,
                                1622783760,
                                1622774180,
                                1614478845,
                                1411404853,
                                1304718788,
                                606046160,
                                1002423893,
                                1301414232,
                                1622774535,
                                1203421527,
                                1501935464,
                                808722786,
                                1622786501,
                                1617831579,
                                1622715895,
                                905986378,
                                1501407881,
                                1622773721,
                                1622778032,
                                1621435633,
                                1500707932,
                                901868731,
                                1622778472,
                                708345936,
                                812838965,
                                1202340520,
                                607054955,
                                1622775662,
                                1500850845,
                                1622774810,
                                1407093289,
                                1604991945,
                                1614158860,
                                1501160279,
                                1622786675,
                                1622775332,
                                1622776436,
                                1607976130,
                                1501196885,
                                1501278321,
                                1414125825,
                                1622783375,
                                1500833185,
                                1310163982,
                                1403785879,
                                1622773765,
                                1622699562,
                                1405899858,
                                1617663190,
                                1500801344,
                                1500444030,
                                1501012837,
                                1612432067,
                                1622399523,
                                1501494717,
                                1622774407,
                                1622773824,
                                1603042495,
                                1500923366,
                                1622780174,
                                1406959978,
                                1403768432,
                                1611045341,
                                1622780833,
                                1606979372,
                                811804402,
                                1622764367,
                                1107648663,
                                1622773925,
                                1622786620,
                                1610566254,
                                1501157794,
                                1622784565,
                                1622775345,
                                1622782956,
                                1622773127,
                                1406011894,
                                1622789274,
                                1622699919,
                                1500412405,
                                1501119213,
                                1304678040,
                                1622768394,
                                1622697294,
                                1501003258,
                                1622777550,
                                1622107256,
                                1622695340,
                                1622757516,
                                1010995371,
                                1501865214,
                                1622774289,
                                1622774494,
                                1501332716,
                                1622777952,
                                606029411,
                                1622776100,
                                1618368344,
                                1500384737,
                                1501003767,
                                1622781485,
                                1622771024,
                                1622756650,
                                1622782138,
                                1622026232,
                                1407072468,
                                1619308802,
                                1603712671,
                                1500358485,
                                1622772849,
                                1622783010,
                                607048011,
                                1112100365,
                                1501185921,
                                910228629,
                                1622786835,
                                1622784332,
                                1622786444,
                                1205535598,
                                1204494973,
                                1622252147,
                                1501826179,
                                611126075,
                                1622753095,
                                801451662,
                                1408184966,
                                1622608403,
                                1622686924,
                                1414013672,
                                707294495,
                                1500766096,
                                1500224220,
                                1501164855,
                                1500356784,
                                1622773835,
                                1622779884,
                                1616506939,
                                1621273929,
                                1622776908,
                                1622709131,
                                1622774845,
                                1500874760,
                                1501704874,
                                704202632,
                                1622782404,
                                1622775057,
                                1622776881,
                                1401623562,
                                1607213752,
                                811782981,
                                1611630156,
                                1310212457,
                                905027293,
                                911156689,
                                1500982231,
                                1500370084,
                                1500972024,
                                1620524475,
                                1622775637,
                                1622783281,
                                1501012024,
                                1622110940,
                                1619666362,
                                1501605879,
                                1622786259,
                                1311250362,
                                1621764607,
                                1619154681,
                                1409206153,
                                1205620731,
                                1501427799,
                                1619385526,
                                1622775682,
                                1613299195,
                                1622639649,
                                1600073524,
                                1622779411,
                                1500931737,
                                1006527277,
                                1611880667,
                                1618666448,
                                1301384719,
                                1622774175,
                                1205609778,
                                1500135254,
                                1622776830,
                                1501057821,
                                1622747267,
                                1202246964,
                                1501723939,
                                1500761637,
                                1622783522,
                                1619749803,
                                908127438,
                                1615412532,
                                1501943406,
                                1621449430,
                                1622683404,
                                812848384)
         GROUP BY A.MEMBER_KEY, A.ORDER_KEY, A.ORDER_AMOUNT) ORD,
       /*商品标签分类*/
       (SELECT A.ITEM_CODE,
               CASE
                 WHEN A.GROUP_ID = 1000 AND EXISTS
                  (SELECT 1
                         FROM DIM_TV_GOOD B
                        WHERE A.ITEM_CODE = B.ITEM_CODE) THEN
                  'FIRST_ORDER_BROADCAST'
                 WHEN A.GROUP_ID = 1000 THEN
                  'FIRST_ORDER_NOT_BROADCAST'
                 WHEN A.GROUP_ID = 2000 AND EXISTS
                  (SELECT 1
                         FROM DIM_EC_GOOD C
                        WHERE A.ITEM_CODE = C.ITEM_CODE
                          AND C.STORE_ID = 1) THEN
                  'FIRST_ORDER_SELF'
                 WHEN A.GROUP_ID = 2000 AND EXISTS
                  (SELECT 1
                         FROM DIM_EC_GOOD C
                        WHERE A.ITEM_CODE = C.ITEM_CODE
                          AND C.STORE_ID <> 1) THEN
                  'FIRST_ORDER_BBC'
                 WHEN A.GROUP_ID = 2100 THEN
                  'FIRST_ORDER_JD'
                 ELSE
                  'FIRST_ORDER_OTHER'
               END ITEM_LABEL
          FROM DIM_GOOD A
         WHERE A.CURRENT_FLG = 'Y') ITEM,
       (SELECT * FROM MEMBER_LABEL_HEAD) MLH
 WHERE ORD.GOODS_COMMON_KEY = ITEM.ITEM_CODE
   AND ITEM.ITEM_LABEL = MLH.M_LABEL_NAME
      /*不存在MEMBER_LABEL_LINK表的插入*/
   AND NOT EXISTS (SELECT 1
          FROM MEMBER_LABEL_LINK MLL
         WHERE MLL.M_LABEL_ID BETWEEN 42 AND 47
           AND ORD.MEMBER_KEY = MLL.MEMBER_KEY);

--3.
SELECT P.*
/*  BULK COLLECT
INTO VAR_ARRAY*/
  FROM (SELECT A.MEMBER_KEY
          FROM MEMBER_LABEL_LINK A
         WHERE A.M_LABEL_ID = 42
         GROUP BY A.MEMBER_KEY) P
 WHERE EXISTS (SELECT 1
          FROM FACT_GOODS_SALES B
         WHERE B.ORDER_STATE = 1
           AND B.POSTING_DATE_KEY <= &IN_POSTING_DATE_KEY
           AND P.MEMBER_KEY = B.MEMBER_KEY);

--4.
SELECT *
  FROM MEMBER_LABEL_LINK A
 WHERE A.M_LABEL_ID BETWEEN 42 AND 47
   AND A.MEMBER_KEY IN (1401632327,
                        1620017388,
                        1613937310,
                        1501451683,
                        603009225,
                        709350322,
                        1101235532,
                        1500458631,
                        1500505717,
                        1622775963,
                        1007439638,
                        1500252777,
                        1622784222,
                        609092821,
                        1622784491,
                        1622788473,
                        1500367203,
                        1612906957,
                        1622777642,
                        1622789331,
                        1622787753,
                        1500835189,
                        1622449004,
                        1006525068,
                        1500384467,
                        1622789526,
                        1212267996,
                        1303577444,
                        701136501,
                        1106606463,
                        1404829173,
                        1622777088,
                        1622774863,
                        1611055922,
                        1622780293,
                        811808484,
                        1622773691,
                        905988719,
                        1620735260,
                        1622784873,
                        1622783760,
                        1622774180,
                        1614478845,
                        1411404853,
                        1304718788,
                        606046160,
                        1002423893,
                        1301414232,
                        1622774535,
                        1203421527,
                        1501935464,
                        808722786,
                        1622786501,
                        1617831579,
                        1622715895,
                        905986378,
                        1501407881,
                        1622773721,
                        1622778032,
                        1621435633,
                        1500707932,
                        901868731,
                        1622778472,
                        708345936,
                        812838965,
                        1202340520,
                        607054955,
                        1622775662,
                        1500850845,
                        1622774810,
                        1407093289,
                        1604991945,
                        1614158860,
                        1501160279,
                        1622786675,
                        1622775332,
                        1622776436,
                        1607976130,
                        1501196885,
                        1501278321,
                        1414125825,
                        1622783375,
                        1500833185,
                        1310163982,
                        1403785879,
                        1622773765,
                        1622699562,
                        1405899858,
                        1617663190,
                        1500801344,
                        1500444030,
                        1501012837,
                        1612432067,
                        1622399523,
                        1501494717,
                        1622774407,
                        1622773824,
                        1603042495,
                        1500923366,
                        1622780174,
                        1406959978,
                        1403768432,
                        1611045341,
                        1622780833,
                        1606979372,
                        811804402,
                        1622764367,
                        1107648663,
                        1622773925,
                        1622786620,
                        1610566254,
                        1501157794,
                        1622784565,
                        1622775345,
                        1622782956,
                        1622773127,
                        1406011894,
                        1622789274,
                        1622699919,
                        1500412405,
                        1501119213,
                        1304678040,
                        1622768394,
                        1622697294,
                        1501003258,
                        1622777550,
                        1622107256,
                        1622695340,
                        1622757516,
                        1010995371,
                        1501865214,
                        1622774289,
                        1622774494,
                        1501332716,
                        1622777952,
                        606029411,
                        1622776100,
                        1618368344,
                        1500384737,
                        1501003767,
                        1622781485,
                        1622771024,
                        1622756650,
                        1622782138,
                        1622026232,
                        1407072468,
                        1619308802,
                        1603712671,
                        1500358485,
                        1622772849,
                        1622783010,
                        607048011,
                        1112100365,
                        1501185921,
                        910228629,
                        1622786835,
                        1622784332,
                        1622786444,
                        1205535598,
                        1204494973,
                        1622252147,
                        1501826179,
                        611126075,
                        1622753095,
                        801451662,
                        1408184966,
                        1622608403,
                        1622686924,
                        1414013672,
                        707294495,
                        1500766096,
                        1500224220,
                        1501164855,
                        1500356784,
                        1622773835,
                        1622779884,
                        1616506939,
                        1621273929,
                        1622776908,
                        1622709131,
                        1622774845,
                        1500874760,
                        1501704874,
                        704202632,
                        1622782404,
                        1622775057,
                        1622776881,
                        1401623562,
                        1607213752,
                        811782981,
                        1611630156,
                        1310212457,
                        905027293,
                        911156689,
                        1500982231,
                        1500370084,
                        1500972024,
                        1620524475,
                        1622775637,
                        1622783281,
                        1501012024,
                        1622110940,
                        1619666362,
                        1501605879,
                        1622786259,
                        1311250362,
                        1621764607,
                        1619154681,
                        1409206153,
                        1205620731,
                        1501427799,
                        1619385526,
                        1622775682,
                        1613299195,
                        1622639649,
                        1600073524,
                        1622779411,
                        1500931737,
                        1006527277,
                        1611880667,
                        1618666448,
                        1301384719,
                        1622774175,
                        1205609778,
                        1500135254,
                        1622776830,
                        1501057821,
                        1622747267,
                        1202246964,
                        1501723939,
                        1500761637,
                        1622783522,
                        1619749803,
                        908127438,
                        1615412532,
                        1501943406,
                        1621449430,
                        1622683404,
                        812848384);

--5.
SELECT P.*
/*  BULK COLLECT
INTO VAR_ARRAY*/
  FROM (SELECT A.MEMBER_KEY,
               TO_CHAR(TRUNC(MIN(A.CREATE_DATE)), 'YYYYMMDD') CREATE_DATE
          FROM MEMBER_LABEL_LINK A
         WHERE A.M_LABEL_ID = 42
         GROUP BY A.MEMBER_KEY) P
 WHERE EXISTS (SELECT 1
          FROM FACT_GOODS_SALES B
         WHERE B.ORDER_STATE = 1
           AND B.POSTING_DATE_KEY >= P.CREATE_DATE
           AND P.MEMBER_KEY = B.MEMBER_KEY);

SELECT A.MEMBER_KEY, COUNT(1)
  FROM MEMBER_LABEL_LINK A
 WHERE A.M_LABEL_ID = 42
 group by A.MEMBER_KEY
having count(1) > 1;
