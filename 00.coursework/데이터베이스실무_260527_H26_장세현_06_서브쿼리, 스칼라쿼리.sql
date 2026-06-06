--실전문제②. 스칼라쿼리를 활용한 컬럼 연계 최댓값 구하기
--교수님 답안
SELECT INVOICE_NO, OUT_TYPE_DIV, OUT_BOX_DIV
       , TO_NUMBER(SUBSTR(MAX_VAL, 1, 5)) AS MAX_ORDER_QTY
       , TO_NUMBER(SUBSTR(MAX_VAL, 7, 3)) AS MAX_LINE
  FROM (
       SELECT INVOICE_NO, OUT_TYPE_DIV, OUT_BOX_DIV
              ,(SELECT MAX(LPAD(ORDER_QTY, 5, '0') || '-' || LPAD(LINE_NO, 3, '0'))
         FROM LO_OUT_D M2
        WHERE M2.INVOICE_NO = M1.INVOICE_NO
        ) AS MAX_VAL
         FROM LO_OUT_M M1
        WHERE OUTBOUND_DATE = TO_DATE('2019-06-03', 'YYYY-MM-DD')
          AND OUTBOUND_NO   BETWEEN 'D190603-897353'
                                AND  'D190603-897360'
       )
;

--오답
SELECT B1.INVOICE_NO, B1.OUT_TYPE_DIV, B1.OUT_BOX_DIV
       ,(SELECT MAX(B2.ORDER_QTY)
           FROM LO_OUT_D B2
         WHERE B2.INVOICE_NO = B1.INVOICE_NO 
        ) AS MAX_ORDER_QTY
  FROM LO_OUT_M B1
 WHERE B1.OUTBOUND_DATE = TO_DATE('2019-06-03', 'YYYY-MM-DD')
   AND B1.OUTBOUND_NO   BETWEEN 'D190603-897353'
                        AND     'D190603-897360'
;

--실전문제①. 트랜잭션 테이블의 레코드 건수 적게 읽기
--교수님 답안:
SELECT *
  FROM (
        SELECT TO_DATE(:OUTBOUND_DATE) + NO AS DAY
          FROM CS_NO
         WHERE NO <= :DAYS
        ) M1
 WHERE EXISTS (
              SELECT 1
                FROM LO_OUT_M S1
              WHERE S1.OUTBOUND_DATE = M1.DAY
              )
;

--DUAL 이용
--SELECT LEVEL
--  FROM DUAL
--CONNECT BY LEVEL <= 10
--;

--오답
SELECT OUTBOUND_DATE AS 출고일자
 FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN TO_DATE(:OUTBOUND_DATE, 'YYYY-MM-DD') + 1
                         AND TO_DATE(:OUTBOUND_DATE, 'YYYY-MM-DD') + 10
 GROUP BY OUTBOUND_DATE
;

--<4>
SELECT M1.BRAND_CD AS 브랜드, M1.ITEM_CD AS 상품코드, M1.SUM_QTY AS 주문합계
      ,(SELECT S1.ITEM_NM
          FROM A_ITEM S1
         WHERE S1.BRAND_CD = M1.BRAND_CD
           AND S1.ITEM_CD  = M1.ITEM_CD
        ) AS 상품명
  FROM (
        SELECT BRAND_CD, ITEM_CD, SUM(ORDER_QTY) AS SUM_QTY
          FROM A_OUT_D
         GROUP BY BRAND_CD, ITEM_CD
        ) M1
;

--<3>
SELECT *
  FROM A_OUT_M M2
 WHERE (M2.BRAND_CD, M2.INVOICE_NO) IN (
                                        SELECT M1.BRAND_CD, M1.INVOICE_NO
                                          FROM A_OUT_D M1
                                         GROUP BY M1.BRAND_CD, M1.INVOICE_NO
                                        HAVING SUM(M1.ORDER_QTY) >= 3
                                        )
;

--<2>
SELECT *
  FROM A_OUT_D M1
 WHERE (M1.BRAND_CD, M1.INVOICE_NO) IN (
                                        SELECT M2.BRAND_CD, M2.INVOICE_NO
                                          FROM A_OUT_M M2
                                         WHERE BRAND_CD = '1001'
                                           AND OUT_TYPE_DIV LIKE 'M1%'
                                        )
;

--<1>
SELECT *
  FROM A_OUT_D M1
 WHERE (M1.BRAND_CD, M1.INVOICE_NO) IN (
                                        SELECT M2.BRAND_CD, M2.INVOICE_NO
                                          FROM A_OUT_m M2
                                         WHERE OUTBOUND_DATE = TO_DATE('2023-01-03', 'YYYY-MM-DD')
                                        )
;
