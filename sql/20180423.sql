SELECT *
  FROM MEMBER_LABEL_HEAD B
 WHERE EXISTS (SELECT 1
          FROM (SELECT A.MEMBER_KEY, A.M_LABEL_ID, COUNT(1)
                  FROM MEMBER_LABEL_LINK A
                 WHERE A.M_LABEL_ID <> -1
                 GROUP BY A.MEMBER_KEY, A.M_LABEL_ID
                HAVING COUNT(1) > 1) C
         WHERE B.M_LABEL_ID = C.M_LABEL_ID);

SELECT A.MEMBER_KEY, A.M_LABEL_ID, COUNT(1)
  FROM MEMBER_LABEL_LINK A
 WHERE A.M_LABEL_ID BETWEEN 181 AND 182
 GROUP BY A.MEMBER_KEY, A.M_LABEL_ID
HAVING COUNT(1) > 1;

--��Ա�ȼ�
SELECT MAX(B.ROW_ID) ROW_ID, B.MEMBER_KEY
  FROM MEMBER_LABEL_LINK B
 WHERE EXISTS (SELECT 1
          FROM (SELECT A.MEMBER_KEY, A.M_LABEL_ID, COUNT(1)
                  FROM MEMBER_LABEL_LINK A
                 WHERE A.M_LABEL_ID BETWEEN 63 AND 68
                 GROUP BY A.MEMBER_KEY, A.M_LABEL_ID
                HAVING COUNT(1) > 1) C
         WHERE B.M_LABEL_ID = C.M_LABEL_ID
           AND B.MEMBER_KEY = C.MEMBER_KEY)
   AND B.M_LABEL_ID BETWEEN 63 AND 68
 GROUP BY B.MEMBER_KEY;

DELETE MEMBER_LABEL_LINK A
 WHERE A.ROW_ID IN (33423323,
                    31772235,
                    33637450,
                    33692005,
                    33692495,
                    33641075,
                    33309551,
                    33148523,
                    33148406,
                    33683794,
                    33512134,
                    33506683,
                    33651035,
                    33506784,
                    33147475,
                    33506578,
                    33130663,
                    33608378,
                    33505784,
                    33517065,
                    33613602,
                    33613103,
                    33692770,
                    33697601,
                    33147945,
                    33507387,
                    33506222,
                    33645031,
                    33642118,
                    33692348,
                    33691173,
                    33612015,
                    31793262,
                    33506125,
                    33413985,
                    33680901,
                    33518307,
                    33607945,
                    33691103,
                    33642908,
                    33642050,
                    33513089,
                    33697077,
                    33507536,
                    33690538,
                    31758697,
                    33514728,
                    33146968,
                    33613077,
                    33512609,
                    33645811,
                    33167958,
                    33516099,
                    33612895,
                    33642712,
                    33690983,
                    33697139,
                    33692663,
                    31773780,
                    33148313,
                    33148058,
                    33148231,
                    33147969,
                    33695304,
                    33496869,
                    33501779,
                    32945780,
                    33428307,
                    33517133,
                    33506973,
                    33639496,
                    33506063,
                    33644458,
                    32941517,
                    33611231,
                    33136722,
                    33294907,
                    33147750,
                    33613759,
                    32945787,
                    33172058,
                    33680385,
                    33664954,
                    33697948,
                    33697042,
                    32941228,
                    33646859,
                    31797621,
                    33147795,
                    33647663,
                    33691496,
                    33518664,
                    33643088,
                    33691849,
                    33145220,
                    32823495,
                    33640494,
                    33647150,
                    33697961,
                    33686816,
                    33522488,
                    33425102,
                    32944303,
                    33166416,
                    33506327,
                    33147208,
                    33497502,
                    33692047,
                    33610096,
                    31933876,
                    33640678,
                    31793340,
                    33643723,
                    32626341,
                    33507037,
                    33140920,
                    33499340,
                    33505947,
                    33698085,
                    33553569,
                    33147731,
                    33504438,
                    33169225,
                    33510664,
                    33495858,
                    31758574,
                    33639386,
                    33147476,
                    33658208,
                    33643823,
                    33651445,
                    33651972,
                    33507459,
                    33649983,
                    33518761,
                    33507130,
                    33147828,
                    31922893,
                    33669395,
                    33643090,
                    31797338,
                    33148094,
                    33429938,
                    33645941,
                    33505751,
                    33505988,
                    33172928,
                    33147702,
                    33511752,
                    33618005,
                    33515245,
                    32933360,
                    32945979,
                    33496053,
                    33163646,
                    33638751,
                    33506931,
                    33690609,
                    33690997,
                    33644902,
                    33140186,
                    33648797,
                    33653738,
                    33613241,
                    33653290,
                    33147536,
                    32945844,
                    33147699,
                    33429832,
                    33642199,
                    33644845,
                    33425308,
                    33499784,
                    33506348,
                    33651555,
                    33651559,
                    33691494,
                    33510590,
                    33642367,
                    33148300,
                    33644623,
                    33506121,
                    33506979,
                    33687454,
                    33692645,
                    33657356,
                    33691962,
                    33504802,
                    32948348,
                    33148092,
                    33674900,
                    33691887,
                    33691029,
                    31759524,
                    33503828,
                    33515265,
                    33146929,
                    33685935,
                    33507520,
                    33692079,
                    33691436,
                    33611256,
                    31769228,
                    31758609,
                    33608650,
                    33640295,
                    33148219,
                    33509929,
                    33147924,
                    33611909,
                    33510420,
                    33505568,
                    33147222,
                    33506716,
                    33685239,
                    33690672,
                    33507059,
                    33697141,
                    33697552,
                    33428471,
                    31775186,
                    33428123,
                    33522977,
                    33648602,
                    33690994,
                    33147651,
                    33180414,
                    33608696,
                    33648708,
                    33642218,
                    33647378,
                    33653765,
                    33500976,
                    33648348,
                    33276270,
                    33425804,
                    32944089,
                    33506561,
                    31898004,
                    33610591,
                    33505499,
                    33637249,
                    33506730,
                    33613776,
                    33644701);

--�������ڵȼ�
SELECT MAX(B.ROW_ID) ROW_ID, B.MEMBER_KEY
  FROM MEMBER_LABEL_LINK B
 WHERE EXISTS (SELECT 1
          FROM (SELECT A.MEMBER_KEY, A.M_LABEL_ID, COUNT(1)
                  FROM MEMBER_LABEL_LINK A
                 WHERE A.M_LABEL_ID BETWEEN 103 AND 106
                 GROUP BY A.MEMBER_KEY, A.M_LABEL_ID
                HAVING COUNT(1) > 1) C
         WHERE B.M_LABEL_ID = C.M_LABEL_ID
           AND B.MEMBER_KEY = C.MEMBER_KEY)
   AND B.M_LABEL_ID BETWEEN 103 AND 106
 GROUP BY B.MEMBER_KEY;

DELETE MEMBER_LABEL_LINK A
 WHERE A.ROW_ID IN (34184533,
                    34198598,
                    34202567,
                    34411981,
                    34412001,
                    34313518,
                    34312878,
                    34313218,
                    34415098,
                    34506236,
                    34508433,
                    34423855,
                    34300435,
                    34191040,
                    34324895,
                    34493038,
                    34411983,
                    34301051,
                    34301081,
                    34382350,
                    34313388,
                    34414937,
                    34313355,
                    34412162,
                    34515311,
                    34679638,
                    34514970,
                    34313018,
                    34317856,
                    34397332,
                    34301325,
                    34508202,
                    34313440,
                    34489564,
                    34419063,
                    34317640,
                    34301056,
                    34420718,
                    34523578,
                    34411267,
                    34414890,
                    34493098,
                    34507533,
                    34515183,
                    34492988,
                    34515203,
                    34411128,
                    34313407,
                    34420195,
                    34313165,
                    34403538,
                    34493057,
                    34417644,
                    34419061,
                    34506544,
                    34507088,
                    34516787,
                    34492904,
                    34515320,
                    34322255,
                    34301052,
                    34492973,
                    34505341,
                    34312876,
                    34313233,
                    34403980,
                    34419100,
                    34411529,
                    34508199,
                    34321043,
                    34190086,
                    34313257,
                    34410891,
                    34301085,
                    34419039,
                    34421354,
                    34418718,
                    34420463,
                    34317353,
                    34301087,
                    34411982,
                    34417613,
                    34312972,
                    34417272,
                    34488487,
                    34412250,
                    34515071,
                    34397832,
                    34515036,
                    34188695,
                    34515396,
                    34410081,
                    34414853,
                    34313517,
                    34416762,
                    34313342,
                    34492868,
                    34313642,
                    34506368,
                    34313307,
                    34314521,
                    34419294,
                    34192569,
                    34451604,
                    34412008,
                    34521255,
                    34421888,
                    34423191,
                    34515338,
                    34313423,
                    34414884,
                    34313304,
                    34417551,
                    34320450,
                    34524362,
                    34509024,
                    34418648,
                    34417647,
                    34481537,
                    34522094,
                    34497589,
                    34304149,
                    34191318,
                    34187448,
                    34301327,
                    34301379,
                    34320814,
                    34315707,
                    34507111,
                    34515055,
                    34301180,
                    34313019,
                    34188031,
                    34324751,
                    34419037,
                    34314078,
                    34507561,
                    34515237,
                    34515104,
                    34323887,
                    34185580,
                    34420392,
                    34312992,
                    34423295,
                    34313277,
                    34415164,
                    34518574,
                    34491171,
                    34506119,
                    34419065,
                    34515100,
                    34419067,
                    34418720,
                    34284108,
                    34410956,
                    34321388,
                    34506634,
                    34313300,
                    34418749,
                    34514998,
                    34313352,
                    34417654,
                    34313087,
                    34420191,
                    34419094,
                    34420466,
                    34313590,
                    34313441,
                    34423372,
                    34420232,
                    34313815,
                    34420333,
                    34419098);

--167
SELECT MAX(B.ROW_ID) ROW_ID, B.MEMBER_KEY, COUNT(1)
  FROM MEMBER_LABEL_LINK B
 WHERE EXISTS (SELECT 1
          FROM (SELECT A.MEMBER_KEY, A.M_LABEL_ID, COUNT(1)
                  FROM MEMBER_LABEL_LINK A
                 WHERE A.M_LABEL_ID = 167
                 GROUP BY A.MEMBER_KEY, A.M_LABEL_ID
                HAVING COUNT(1) > 1) C
         WHERE B.M_LABEL_ID = C.M_LABEL_ID
           AND B.MEMBER_KEY = C.MEMBER_KEY)
   AND B.M_LABEL_ID = 167
 GROUP BY B.MEMBER_KEY;

SELECT *
  FROM MEMBER_LABEL_LINK A
 WHERE A.MEMBER_KEY = 1002439330
   AND A.M_LABEL_ID = 167
   FOR UPDATE;

DELETE MEMBER_LABEL_LINK A
 WHERE A.ROW_ID IN (37819505, 70583543, 340069103, 409618731, 411511422);

--181,182
SELECT *
  FROM MEMBER_LABEL_LINK A
 WHERE A.MEMBER_KEY = 1500867314
   AND A.M_LABEL_ID = 181
   FOR UPDATE;

SELECT MAX(B.ROW_ID) ROW_ID, B.MEMBER_KEY
  FROM MEMBER_LABEL_LINK B
 WHERE EXISTS (SELECT 1
          FROM (SELECT A.MEMBER_KEY, A.M_LABEL_ID, COUNT(1)
                  FROM MEMBER_LABEL_LINK A
                 WHERE A.M_LABEL_ID BETWEEN 181 AND 182
                 GROUP BY A.MEMBER_KEY, A.M_LABEL_ID
                HAVING COUNT(1) > 1) C
         WHERE B.M_LABEL_ID = C.M_LABEL_ID
           AND B.MEMBER_KEY = C.MEMBER_KEY)
   AND B.M_LABEL_ID BETWEEN 181 AND 182
 GROUP BY B.MEMBER_KEY;

DELETE MEMBER_LABEL_LINK A
 WHERE A.ROW_ID IN (71473206,
                    74579521,
                    74579526,
                    75529533,
                    91243441,
                    97942404,
                    138357114,
                    158855107,
                    246715630,
                    264249137,
                    275526749,
                    293572159,
                    294605215,
                    298952337,
                    298952405,
                    305710386,
                    305710431,
                    306811416,
                    311643993,
                    311644006,
                    313248523,
                    318417563,
                    318417597,
                    324187731,
                    324187745,
                    325651205,
                    326330298,
                    327701244,
                    327701293,
                    327701367,
                    328390999,
                    329773508,
                    329773558,
                    365297229,
                    371970520,
                    371970606,
                    373973302,
                    377030571,
                    384109940,
                    386083584,
                    389403389,
                    393555382,
                    393555408,
                    401548240,
                    405113010,
                    406027053,
                    406954353,
                    406954376,
                    406954481,
                    406954547,
                    407564810,
                    407564821,
                    408165608,
                    408767462,
                    408767667,
                    408767724,
                    408767979,
                    409630914,
                    409631409,
                    410600164,
                    411595494,
                    413890147,
                    414909532,
                    415943784,
                    415943966);

--55
SELECT A.M_LABEL_ID, A.MEMBER_KEY, COUNT(1)
  FROM MEMBER_LABEL_LINK A
 WHERE A.M_LABEL_ID = 55
 GROUP BY A.M_LABEL_ID, A.MEMBER_KEY
HAVING COUNT(1) > 1;

DELETE MEMBER_LABEL_LINK B
 WHERE EXISTS
 (SELECT 1
          FROM (SELECT A.M_LABEL_ID, A.MEMBER_KEY, MAX(A.ROW_ID) ROW_ID
                  FROM MEMBER_LABEL_LINK A
                 WHERE A.M_LABEL_ID = 55
                 GROUP BY A.M_LABEL_ID, A.MEMBER_KEY
                HAVING COUNT(1) = 2) C
         WHERE B.ROW_ID = C.ROW_ID);

--

SELECT TRUNC(A.CREATE_DATE) CREATE_DATE, COUNT(1)
  FROM MEMBER_LABEL_LINK A
 WHERE A.M_LABEL_ID = -1
 GROUP BY TRUNC(A.CREATE_DATE)
 ORDER BY TRUNC(A.CREATE_DATE);

SELECT * FROM MEMBER_LABEL_LINK A WHERE A.M_LABEL_ID = -1;

DELETE MEMBER_LABEL_LINK A
 WHERE A.M_LABEL_ID = -1
   AND TRUNC(A.CREATE_DATE) = DATE '2017-09-28';