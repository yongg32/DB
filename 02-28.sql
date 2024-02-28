--DBA 권한이 있는쪽에서만 public synonym 가능
CREATE PUBLIC SYNONYM bbs FOR study.stock_bbs; -- bbs 라는 동의어를 만듬
CREATE PUBLIC SYNONYM stock FOR study.stock; -- stock 동의어 생성
GRANT SELECT ON bbs TO public;
GRANT SELECT ON stock TO public;    --public 시노님을 전역적으로 조회하도록
SELECT *
FROM bbs;
SELECT (SELECT name 
        FROM stock 
        WHERE code = a.code) as nm
        , a.title
        , a.read_count
        , TO_CHAR(a.update_dt,'YYYYMMDD HH24:MI:SS') as update_dt
FROM bbs a;
ORDER BY update_dt;

