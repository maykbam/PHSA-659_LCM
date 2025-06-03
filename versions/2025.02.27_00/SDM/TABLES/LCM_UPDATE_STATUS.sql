--liquibase formatted.sql
--changeset michael.cawayan:SDM.LCM_UPDATE_STATUS contextFilter:PH endDelimiter:/ runOnChange:true

DECLARE    
exc_already_exists EXCEPTION;    
PRAGMA EXCEPTION_INIT(exc_already_exists, -0955);
BEGIN    
EXECUTE IMMEDIATE q'{
CREATE TABLE SDM.LCM_UPDATE_STATUS (
    JOB_NAME       VARCHAR2(50) PRIMARY KEY,
    LAST_RUN_DATE  DATE
)
}';
EXCEPTION    
WHEN exc_already_exists 
THEN NULL;
END;
/
GRANT SELECT, INSERT, UPDATE, DELETE ON SDM.LCM_UPDATE_STATUS TO MA_TEMP
/