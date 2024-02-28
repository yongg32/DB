--DBA ������ �ִ��ʿ����� public synonym ����
CREATE PUBLIC SYNONYM bbs FOR study.stock_bbs; -- bbs ��� ���Ǿ ����
CREATE PUBLIC SYNONYM stock FOR study.stock; -- stock ���Ǿ� ����
GRANT SELECT ON bbs TO public;
GRANT SELECT ON stock TO public;    --public �ó���� ���������� ��ȸ�ϵ���
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

