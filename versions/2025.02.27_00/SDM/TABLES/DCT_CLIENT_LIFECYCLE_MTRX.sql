--liquibase formatted.sql
--changeset michael.cawayan:SDM.DCT_CLIENT_LIFECYCLE_MTRX contextFilter:PH endDelimiter:/ runOnChange:true

DECLARE    
exc_already_exists EXCEPTION;    
PRAGMA EXCEPTION_INIT(exc_already_exists, -0955);
BEGIN    
EXECUTE IMMEDIATE q'{
create table SDM.DCT_CLIENT_LIFECYCLE_MTRX
    (
    ID_CUID                          INTEGER NOT NULL ENABLE,
    SKP_CLIENT                       INTEGER NOT NULL ENABLE,
    DATE_AQUISITION                  DATE,
    CNT_DPD_MAX_LAST_12M             NUMBER,
    CNT_MFA                          NUMBER,
    CNT_MOB                          NUMBER,
    CNT_MFL                          NUMBER,
    TEXT_ACQUISITION_RG              VARCHAR2(100 CHAR) NOT NULL ENABLE,
    TEXT_LATEST_OFFER_RG             VARCHAR2(100 CHAR) NOT NULL ENABLE,
    TEXT_LATEST_CONTRACT_RG          VARCHAR2(100 CHAR) NOT NULL ENABLE,
    TEXT_LATEST_CONTRACT_TYPE        VARCHAR2(100 CHAR) NOT NULL ENABLE,
    DATE_LATEST_CONTRACT             DATE NOT NULL ENABLE,
    DATE_LATEST_POS_CONTRACT         DATE NOT NULL ENABLE,
    DATE_LATEST_CLX_CONTRACT         DATE NOT NULL ENABLE,
    DATE_LATEST_VL_CONTRACT          DATE NOT NULL ENABLE,
    DATE_LATEST_CC_CONTRACT          DATE NOT NULL ENABLE,
    CODE_CLIENT_LIFESTAGE            VARCHAR2(100 CHAR) NOT NULL ENABLE,
    FLAG_NTM                         VARCHAR2(3 CHAR) NOT NULL ENABLE,
    CNT_CONTRACT                     NUMBER,
    CNT_EARLY_REPAID_CONTRACT        NUMBER NOT NULL ENABLE,
    CNT_CONTRACT_ACTIVE              NUMBER NOT NULL ENABLE,
    CNT_POS_CONTRACT                 NUMBER NOT NULL ENABLE,
    CNT_POS_CONTRACT_ACTIVE          NUMBER NOT NULL ENABLE,
    CNT_CLX_CONTRACT                 NUMBER NOT NULL ENABLE,
    CNT_CLX_CONTRACT_ACTIVE          NUMBER NOT NULL ENABLE,
    CNT_CC_CONTRACT                  NUMBER NOT NULL ENABLE,
    CNT_CC_CONTRACT_ACTIVE           NUMBER NOT NULL ENABLE,
    CNT_VL_CONTRACT                  NUMBER NOT NULL ENABLE,
    CNT_VL_CONTRACT_ACTIVE           NUMBER NOT NULL ENABLE,
    CNT_POS_OFFER                    NUMBER NOT NULL ENABLE,
    CNT_CLX_OFFER                    NUMBER NOT NULL ENABLE,
    CNT_CC_OFFER                     NUMBER NOT NULL ENABLE,
    CNT_POS_ELIG                     NUMBER NOT NULL ENABLE,
    DATE_POS_FUTURE_ELIG             DATE NOT NULL ENABLE,
    CNT_CLX_ELIG                     NUMBER NOT NULL ENABLE,
    DATE_CLX_FUTURE_ELIG             DATE NOT NULL ENABLE,
    CNT_CC_ELIG                      NUMBER NOT NULL ENABLE,
    DATE_CC_FUTURE_ELIG              DATE NOT NULL ENABLE,
    CNT_OR_POS                       NUMBER,
    CNT_OR_CLX                       NUMBER,
    CNT_OR_CC                        NUMBER,
    CNT_POS_COMMS_LAST_MONTH         NUMBER NOT NULL ENABLE,
    CNT_CLX_COMMS_LAST_MONTH         NUMBER NOT NULL ENABLE,
    CNT_CC_COMMS_LAST_MONTH          NUMBER NOT NULL ENABLE,
    NAME_PREFERENCE                  VARCHAR2(250 CHAR) NOT NULL ENABLE,
    DATE_PREFERENCE                  DATE NOT NULL ENABLE,
    NAME_NEGATIVE_RESPONSE           VARCHAR2(250 CHAR) NOT NULL ENABLE,
    DATE_NEGATIVE_RESPONSE           DATE NOT NULL ENABLE,
    TEXT_LAST_RESULT_PN              VARCHAR2(250 CHAR) NOT NULL ENABLE,
    TEXT_LAST_CAMPAIGN_PN            VARCHAR2(250 CHAR) NOT NULL ENABLE,
    DATE_LAST_PN                     DATE NOT NULL ENABLE,
    TEXT_LAST_RESULT_VIBER           VARCHAR2(250 CHAR) NOT NULL ENABLE,
    TEXT_LAST_CAMPAIGN_VIBER         VARCHAR2(250 CHAR) NOT NULL ENABLE,
    DATE_LAST_VIBER                  DATE NOT NULL ENABLE,
    TEXT_LAST_RESULT_SMS             VARCHAR2(250 CHAR) NOT NULL ENABLE,
    TEXT_LAST_CAMPAIGN_SMS           VARCHAR2(250 CHAR) NOT NULL ENABLE,
    DATE_LAST_SMS                    DATE NOT NULL ENABLE,
    TEXT_LAST_RESULT_TLS             VARCHAR2(250 CHAR) NOT NULL ENABLE,
    TEXT_LAST_CAMPAIGN_TLS           VARCHAR2(250 CHAR) NOT NULL ENABLE,
    DATE_LAST_TLS                    DATE NOT NULL ENABLE,
    TEXT_LAST_RESULT_IVR             VARCHAR2(250 CHAR) NOT NULL ENABLE,
    TEXT_LAST_CAMPAIGN_IVR           VARCHAR2(250 CHAR) NOT NULL ENABLE,
    DATE_LAST_IVR                    DATE NOT NULL ENABLE,
    FLAG_MOBAPP                      VARCHAR2(3 CHAR) NOT NULL ENABLE,
    NAME_MOBAPP_TYPE                 VARCHAR2(100 CHAR) NOT NULL ENABLE,
    CNT_DAY_MOBAPP_LAST_LOGIN        NUMBER,
    DTIME_CREATED                    DATE NOT NULL ENABLE,
    USER_INSERTED                    VARCHAR2(250 CHAR) NOT NULL ENABLE,
    CONSTRAINT PK_SKP_CLIENT2 PRIMARY KEY (SKP_CLIENT)
  USING INDEX  ENABLE
    )
}';
EXCEPTION    
WHEN exc_already_exists 
THEN NULL;
END;
/
CREATE INDEX idx_ID_CUID ON SDM.DCT_CLIENT_LIFECYCLE_MTRX (ID_CUID)
/
comment on table SDM.DCT_CLIENT_LIFECYCLE_MTRX is
'Reference table for Customer data records to be used by Field Officers'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.ID_CUID is
'Unique client identifier'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.SKP_CLIENT is
'Surrogate primary key in client table'
/
Comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_AQUISITION is
'Date of 1st contract signed'
/
Comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_MFA is
'count of Months from acquisition'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_MOB is
'Number of months active'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_MFL is
'count of month from lost'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_ACQUISITION_RG is
'risk grade collected from the first contract'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LATEST_OFFER_RG is
'risk grade collected from the latest offer'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LATEST_CONTRACT_RG is
'Foreign key identifier to Client dimension table (DCT CLIENT)'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LATEST_CONTRACT_TYPE is
'Latest contract type'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_LATEST_CONTRACT is
'Latest contract date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_LATEST_POS_CONTRACT is
'Latest POS contract date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_LATEST_CLX_CONTRACT is
'Latest CLX contract date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_LATEST_VL_CONTRACT is
'Latest VL contract date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_LATEST_CC_CONTRACT is
'Latest CC contract date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CODE_CLIENT_LIFESTAGE is
'Client lifestage'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.FLAG_NTM is
'Flag No telemarketing'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CONTRACT is
'Count of all activated contracts'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_EARLY_REPAID_CONTRACT is
'Count of all early repaid contracts'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CONTRACT_ACTIVE is
'Count of any active contracts'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_POS_CONTRACT is
'Count of POS contracts in clients history'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_POS_CONTRACT_ACTIVE is
'Count of POS active contracts in clients history'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CLX_CONTRACT is
'Count of CLX contracts in clients history'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CLX_CONTRACT_ACTIVE is
'Count CLX contract active'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CC_CONTRACT is
'Count CC contract'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CC_CONTRACT_ACTIVE is
'Count CC contract active'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_VL_CONTRACT is
'Count VL contract'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_VL_CONTRACT_ACTIVE is
'Count VL contract active'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_POS_OFFER is
'Count of POS offers'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CLX_OFFER is
'Count of CLX offers'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CC_OFFER is
'Count CC offers'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_POS_ELIG is
'Months of eligibility for respective product, resets when client loses eligibility'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_POS_FUTURE_ELIG is
'Risk metric for determining when a client will be eligible for a given product'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CLX_ELIG is
'Months of eligibility for respective product, resets when client loses eligibility'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_CLX_FUTURE_ELIG is
'Risk metric for determining when a client will be eligible for a given product'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CC_ELIG is
'Months of eligibility for respective product, resets when client loses eligibility'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_CC_FUTURE_ELIG is
'Risk metric for determining when a client will be eligible for a given product'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_OR_POS is
'Offer Resistance POS'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_OR_CLX is
'Offer Resistance CLX'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_OR_CC is
'Offer Resistance CC'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_POS_COMMS_LAST_MONTH is
'Number of delivered messages about POS product in the last calendar month'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CLX_COMMS_LAST_MONTH is
'Number of delivered messages about CLX product in the last calendar month'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.CNT_CC_COMMS_LAST_MONTH is
'Number of delivered messages about CC product in the last calendar month'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.NAME_PREFERENCE is
'Client product preference collected'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_PREFERENCE is
'Date when product preference collected'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.NAME_NEGATIVE_RESPONSE is
'Client rejected product offer '
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_NEGATIVE_RESPONSE is
'Date when rejected product offer'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LAST_RESULT_PN is
'Push Notif last result date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LAST_CAMPAIGN_PN is
'Push Notif last campaign date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_LAST_PN is
'Push Notif last communication date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LAST_RESULT_VIBER is
'Viber last result date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LAST_CAMPAIGN_VIBER is
'Viber last campaign date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_LAST_VIBER is
'Viber last communication date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LAST_RESULT_SMS is
'SMS last result date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LAST_CAMPAIGN_SMS is
'SMS last campaign date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_LAST_SMS is
'SMS last communication date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LAST_RESULT_TLS is
'Telesales last result date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LAST_CAMPAIGN_TLS is
'Telesales last campaign date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_LAST_TLS is
'Telesales last communication date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LAST_RESULT_IVR is
'IVR last result date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.TEXT_LAST_CAMPAIGN_IVR is
'IVR last campaign date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DATE_LAST_IVR is
'IVR last communication date'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.FLAG_MOBAPP is
'Flag if client has Mobile app installed'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.NAME_MOBAPP_TYPE is
'Type of app has client installed most recently'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.DTIME_CREATED is
'Date and time created'
/
comment on column SDM.DCT_CLIENT_LIFECYCLE_MTRX.USER_INSERTED is
'Username inserted'
/
GRANT SELECT ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO HCI_APP_SELECT
/
GRANT INSERT ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO HCI_APP_INSERT
/
GRANT UPDATE ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO HCI_APP_UPDATE
/
GRANT INSERT ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO APPSUPPORT
/
GRANT SELECT ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO APPSUPPORT
/
GRANT UPDATE ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO APPSUPPORT
/
GRANT ALTER	 ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT DELETE ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT INDEX	 ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT INSERT ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT SELECT ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT UPDATE ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT REFERENCES ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT READ	     ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT ON COMMIT REFRESH	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT QUERY REWRITE	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT DEBUG	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT FLASHBACK	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SDM_ETL
/
GRANT SELECT, INSERT	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO INTEGRATION
/
GRANT SELECT	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO MA_TEMP
/
GRANT SELECT, INSERT	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO CDM
/
GRANT SELECT, INSERT	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO HCPH_SDM_RO
/
GRANT SELECT, INSERT	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO HCI_RO_SDM
/
GRANT SELECT, INSERT	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO SAS_SDM_RO
/
GRANT DELETE	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO MA_TEMP
/
GRANT INSERT	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO MA_TEMP
/
GRANT UPDATE	ON SDM.DCT_CLIENT_LIFECYCLE_MTRX TO MA_TEMP
/