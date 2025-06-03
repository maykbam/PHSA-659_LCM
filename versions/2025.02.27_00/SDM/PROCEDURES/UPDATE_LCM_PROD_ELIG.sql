--liquibase formatted.sql
--changeset michael.cawayan:SDM.UPDATE_LCM_PROD_ELIG contextFilter:PH endDelimiter:/ runOnChange:true

CREATE OR REPLACE PROCEDURE SDM.UPDATE_LCM_PROD_ELIG IS
    v_last_job_status  VARCHAR2(10);
    v_last_run_date    DATE;
    v_repl_end         DATE;
    v_attempts         INTEGER := 0;
BEGIN
    -- 1. Check if the job was already run successfully today
    BEGIN
        SELECT LAST_RUN_DATE
        INTO v_last_run_date
        FROM SDM.LCM_UPDATE_STATUS
        WHERE JOB_NAME = 'UPDATE_LCM_PROD_ELIG_JOB';

        IF TRUNC(v_last_run_date) = TRUNC(SYSDATE) THEN
            DBMS_OUTPUT.PUT_LINE('Job already ran today. Exiting.');
            RETURN;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO SDM.LCM_UPDATE_STATUS (JOB_NAME, LAST_RUN_DATE)
            VALUES ('UPDATE_LCM_PROD_ELIG_JOB', TO_DATE('1900-01-01', 'YYYY-MM-DD'));
            COMMIT;
    END;

    -- 2. Check last ETL job status from ETL log
    LOOP
        EXIT WHEN v_attempts > 20; -- max ~100 mins wait time

        BEGIN
            SELECT CODE_REPLICATION_STATUS, DTIME_REPLICATION_END
            INTO v_last_job_status, v_repl_end
            FROM (
                SELECT CODE_REPLICATION_STATUS, DTIME_REPLICATION_END
                FROM SDM_ETL.ETL_PROGRAM_LOG
                WHERE NAME_SCHEDULE_PROGRAM = 'SDM_LIFECYCLE_MATRIX'
                AND TRUNC(DTIME_REPLICATION_END) = TRUNC(SYSDATE)
                ORDER BY DTIME_REPLICATION_END DESC
            )
            WHERE ROWNUM = 1;

            EXIT WHEN v_last_job_status = 'SUCCESS' AND TRUNC(v_repl_end) = TRUNC(SYSDATE);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; -- No logs found yet, continue waiting
        END;

        v_attempts := v_attempts + 1;
        DBMS_SESSION.SLEEP(300); -- Sleep 300 seconds before next check
    END LOOP;

    -- 3. Insert client lifecycle product eligibility
    EXECUTE IMMEDIATE 'TRUNCATE TABLE CDM.CLIENT_LIFECYCLE_PRODUCT_ELIG';
    
    INSERT INTO CDM.CLIENT_LIFECYCLE_PRODUCT_ELIG (
        PARTY_ID, REAL_CLX_FLAG, REAL_CC_FLAG, REAL_POS_FLAG,
        ENGAGEMENT_FLAG, HOOK_CLX_FLAG, HOOK_CC_FLAG, HOOK_POS_FLAG, DATE_CREATED
    )
    WITH CUSTOMER_TB AS (
        SELECT PARTY_ID
        FROM INT_OS.V_OFFER 
        WHERE PARTY_ID IN (
            SELECT ID_CUID
            FROM SDM.DCT_CLIENT_LIFECYCLE_MTRX
            WHERE TRUNC(DTIME_CREATED) = TRUNC(SYSDATE)
        )
    ),
    OFFERS AS (
        SELECT 
            C.PARTY_ID,
            O.OFFER_TYPE_CODE,
            O.CRM_PILOT_CODE,
            O.OFFER_STATUS,
            O.OFFER_VALID_TO
        FROM CUSTOMER_TB C
        LEFT JOIN INT_OS.V_OFFER O 
        ON C.PARTY_ID = O.PARTY_ID
    ),
    OFFERS1 AS (
        SELECT 
            O.*,
            CASE 
                WHEN O.OFFER_TYPE_CODE LIKE '%HOOK%' THEN 'HOOK'
                WHEN O.OFFER_TYPE_CODE LIKE '%REAL%' THEN 'REAL'
                ELSE NULL
            END AS OFFER_TYPE,
            CASE 
                WHEN O.CRM_PILOT_CODE LIKE '%POS%' THEN 'POS'
                WHEN O.CRM_PILOT_CODE LIKE '%CLX%' THEN 'CLX'
                WHEN O.CRM_PILOT_CODE LIKE '%CC%' THEN 'CC'
                ELSE NULL
            END AS PRODUCT_TYPE      
        FROM OFFERS O
    ),
    CLIENT_PRODUCT_ELIGIBILITY AS (
        SELECT 
            O.PARTY_ID,
            NVL(MAX(CASE WHEN O.OFFER_TYPE = 'REAL' AND O.PRODUCT_TYPE = 'CLX' THEN 1 END), 0) AS REAL_CLX_FLAG,
            NVL(MAX(CASE WHEN O.OFFER_TYPE = 'REAL' AND O.PRODUCT_TYPE = 'CC' THEN 1 END), 0) AS REAL_CC_FLAG,
            NVL(MAX(CASE WHEN O.OFFER_TYPE = 'REAL' AND O.PRODUCT_TYPE = 'POS' THEN 1 END), 0) AS REAL_POS_FLAG,
            NVL(MAX(CASE WHEN CC.ID_CUID IS NOT NULL THEN 1 END), 0) AS ENGAGEMENT_FLAG,
            NVL(MAX(CASE WHEN O.OFFER_TYPE = 'HOOK' AND O.PRODUCT_TYPE = 'CLX' THEN 1 END), 0) AS HOOK_CLX_FLAG,
            NVL(MAX(CASE WHEN O.OFFER_TYPE = 'HOOK' AND O.PRODUCT_TYPE = 'CC' THEN 1 END), 0) AS HOOK_CC_FLAG,
            NVL(MAX(CASE WHEN O.OFFER_TYPE = 'HOOK' AND O.PRODUCT_TYPE = 'POS' THEN 1 END), 0) AS HOOK_POS_FLAG,
            SYSDATE AS DATE_CREATED
        FROM OFFERS1 O
        LEFT JOIN (
            SELECT C.ID_CUID 
            FROM SDM.FT_CONTRACT_AD C
            LEFT JOIN SDM.FT_APPLICATION_AD A 
            ON C.SKP_CREDIT_CASE = A.SKP_CREDIT_CASE
            WHERE C.NAME_CREDIT_STATUS = 'Active'
              AND C.SKP_CREDIT_TYPE = 3
              AND A.CODE_PRODUCT LIKE '%CC%'
              AND A.DTIME_ACTIVATION >= ADD_MONTHS(SYSDATE, -1)
        ) CC 
        ON O.PARTY_ID = CC.ID_CUID
        LEFT JOIN SDM.DCT_CLIENT_LIFECYCLE_MTRX M 
        ON M.ID_CUID = O.PARTY_ID
        GROUP BY O.PARTY_ID
    )
    SELECT *
    FROM CLIENT_PRODUCT_ELIGIBILITY;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('CLIENT_LIFECYCLE_PRODUCT_ELIG insert completed.');

    -- 4. Update status
    UPDATE SDM.LCM_UPDATE_STATUS
    SET LAST_RUN_DATE = SYSDATE
    WHERE JOB_NAME = 'UPDATE_LCM_PROD_ELIG_JOB';
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error in UPDATE_LCM_PROD_ELIG: ' || SQLERRM);
        RAISE;
END;
/
GRANT SELECT, INSERT, UPDATE, DELETE ON CDM.CLIENT_LIFECYCLE_PRODUCT_ELIG TO SDM
/
GRANT SELECT, INSERT, UPDATE, DELETE ON SDM_ETL.ETL_PROGRAM_LOG TO SDM
/
GRANT SELECT ON INT_OS.V_OFFER TO SDM
/
GRANT SELECT ON SDM_ETL.ETL_PROGRAM_LOG TO SDM
/
GRANT EXECUTE ON SDM.UPDATE_LCM_PROD_ELIG TO SDM_ETL
/