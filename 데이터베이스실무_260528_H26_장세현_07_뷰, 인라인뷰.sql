--실전문제 ②
--3) TOP5 구하기
SELECT *        
FROM (--2) 박스수, 낱개, 총박스수 구하기
      SELECT B1.ITEM_CD, B1.ITEM_NM, B1.QTY_IN_BOX, B1.ORDER_QTY
            ,TRUNC(B1.ORDER_QTY/B1.QTY_IN_BOX)  AS BOX_CNT
            ,MOD  (B1.ORDER_QTY, B1.QTY_IN_BOX) AS PCS_CNT      
            ,CEIL (B1.ORDER_QTY/B1.QTY_IN_BOX)  AS BOX_CNT_TOT
      FROM(--1) 상품별 주문수량 합계 구하기
          SELECT ITEM_CD, ITEM_NM, QTY_IN_BOX, SUM(ORDER_QTY) AS ORDER_QTY
            FROM LO_OUT_D
           WHERE INVOICE_NO BETWEEN '346724706262'
                                AND '346724706762'
           GROUP BY ITEM_CD, ITEM_NM, QTY_IN_BOX
          ) B1
      ORDER BY ORDER_QTY DESC
      )
WHERE ROWNUM <= 5
;

--<1-3>
SELECT *
  FROM(
        SELECT BRAND_CD, ITEM_CD, ITEM_NM, QTY_IN_BOX, SUM_QTY
              , TRUNC(SUM_QTY / QTY_IN_BOX) AS BOX_CNT
              , MOD(SUM_QTY, QTY_IN_BOX) AS PCS
          FROM (
                SELECT B1.BRAND_CD, B1.ITEM_CD, C1.ITEM_NM, C1.QTY_IN_BOX, SUM(B1.ORDER_QTY) AS SUM_QTY
                  FROM A_OUT_D B1
                       JOIN A_ITEM C1 ON C1.BRAND_CD = B1.BRAND_CD
                                     AND C1.ITEM_CD  = B1.ITEM_CD
                  GROUP BY B1.BRAND_CD, B1.ITEM_CD, C1.ITEM_NM, C1.QTY_IN_BOX
                )
       ORDER BY BOX_CNT DESC
      )
 WHERE ROWNUM <= 3
;

--<1-2>
SELECT BRAND_CD, ITEM_CD, ITEM_NM, QTY_IN_BOX, SUM_QTY
      , TRUNC(SUM_QTY / QTY_IN_BOX) AS BOX_CNT
      , MOD(SUM_QTY, QTY_IN_BOX) AS PCS
  FROM (
        SELECT B1.BRAND_CD, B1.ITEM_CD, C1.ITEM_NM, C1.QTY_IN_BOX, SUM(B1.ORDER_QTY) AS SUM_QTY
          FROM A_OUT_D B1
               JOIN A_ITEM C1 ON C1.BRAND_CD = B1.BRAND_CD
                             AND C1.ITEM_CD  = B1.ITEM_CD
          GROUP BY B1.BRAND_CD, B1.ITEM_CD, C1.ITEM_NM, C1.QTY_IN_BOX
        )
;

--<1-1>
--스칼라 쿼리 이용
SELECT BRAND_CD, ITEM_CD, SUM_QTY
       ,(SELECT S1.ITEM_NM
           FROM A_ITEM S1
          WHERE S1.BRAND_CD = B1.BRAND_CD
            AND S1.ITEM_CD = B1.ITEM_CD
         ) AS ITEM_NM
       ,(SELECT S1.QTY_IN_BOX
           FROM A_ITEM S1
          WHERE S1.BRAND_CD = B1.BRAND_CD
            AND S1.ITEM_CD = B1.ITEM_CD
         ) AS QTY_IN_BOX
  FROM (
        SELECT BRAND_CD, ITEM_CD, SUM(ORDER_QTY) AS SUM_QTY
          FROM A_OUT_D
         GROUP BY BRAND_CD, ITEM_CD
        ) B1
--JOIN 이용
SELECT B1.BRAND_CD, B1.ITEM_CD, C1.ITEM_NM, C1.QTY_IN_BOX, SUM(B1.ORDER_QTY) AS SUM_QTY
  FROM A_OUT_D B1
       JOIN A_ITEM C1 ON C1.BRAND_CD = B1.BRAND_CD
                     AND C1.ITEM_CD  = B1.ITEM_CD
  GROUP BY B1.BRAND_CD, B1.ITEM_CD, C1.ITEM_NM, C1.QTY_IN_BOX;
