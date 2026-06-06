--실전문제①
 SELECT TO_DATE(:OUTBOUND_DATE) + LEVEL + 1 AS OUTBOUND_DATE
  FROM DUAL
  CONNECT BY LEVEL < 10
;

--실전문제②: 스칼라 쿼리 제약에서 벗어나기
SELECT INVOICE_NO
     , OUT_TYPE_DIV
     , OUT_BOX_DIV
     , ORDER_QTY AS MAX_ORDER_QTY
     , LINE_NO AS MAX_LINE
  FROM(
        SELECT M1.INVOICE_NO
             , M1.OUT_TYPE_DIV
             , M1.OUT_BOX_DIV
             , M2.ORDER_QTY
             , M2.LINE_NO
            -- 주문번호 내에서 주문량이 가장 큰 거
             , ROW_NUMBER() OVER(PARTITION BY M1.INVOICE_NO
                                     ORDER BY M2.ORDER_QTY DESC) AS RNK
         FROM LO_OUT_M M1 
              JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
        WHERE M1.OUTBOUND_DATE =       TO_DATE('2019-06-03', 'YYYY-MM-DD')
          AND M1.OUTBOUND_NO   BETWEEN 'D190603-897353' AND 'D190603-897360'
        )
 WHERE RNK = 1
;

--교수님 답안: 순수 스칼라 쿼리 이용
SELECT INVOICE_NO, OUT_TYPE_DIV, OUT_BOX_DIV
     , TO_NUMBER(SUBSTR(MAX_VAL, 1, 5)) AS MAX_ORDER_QTY
     , TO_NUMBER(SUBSTR(MAX_VAL, 7, 3)) AS MAX_LINE
  FROM (SELECT INVOICE_NO, OUT_TYPE_DIV, OUT_BOX_DIV
             , (SELECT MAX(LPAD(ORDER_QTY, 5, '0') || '-' || LPAD(LINE_NO, 3, '0'))
                  FROM LO_OUT_D M2
                 WHERE M2.INVOICE_NO = M1.INVOICE_NO) AS MAX_VAL
          FROM LO_OUT_M M1
         WHERE OUTBOUND_DATE = TO_DATE('2019-06-03', 'YYYY-MM-DD')
           AND OUTBOUND_NO   BETWEEN 'D190603-897353'
                                 AND 'D190603-897360'
        )
;
