--liquibase formatted.sql
--changeset michael.cawayan:SDM_ETL.UPDATE_LCM_PROD_ELIG_SCHED contextFilter:PH endDelimiter:/ runOnChange:true

BEGIN
  DBMS_SCHEDULER.CREATE_SCHEDULE (
    schedule_name   => 'SDM_ETL.UPDATE_LCM_PROD_ELIG_DAILY',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=DAILY; BYHOUR=20',
    comments        => 'Will run every DAY'
  );
  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name   => 'SDM_ETL.UPDATE_LCM_PROD_ELIG_PROG',
    program_type   => 'STORED_PROCEDURE',
    program_action => 'SDM.UPDATE_LCM_PROD_ELIG',
    enabled        => TRUE
  );
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'SDM_ETL.UPDATE_LCM_PROD_ELIG_JOB',
    program_name    => 'SDM_ETL.UPDATE_LCM_PROD_ELIG_PROG',
    schedule_name   => 'SDM_ETL.UPDATE_LCM_PROD_ELIG_DAILY',
    enabled         => TRUE
  );
END;
/