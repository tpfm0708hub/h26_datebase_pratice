--(3) 최종 출력 결과
SELECT ITEM_CD, SUM(SUM_QTY) AS ORDER_QTY
    FROM (
          SELECT CASE WHEN ROWNUM <= 2 THEN ROWNUM
                       ELSE 3
                  END AS RNUM
                , CASE WHEN ROWNUM <= 2 THEN ITEM_CD
                       ELSE 'etc'
                  END AS ITEM_CD
                , SUM_QTY
          FROM (
                SELECT ITEM_CD, SUM(ORDER_QTY) AS SUM_QTY
                  FROM A_OUT_D
                 GROUP BY ITEM_CD
                 ORDER BY SUM_QTY DESC
                )
          )
 GROUP BY RNUM, ITEM_CD
 ORDER BY RNUM
;

--(2)TOP2까지 표시, 나머지는 etc
SELECT CASE WHEN ROWNUM <= 2 THEN ROWNUM
             ELSE 3
        END AS RNUM
      , CASE WHEN ROWNUM <= 2 THEN ITEM_CD
             ELSE 'etc'
        END AS ITEM_CD
      , SUM_QTY
FROM (
      SELECT ITEM_CD, SUM(ORDER_QTY) AS SUM_QTY
        FROM A_OUT_D
       GROUP BY ITEM_CD
       ORDER BY SUM_QTY DESC
      )
;

--(1) 상품별 주문수량 합계
SELECT ROWNUM, ITEM_CD, SUM_QTY
      , CASE WHEN ROWNUM <= 2 THEN ROWNUM
             ELSE 3
        END AS RNUM
FROM (
      SELECT ITEM_CD, SUM(ORDER_QTY) AS SUM_QTY
        FROM A_OUT_D
       GROUP BY ITEM_CD
       ORDER BY SUM_QTY DESC
      )
;