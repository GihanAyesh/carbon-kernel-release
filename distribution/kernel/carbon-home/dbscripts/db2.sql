CREATE TABLE REG_CLUSTER_LOCK(
    REG_LOCK_NAME VARCHAR(20) NOT NULL,
    REG_LOCK_STATUS VARCHAR(20),
    REG_LOCKED_TIME TIMESTAMP,
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0,
    CONSTRAINT PK_REG_CLUSTER_LO1 PRIMARY KEY(REG_LOCK_NAME)
)/


CREATE TABLE REG_LOG(
    REG_LOG_ID DECIMAL(31,0) NOT NULL,
    REG_PATH VARCHAR(750),
    REG_USER_ID VARCHAR(255) NOT NULL,
    REG_LOGGED_TIME TIMESTAMP NOT NULL,
    REG_ACTION DECIMAL(31,0) NOT NULL,
    REG_ACTION_DATA VARCHAR(500),
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_REG_LOG PRIMARY KEY(REG_LOG_ID,REG_TENANT_ID)
)/

CREATE INDEX REG_LOG_IND_BY_P1
    ON REG_LOG(REG_LOGGED_TIME, REG_TENANT_ID)/

CREATE SEQUENCE REG_LOG_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER REG_LOG_TRIGGER NO CASCADE BEFORE INSERT ON REG_LOG
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL 

BEGIN ATOMIC
    SET (NEW.REG_LOG_ID)
       = (NEXTVAL FOR REG_LOG_SEQUENCE);END/


CREATE TABLE REG_PATH(
    REG_PATH_ID DECIMAL(31,0)  NOT NULL,
    REG_PATH_VALUE VARCHAR(750) NOT NULL,
    REG_PATH_PARENT_ID DECIMAL(31,0),
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_PATH PRIMARY KEY(REG_PATH_ID,REG_TENANT_ID),
    CONSTRAINT UNIQUE_REG_PATH_TENANT_ID UNIQUE (REG_PATH_VALUE,REG_TENANT_ID)
)/

CREATE INDEX REG_PATH_IND_BY_P2
    ON REG_PATH(REG_PATH_PARENT_ID,REG_TENANT_ID)/

CREATE SEQUENCE REG_PATH_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER REG_PATH_TRIGGER NO CASCADE BEFORE INSERT ON REG_PATH
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.REG_PATH_ID)
       = (NEXTVAL FOR REG_PATH_SEQUENCE);END/


CREATE TABLE REG_CONTENT(
    REG_CONTENT_ID DECIMAL(31,0) NOT NULL,
    REG_CONTENT_DATA BLOB(2G) NOT LOGGED,
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_REG_CONTENT PRIMARY KEY(REG_CONTENT_ID,REG_TENANT_ID)
)/

CREATE SEQUENCE REG_CONTENT_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER REG_CONTENT_TRIGG1 NO CASCADE BEFORE INSERT ON REG_CONTENT
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
   SET (NEW.REG_CONTENT_ID)
       = (NEXTVAL FOR REG_CONTENT_SEQUENCE);END/


CREATE TABLE REG_CONTENT_HISTORY(
    REG_CONTENT_ID DECIMAL(31,0) NOT NULL,
    REG_CONTENT_DATA BLOB(2G) NOT LOGGED,
    REG_DELETED SMALLINT,
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_REG_CONTENT_HI1 PRIMARY KEY(REG_CONTENT_ID,REG_TENANT_ID)
)/


CREATE TABLE REG_RESOURCE(
    REG_PATH_ID DECIMAL(31,0) NOT NULL,
    REG_NAME VARCHAR(256),
    REG_VERSION DECIMAL(31,0) NOT NULL,
    REG_MEDIA_TYPE VARCHAR(500),
    REG_CREATOR VARCHAR(255) NOT NULL,
    REG_CREATED_TIME TIMESTAMP NOT NULL,
    REG_LAST_UPDATOR VARCHAR(255),
    REG_LAST_UPDATED_TIME TIMESTAMP NOT NULL,
    REG_DESCRIPTION VARCHAR(1000),
    REG_CONTENT_ID DECIMAL(31,0),
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    REG_UUID VARCHAR(100) NOT NULL,
    CONSTRAINT FK_REG_RES_PATH FOREIGN KEY(REG_PATH_ID,REG_TENANT_ID) REFERENCES REG_PATH(REG_PATH_ID,REG_TENANT_ID),
    CONSTRAINT PK_REG_RESOURCE PRIMARY KEY(REG_VERSION,REG_TENANT_ID)
)/

CREATE SEQUENCE REG_RESOURCE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER REG_RESOURCE_TRIG1 NO CASCADE BEFORE INSERT ON REG_RESOURCE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.REG_VERSION)
       = (NEXTVAL FOR REG_RESOURCE_SEQUENCE);END/


CREATE INDEX REG_RESOURCE_IND_1
    ON REG_RESOURCE(REG_NAME,REG_TENANT_ID)/


CREATE INDEX REG_RESOURCE_IND_2
    ON REG_RESOURCE(REG_PATH_ID,REG_NAME,REG_TENANT_ID)/

CREATE INDEX REG_RESOURCE_IND_3
    ON REG_RESOURCE(REG_UUID)/

CREATE INDEX REG_RESOURCE_IND_4
    ON REG_RESOURCE(REG_TENANT_ID, REG_UUID)/

CREATE INDEX REG_RESOURCE_IND_5
    ON REG_RESOURCE(REG_TENANT_ID, REG_MEDIA_TYPE)/

CREATE TABLE REG_RESOURCE_HISTORY(
    REG_PATH_ID DECIMAL(31,0) NOT NULL,
    REG_NAME VARCHAR(256),
    REG_VERSION DECIMAL(31,0) NOT NULL,
    REG_MEDIA_TYPE VARCHAR(500),
    REG_CREATOR VARCHAR(255) NOT NULL,
    REG_CREATED_TIME TIMESTAMP NOT NULL,
    REG_LAST_UPDATOR VARCHAR(255),
    REG_LAST_UPDATED_TIME TIMESTAMP NOT NULL,
    REG_DESCRIPTION VARCHAR(1000),
    REG_CONTENT_ID DECIMAL(31,0),
    REG_DELETED SMALLINT,
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    REG_UUID VARCHAR(100) NOT NULL,
    FOREIGN KEY(REG_PATH_ID,REG_TENANT_ID) REFERENCES REG_PATH(REG_PATH_ID,REG_TENANT_ID),
    FOREIGN KEY(REG_CONTENT_ID,REG_TENANT_ID) REFERENCES REG_CONTENT_HISTORY(REG_CONTENT_ID,REG_TENANT_ID),
    CONSTRAINT PK_REG_RESOURCE_H1 PRIMARY KEY(REG_VERSION,REG_TENANT_ID)
)/


CREATE INDEX REG_RES_HIST_IND_1
    ON REG_RESOURCE_HISTORY(REG_NAME,REG_TENANT_ID)/


CREATE INDEX REG_RES_HIST_IND_2
    ON REG_RESOURCE_HISTORY(REG_PATH_ID,REG_NAME,REG_TENANT_ID)/


CREATE TABLE REG_COMMENT(
    REG_ID DECIMAL(31,0) NOT NULL,
    REG_COMMENT_TEXT VARCHAR(500) NOT NULL,
    REG_USER_ID VARCHAR(255) NOT NULL,
    REG_COMMENTED_TIME TIMESTAMP NOT NULL,
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_REG_COMMENT PRIMARY KEY(REG_ID,REG_TENANT_ID)
)/

CREATE SEQUENCE REG_COMMENT_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER REG_COMMENT_TRIGG1 NO CASCADE BEFORE INSERT ON REG_COMMENT
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL

BEGIN ATOMIC
    SET (NEW.REG_ID)
       = (NEXTVAL FOR REG_COMMENT_SEQUENCE);END/

CREATE TABLE REG_RESOURCE_COMMENT(
    ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    REG_COMMENT_ID DECIMAL(31,0) NOT NULL,
    REG_VERSION DECIMAL(31,0),
    REG_PATH_ID DECIMAL(31,0),
    REG_RESOURCE_NAME VARCHAR(256),
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0,
    FOREIGN KEY(REG_PATH_ID,REG_TENANT_ID) REFERENCES REG_PATH(REG_PATH_ID,REG_TENANT_ID),
    FOREIGN KEY(REG_COMMENT_ID,REG_TENANT_ID) REFERENCES REG_COMMENT(REG_ID,REG_TENANT_ID),
    PRIMARY KEY(ID)
)/


CREATE INDEX REG_RES_COMM_BY_P1
    ON REG_RESOURCE_COMMENT(REG_PATH_ID,REG_RESOURCE_NAME,REG_TENANT_ID)/


CREATE INDEX REG_RES_COMM_BY_V1
    ON REG_RESOURCE_COMMENT(REG_VERSION,REG_TENANT_ID)/


CREATE TABLE REG_RATING(
    REG_ID DECIMAL(31,0) NOT NULL,
    REG_RATING DECIMAL(31,0) NOT NULL,
    REG_USER_ID VARCHAR(255) NOT NULL,
    REG_RATED_TIME TIMESTAMP NOT NULL,
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_REG_RATING PRIMARY KEY(REG_ID,REG_TENANT_ID)
)/

CREATE SEQUENCE REG_RATING_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER REG_RATING_TRIGGER NO CASCADE BEFORE INSERT ON REG_RATING
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL

BEGIN ATOMIC
    SET (NEW.REG_ID)
       = (NEXTVAL FOR REG_RATING_SEQUENCE);END/

CREATE TABLE REG_RESOURCE_RATING(
    ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    REG_RATING_ID DECIMAL(31,0) NOT NULL,
    REG_VERSION DECIMAL(31,0),
    REG_PATH_ID DECIMAL(31,0),
    REG_RESOURCE_NAME VARCHAR(256),
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0,
    FOREIGN KEY(REG_PATH_ID,REG_TENANT_ID) REFERENCES REG_PATH(REG_PATH_ID,REG_TENANT_ID),
    FOREIGN KEY(REG_RATING_ID,REG_TENANT_ID) REFERENCES REG_RATING(REG_ID,REG_TENANT_ID),
    PRIMARY KEY(ID)
)/


CREATE INDEX REG_RATING_IND_BY1
    ON REG_RESOURCE_RATING(REG_PATH_ID,REG_RESOURCE_NAME,REG_TENANT_ID)/


CREATE INDEX REG_RATING_IND_BY2
    ON REG_RESOURCE_RATING(REG_VERSION,REG_TENANT_ID)/


CREATE TABLE REG_TAG(
    REG_ID DECIMAL(31,0) NOT NULL,
    REG_TAG_NAME VARCHAR(500) NOT NULL,
    REG_USER_ID VARCHAR(255) NOT NULL,
    REG_TAGGED_TIME TIMESTAMP NOT NULL,
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_REG_TAG PRIMARY KEY(REG_ID,REG_TENANT_ID)
)/

CREATE SEQUENCE REG_TAG_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER REG_TAG_TRIGGER NO CASCADE BEFORE INSERT ON REG_TAG
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.REG_ID)
       = (NEXTVAL FOR REG_TAG_SEQUENCE);END/

CREATE TABLE REG_RESOURCE_TAG(
    ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    REG_TAG_ID DECIMAL(31,0) NOT NULL,
    REG_VERSION DECIMAL(31,0),
    REG_PATH_ID DECIMAL(31,0),
    REG_RESOURCE_NAME VARCHAR(256),
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0,
    FOREIGN KEY(REG_PATH_ID,REG_TENANT_ID) REFERENCES REG_PATH(REG_PATH_ID,REG_TENANT_ID),
    FOREIGN KEY(REG_TAG_ID,REG_TENANT_ID) REFERENCES REG_TAG(REG_ID,REG_TENANT_ID),
    PRIMARY KEY(ID)
)/


CREATE INDEX REG_TAG_IND_BY_PA1
    ON REG_RESOURCE_TAG(REG_PATH_ID,REG_RESOURCE_NAME,REG_TENANT_ID)/


CREATE INDEX REG_TAG_IND_BY_VE1
    ON REG_RESOURCE_TAG(REG_VERSION,REG_TENANT_ID)/


CREATE TABLE REG_PROPERTY(
    REG_ID DECIMAL(31,0) NOT NULL,
    REG_NAME VARCHAR(100) NOT NULL,
    REG_VALUE VARCHAR(1000),
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_REG_PROPERTY PRIMARY KEY(REG_ID,REG_TENANT_ID)
)/

CREATE SEQUENCE REG_PROPERTY_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER REG_PROPERTY_TRIG1 NO CASCADE BEFORE INSERT ON REG_PROPERTY
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.REG_ID)
       = (NEXTVAL FOR REG_PROPERTY_SEQUENCE);END/

CREATE TABLE REG_RESOURCE_PROPERTY(
    ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    REG_PROPERTY_ID DECIMAL(31,0) NOT NULL,
    REG_VERSION DECIMAL(31,0),
    REG_PATH_ID DECIMAL(31,0),
    REG_RESOURCE_NAME VARCHAR(256),
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0,
    FOREIGN KEY(REG_PATH_ID,REG_TENANT_ID) REFERENCES REG_PATH(REG_PATH_ID,REG_TENANT_ID),
    FOREIGN KEY(REG_PROPERTY_ID,REG_TENANT_ID) REFERENCES REG_PROPERTY(REG_ID,REG_TENANT_ID),
    PRIMARY KEY(ID)
)/


CREATE INDEX REG_RESC_PROP_BY_1
    ON REG_RESOURCE_PROPERTY(REG_PROPERTY_ID,REG_VERSION,REG_TENANT_ID)/


CREATE INDEX REG_RESC_PROP_BY_2
    ON REG_RESOURCE_PROPERTY(REG_PROPERTY_ID,REG_PATH_ID,REG_RESOURCE_NAME,REG_TENANT_ID)/

CREATE INDEX REG_RESC_PROP_BY_PROP_ID_TI
    ON REG_RESOURCE_PROPERTY(REG_TENANT_ID,REG_PROPERTY_ID)/

CREATE TABLE REG_ASSOCIATION(
    REG_ASSOCIATION_ID DECIMAL(31,0) NOT NULL,
    REG_SOURCEPATH VARCHAR(750) NOT NULL,
    REG_TARGETPATH VARCHAR(750) NOT NULL,
    REG_ASSOCIATION_TYPE VARCHAR(2000) NOT NULL,
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_REG_ASSOCIATION PRIMARY KEY(REG_ASSOCIATION_ID,REG_TENANT_ID)
)/

CREATE SEQUENCE REG_ASSOCIATION_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER REG_ASSOCIATION_T1 NO CASCADE BEFORE INSERT ON REG_ASSOCIATION
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.REG_ASSOCIATION_ID)
       = (NEXTVAL FOR REG_ASSOCIATION_SEQUENCE);END/

CREATE TABLE REG_SNAPSHOT(
    REG_SNAPSHOT_ID DECIMAL(31,0) NOT NULL,
    REG_PATH_ID DECIMAL(31,0) NOT NULL,
    REG_RESOURCE_NAME VARCHAR(256),
    REG_RESOURCE_VIDS BLOB(2G) NOT LOGGED NOT NULL,
    REG_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    FOREIGN KEY(REG_PATH_ID,REG_TENANT_ID) REFERENCES REG_PATH(REG_PATH_ID,REG_TENANT_ID),
    CONSTRAINT PK_REG_SNAPSHOT PRIMARY KEY(REG_SNAPSHOT_ID,REG_TENANT_ID)
)/


CREATE INDEX REG_SNAPSHOT_PATH1
    ON REG_SNAPSHOT(REG_PATH_ID,REG_RESOURCE_NAME,REG_TENANT_ID)/

CREATE SEQUENCE REG_SNAPSHOT_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER REG_SNAPSHOT_TRIG1 NO CASCADE BEFORE INSERT ON REG_SNAPSHOT
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.REG_SNAPSHOT_ID)
       = (NEXTVAL FOR REG_SNAPSHOT_SEQUENCE);END/


CREATE TABLE UM_TENANT(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_TENANT_UUID VARCHAR(36) NOT NULL,
    UM_DOMAIN_NAME VARCHAR(255) NOT NULL,
    UM_EMAIL VARCHAR(255),
    UM_ACTIVE SMALLINT DEFAULT 0,
    UM_CREATED_DATE TIMESTAMP NOT NULL,
    UM_USER_CONFIG BLOB(2G) NOT LOGGED,
    UM_ORG_UUID VARCHAR(36) DEFAULT NULL,
    PRIMARY KEY(UM_ID),
    UNIQUE(UM_DOMAIN_NAME),
    UNIQUE(UM_TENANT_UUID)
)/

CREATE UNIQUE INDEX INDEX_UM_TENANT_UM_DOMAIN_NAME
                    ON UM_TENANT (UM_DOMAIN_NAME)/

CREATE INDEX INDEX_UM_TENANT_ORG_UUID ON UM_TENANT(UM_ORG_UUID)/

CREATE SEQUENCE UM_TENANT_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_TENANT_TRIGGER NO CASCADE BEFORE INSERT ON UM_TENANT
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_TENANT_SEQUENCE);END/

CREATE TABLE UM_DOMAIN(
            UM_DOMAIN_ID DECIMAL(31,0) NOT NULL,
            UM_DOMAIN_NAME VARCHAR(255) NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0 NOT NULL,
            PRIMARY KEY (UM_DOMAIN_ID, UM_TENANT_ID),
            UNIQUE(UM_DOMAIN_NAME,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_DOMAIN_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_DOMAIN_TRIGGER NO CASCADE BEFORE INSERT ON UM_DOMAIN
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_DOMAIN_ID)
       = (NEXTVAL FOR UM_DOMAIN_SEQUENCE);END/


CREATE TABLE UM_USER(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_USER_ID VARCHAR(255) NOT NULL,
    UM_USER_NAME VARCHAR(255) NOT NULL,
    UM_USER_PASSWORD VARCHAR(255) NOT NULL,
    UM_SALT_VALUE VARCHAR(31),
    UM_REQUIRE_CHANGE SMALLINT DEFAULT 0,
    UM_CHANGED_TIME TIMESTAMP NOT NULL,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    PRIMARY KEY(UM_ID,UM_TENANT_ID),
    UNIQUE(UM_USER_ID),
    UNIQUE(UM_USER_NAME, UM_TENANT_ID)
)/

CREATE UNIQUE INDEX INDEX_UM_USERNAME_UM_TENANT_ID ON UM_USER(UM_USER_NAME, UM_TENANT_ID)/

CREATE SEQUENCE UM_USER_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_USER_TRIGGER NO CASCADE BEFORE INSERT ON UM_USER
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_USER_SEQUENCE);END/

CREATE TABLE UM_SYSTEM_USER (
             UM_ID DECIMAL(31,0) NOT NULL,
             UM_USER_NAME VARCHAR(255) NOT NULL,
             UM_USER_PASSWORD VARCHAR(255) NOT NULL,
             UM_SALT_VALUE VARCHAR(31),
             UM_REQUIRE_CHANGE SMALLINT DEFAULT 0,
             UM_CHANGED_TIME TIMESTAMP NOT NULL,
             UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
             PRIMARY KEY (UM_ID, UM_TENANT_ID),
             UNIQUE(UM_USER_NAME, UM_TENANT_ID)
)/

CREATE SEQUENCE UM_SYSTEM_USER_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_SYSTEM_USER_TRIGGER NO CASCADE BEFORE INSERT ON UM_SYSTEM_USER
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_SYSTEM_USER_SEQUENCE);END/

CREATE TABLE UM_USER_ATTRIBUTE(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_ATTR_NAME VARCHAR(255) NOT NULL,
    UM_ATTR_VALUE VARCHAR(255),
    UM_PROFILE_ID VARCHAR(255),
    UM_USER_ID DECIMAL(31,0),
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    FOREIGN KEY(UM_USER_ID,UM_TENANT_ID) REFERENCES UM_USER(UM_ID,UM_TENANT_ID) ON DELETE CASCADE ,
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE INDEX UM_USER_ID_INDEX ON UM_USER_ATTRIBUTE(UM_USER_ID)/

CREATE INDEX UM_ATTR_NAME_VALUE_INDEX ON UM_USER_ATTRIBUTE(UM_ATTR_NAME, UM_ATTR_VALUE)/

CREATE SEQUENCE UM_USER_ATTRIBUTE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_USER_ATTRIBUTE1 NO CASCADE BEFORE INSERT ON UM_USER_ATTRIBUTE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_USER_ATTRIBUTE_SEQUENCE);END/


CREATE TABLE UM_ROLE(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_ROLE_NAME VARCHAR(255) NOT NULL,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UM_SHARED_ROLE SMALLINT DEFAULT 0,
    PRIMARY KEY(UM_ID,UM_TENANT_ID),
    UNIQUE(UM_ROLE_NAME,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_ROLE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_ROLE_TRIGGER NO CASCADE BEFORE INSERT ON UM_ROLE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_ROLE_SEQUENCE);END/

CREATE TABLE UM_MODULE(
	UM_ID INTEGER  NOT NULL,
	UM_MODULE_NAME VARCHAR(100) NOT NULL,
	PRIMARY KEY(UM_ID),
	UNIQUE(UM_MODULE_NAME)
)/


CREATE SEQUENCE UM_MODULE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_MODULE_TRIGGER NO CASCADE BEFORE INSERT ON UM_MODULE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_MODULE_SEQUENCE);END/


CREATE TABLE UM_MODULE_ACTIONS(
	UM_ACTION VARCHAR(255) NOT NULL,
	UM_MODULE_ID INTEGER NOT NULL,
	PRIMARY KEY(UM_ACTION, UM_MODULE_ID),
	FOREIGN KEY (UM_MODULE_ID) REFERENCES UM_MODULE(UM_ID) ON DELETE CASCADE
)/

CREATE TABLE UM_PERMISSION(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_RESOURCE_ID VARCHAR(255) NOT NULL,
    UM_ACTION VARCHAR(255) NOT NULL,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UM_MODULE_ID INTEGER DEFAULT 0,
    UNIQUE(UM_RESOURCE_ID,UM_ACTION, UM_TENANT_ID),
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_PERMISSION_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_PERMISSION_TRI1 NO CASCADE BEFORE INSERT ON UM_PERMISSION
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_PERMISSION_SEQUENCE);END/

CREATE INDEX INDEX_UM_PERMISSION_UM_RESOURCE_ID_UM_ACTION
    ON UM_PERMISSION (UM_RESOURCE_ID, UM_ACTION, UM_TENANT_ID)/

CREATE TABLE UM_ROLE_PERMISSION(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_PERMISSION_ID DECIMAL(31,0) NOT NULL,
    UM_ROLE_NAME VARCHAR(255) NOT NULL,
    UM_IS_ALLOWED SMALLINT NOT NULL,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UM_DOMAIN_ID DECIMAL(31,0) NOT NULL,
    UNIQUE(UM_PERMISSION_ID,UM_ROLE_NAME,UM_TENANT_ID,UM_DOMAIN_ID),
    FOREIGN KEY(UM_PERMISSION_ID,UM_TENANT_ID) REFERENCES UM_PERMISSION(UM_ID,UM_TENANT_ID) ON DELETE CASCADE ,
    FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE,
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE INDEX INDEX_ROLE_PERMSN_TI_RN ON UM_ROLE_PERMISSION(UM_TENANT_ID,UM_ROLE_NAME)/

CREATE SEQUENCE UM_ROLE_PERMISSION_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_ROLE_PERMISSIO1 NO CASCADE BEFORE INSERT ON UM_ROLE_PERMISSION
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_ROLE_PERMISSION_SEQUENCE);END/


CREATE TABLE UM_USER_PERMISSION(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_PERMISSION_ID DECIMAL(31,0) NOT NULL,
    UM_USER_NAME VARCHAR(255) NOT NULL,
    UM_IS_ALLOWED SMALLINT NOT NULL,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UNIQUE(UM_PERMISSION_ID,UM_USER_NAME,UM_TENANT_ID),
    FOREIGN KEY(UM_PERMISSION_ID,UM_TENANT_ID) REFERENCES UM_PERMISSION(UM_ID,UM_TENANT_ID) ON DELETE CASCADE,
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_USER_PERMISSION_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_USER_PERMISSIO1 NO CASCADE BEFORE INSERT ON UM_USER_PERMISSION
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_USER_PERMISSION_SEQUENCE);END/


CREATE TABLE UM_USER_ROLE(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_ROLE_ID DECIMAL(31,0) NOT NULL,
    UM_USER_ID DECIMAL(31,0) NOT NULL,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UNIQUE(UM_USER_ID,UM_ROLE_ID,UM_TENANT_ID),
    FOREIGN KEY(UM_ROLE_ID,UM_TENANT_ID) REFERENCES UM_ROLE(UM_ID,UM_TENANT_ID),
    FOREIGN KEY(UM_USER_ID,UM_TENANT_ID) REFERENCES UM_USER(UM_ID,UM_TENANT_ID),
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_USER_ROLE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_USER_ROLE_TRIG1 NO CASCADE BEFORE INSERT ON UM_USER_ROLE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_USER_ROLE_SEQUENCE);END/

CREATE TABLE UM_ACCOUNT_MAPPING(
	UM_ID INTEGER NOT NULL,
	UM_USER_NAME VARCHAR(255) NOT NULL,
	UM_TENANT_ID INTEGER NOT NULL,
	UM_USER_STORE_DOMAIN VARCHAR(100) NOT NULL,
	UM_ACC_LINK_ID INTEGER NOT NULL,
	UNIQUE(UM_USER_NAME, UM_TENANT_ID, UM_USER_STORE_DOMAIN, UM_ACC_LINK_ID),
	FOREIGN KEY (UM_TENANT_ID) REFERENCES UM_TENANT(UM_ID) ON DELETE CASCADE,
	PRIMARY KEY (UM_ID)
)/

CREATE SEQUENCE UM_ACCOUNT_MAPPING_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_ACCOUNT_MAPPING_TRIG1 NO CASCADE BEFORE INSERT ON UM_ACCOUNT_MAPPING
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_ACCOUNT_MAPPING_SEQUENCE);END/

CREATE TABLE UM_SHARED_USER_ROLE(
    ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    UM_ROLE_ID DECIMAL(31,0) NOT NULL,
    UM_USER_ID DECIMAL(31,0) NOT NULL,
    UM_USER_TENANT_ID DECIMAL(31,0) NOT NULL,
    UM_ROLE_TENANT_ID DECIMAL(31,0) NOT NULL,
    UNIQUE(UM_USER_ID,UM_ROLE_ID,UM_USER_TENANT_ID, UM_ROLE_TENANT_ID),
    FOREIGN KEY(UM_ROLE_ID,UM_ROLE_TENANT_ID) REFERENCES UM_ROLE(UM_ID,UM_TENANT_ID) ON DELETE CASCADE ,
    FOREIGN KEY(UM_USER_ID,UM_USER_TENANT_ID) REFERENCES UM_USER(UM_ID,UM_TENANT_ID) ON DELETE CASCADE,
    PRIMARY KEY(ID)
)/

CREATE TABLE UM_DIALECT(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_DIALECT_URI VARCHAR(255) NOT NULL,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UNIQUE(UM_DIALECT_URI,UM_TENANT_ID),
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_DIALECT_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_DIALECT_TRIGGER NO CASCADE BEFORE INSERT ON UM_DIALECT
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_DIALECT_SEQUENCE);END/


CREATE TABLE UM_CLAIM(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_DIALECT_ID DECIMAL(31,0) NOT NULL,
    UM_CLAIM_URI VARCHAR(255) NOT NULL,
    UM_DISPLAY_TAG VARCHAR(255),
    UM_DESCRIPTION VARCHAR(255),
    UM_MAPPED_ATTRIBUTE_DOMAIN VARCHAR(255),
    UM_MAPPED_ATTRIBUTE VARCHAR(255),
    UM_REG_EX VARCHAR(255),
    UM_SUPPORTED SMALLINT,
    UM_REQUIRED SMALLINT,
    UM_DISPLAY_ORDER DECIMAL(31,0),
    UM_CHECKED_ATTRIBUTE SMALLINT,
    UM_READ_ONLY SMALLINT,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UNIQUE(UM_DIALECT_ID,UM_CLAIM_URI,UM_TENANT_ID),
    FOREIGN KEY(UM_DIALECT_ID,UM_TENANT_ID) REFERENCES UM_DIALECT(UM_ID,UM_TENANT_ID),
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_CLAIM_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_CLAIM_TRIGGER NO CASCADE BEFORE INSERT ON UM_CLAIM
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_CLAIM_SEQUENCE);END/


CREATE TABLE UM_PROFILE_CONFIG(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_DIALECT_ID DECIMAL(31,0),
    UM_PROFILE_NAME VARCHAR(255),
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    FOREIGN KEY(UM_DIALECT_ID,UM_TENANT_ID) REFERENCES UM_DIALECT(UM_ID,UM_TENANT_ID),
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_PROFILE_CONFIG_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_PROFILE_CONFIG1 NO CASCADE BEFORE INSERT ON UM_PROFILE_CONFIG
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_PROFILE_CONFIG_SEQUENCE);END/


CREATE TABLE UM_CLAIM_BEHAVIOR(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_PROFILE_ID DECIMAL(31,0),
    UM_CLAIM_ID DECIMAL(31,0),
    UM_BEHAVIOUR SMALLINT,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    FOREIGN KEY(UM_PROFILE_ID,UM_TENANT_ID) REFERENCES UM_PROFILE_CONFIG(UM_ID,UM_TENANT_ID),
    FOREIGN KEY(UM_CLAIM_ID,UM_TENANT_ID) REFERENCES UM_CLAIM(UM_ID,UM_TENANT_ID),
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_CLAIM_BEHAVIOR_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_CLAIM_BEHAVIOR1 NO CASCADE BEFORE INSERT ON UM_CLAIM_BEHAVIOR
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_CLAIM_BEHAVIOR_SEQUENCE);END/


CREATE TABLE UM_HYBRID_ROLE_AUDIENCE(
            UM_ID DECIMAL(31,0) NOT NULL,
            UM_AUDIENCE VARCHAR(255) NOT NULL,
            UM_AUDIENCE_ID VARCHAR(255) NOT NULL,
            UNIQUE (UM_AUDIENCE, UM_AUDIENCE_ID),
            PRIMARY KEY (UM_ID)
);

CREATE SEQUENCE UM_HYBRID_ROLE_AUDIENCE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_HYBRID_ROLE_AUDIENCE_TR1 NO CASCADE BEFORE INSERT ON UM_HYBRID_ROLE_AUDIENCE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_HYBRID_ROLE_AUDIENCE_SEQUENCE);END/

CREATE TABLE UM_HYBRID_ROLE(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_ROLE_NAME VARCHAR(255) NOT NULL,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UM_AUDIENCE_REF_ID DECIMAL(31,0) DEFAULT -1 NOT NULL,
    UM_UUID VARCHAR(36),
    PRIMARY KEY(UM_ID,UM_TENANT_ID),
    UNIQUE(UM_ROLE_NAME,UM_TENANT_ID,UM_AUDIENCE_REF_ID)
)/

CREATE SEQUENCE UM_HYBRID_ROLE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_HYBRID_ROLE_TR1 NO CASCADE BEFORE INSERT ON UM_HYBRID_ROLE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_HYBRID_ROLE_SEQUENCE);END/


CREATE TABLE UM_HYBRID_USER_ROLE(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_USER_NAME VARCHAR(255) NOT NULL,
    UM_ROLE_ID DECIMAL(31,0) NOT NULL,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UM_DOMAIN_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UNIQUE(UM_USER_NAME,UM_ROLE_ID,UM_TENANT_ID),
    FOREIGN KEY(UM_ROLE_ID,UM_TENANT_ID) REFERENCES UM_HYBRID_ROLE(UM_ID,UM_TENANT_ID) ON DELETE CASCADE,
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_HYBRID_USER_ROLE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_HYBRID_USER_RO1 NO CASCADE BEFORE INSERT ON UM_HYBRID_USER_ROLE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_HYBRID_USER_ROLE_SEQUENCE);END/


CREATE TABLE UM_HYBRID_GROUP_ROLE(
    UM_ID DECIMAL(31,0) NOT NULL,
    UM_GROUP_NAME VARCHAR(255) NOT NULL,
    UM_ROLE_ID DECIMAL(31,0) NOT NULL,
    UM_TENANT_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UM_DOMAIN_ID DECIMAL(31,0) DEFAULT 0 NOT NULL,
    UNIQUE(UM_GROUP_NAME,UM_ROLE_ID,UM_TENANT_ID),
    FOREIGN KEY(UM_ROLE_ID,UM_TENANT_ID) REFERENCES UM_HYBRID_ROLE(UM_ID,UM_TENANT_ID) ON DELETE CASCADE,
    PRIMARY KEY(UM_ID,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_HYBRID_GROUP_ROLE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_HYBRID_GROUP_RO1 NO CASCADE BEFORE INSERT ON UM_HYBRID_GROUP_ROLE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_HYBRID_GROUP_ROLE_SEQUENCE);END/


CREATE TABLE UM_SYSTEM_ROLE(
            UM_ID DECIMAL(31,0) NOT NULL,
            UM_ROLE_NAME VARCHAR(255) NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0 NOT NULL,
            PRIMARY KEY (UM_ID, UM_TENANT_ID),
            UNIQUE(UM_ROLE_NAME,UM_TENANT_ID)
)/

CREATE SEQUENCE UM_SYSTEM_ROLE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_SYSTEM_ROLE_TRIGGER NO CASCADE BEFORE INSERT ON UM_SYSTEM_ROLE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_SYSTEM_ROLE_SEQUENCE);END/

CREATE TABLE UM_SYSTEM_USER_ROLE(
            UM_ID DECIMAL(31,0) NOT NULL,
            UM_USER_NAME VARCHAR(255) NOT NULL,
            UM_ROLE_ID INTEGER NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0 NOT NULL,
            UNIQUE (UM_USER_NAME, UM_ROLE_ID, UM_TENANT_ID),
            FOREIGN KEY (UM_ROLE_ID, UM_TENANT_ID) REFERENCES UM_SYSTEM_ROLE(UM_ID, UM_TENANT_ID),
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
)/

CREATE SEQUENCE UM_SYSTEM_USER_ROLE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UM_SYSTEM_USER_ROLE_TRIGGER NO CASCADE BEFORE INSERT ON UM_SYSTEM_USER_ROLE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_SYSTEM_USER_ROLE_SEQUENCE);END/


CREATE TABLE UM_HYBRID_REMEMBER_ME (
            UM_ID DECIMAL(31,0) NOT NULL,
			UM_USER_NAME VARCHAR(255) NOT NULL,
			UM_COOKIE_VALUE VARCHAR(1024),
			UM_CREATED_TIME TIMESTAMP,
            UM_TENANT_ID INTEGER DEFAULT 0 NOT NULL,
			PRIMARY KEY (UM_ID, UM_TENANT_ID)
)/

CREATE SEQUENCE UM_HYBRID_REMEMBER_ME_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UMHYBRID_REMEMB_ME NO CASCADE BEFORE INSERT ON UM_HYBRID_REMEMBER_ME
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_HYBRID_REMEMBER_ME_SEQUENCE);END/

CREATE TABLE UM_UUID_DOMAIN_MAPPER (
            UM_ID INTEGER NOT NULL,
            UM_USER_ID VARCHAR(255) NOT NULL,
            UM_DOMAIN_ID INTEGER NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (UM_ID),
            UNIQUE (UM_USER_ID),
            FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE
)/

CREATE SEQUENCE UM_UUID_DOMAIN_MAPPER_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UMUUID_DOMAIN_MAPPER NO CASCADE BEFORE INSERT ON UM_UUID_DOMAIN_MAPPER
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_UUID_DOMAIN_MAPPER_SEQUENCE);END/

CREATE INDEX UUID_DM_UID_TID ON UM_UUID_DOMAIN_MAPPER(UM_USER_ID, UM_TENANT_ID)/

CREATE TABLE UM_GROUP_UUID_DOMAIN_MAPPER (
            UM_ID INTEGER NOT NULL,
            UM_GROUP_ID VARCHAR(255) NOT NULL,
            UM_DOMAIN_ID INTEGER NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (UM_ID),
            UNIQUE (UM_GROUP_ID),
            FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE
)/

CREATE SEQUENCE UM_GROUP_UUID_DOMAIN_MAPPER_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/


CREATE TRIGGER UMGROUP_UUID_DOMAIN_MAPPER NO CASCADE BEFORE INSERT ON UM_GROUP_UUID_DOMAIN_MAPPER
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_GROUP_UUID_DOMAIN_MAPPER_SEQUENCE);END/

CREATE INDEX UUID_GRP_UID_TID ON UM_GROUP_UUID_DOMAIN_MAPPER(UM_GROUP_ID, UM_TENANT_ID)/

-- ################################
-- ORGANIZATION MANAGEMENT TABLES
-- ################################

CREATE TABLE IF NOT EXISTS UM_ORG (
            UM_ID VARCHAR(36) NOT NULL,
            UM_ORG_NAME VARCHAR(255) NOT NULL,
            UM_ORG_DESCRIPTION VARCHAR(1024),
            UM_CREATED_TIME TIMESTAMP NOT NULL,
            UM_LAST_MODIFIED TIMESTAMP NOT NULL,
            UM_STATUS VARCHAR(255) DEFAULT 'ACTIVE' NOT NULL,
            UM_PARENT_ID VARCHAR(36),
            UM_ORG_TYPE VARCHAR(100) NOT NULL,
            PRIMARY KEY (UM_ID),
            FOREIGN KEY (UM_PARENT_ID) REFERENCES UM_ORG(UM_ID) ON DELETE CASCADE
)/

INSERT INTO UM_ORG (UM_ID, UM_ORG_NAME, UM_ORG_DESCRIPTION, UM_CREATED_TIME, UM_LAST_MODIFIED, UM_STATUS, UM_ORG_TYPE)
SELECT '10084a8d-113f-4211-a0d5-efe36b082211', 'Super', 'This is the super organization.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'ACTIVE', 'TENANT' FROM "SYSIBM".SYSDUMMY1
WHERE NOT EXISTS (SELECT * FROM UM_ORG WHERE UM_ID = '10084a8d-113f-4211-a0d5-efe36b082211')/

CREATE TABLE IF NOT EXISTS UM_ORG_ATTRIBUTE (
            UM_ID INTEGER NOT NULL,
            UM_ORG_ID VARCHAR(36) NOT NULL,
            UM_ATTRIBUTE_KEY VARCHAR(255) NOT NULL,
            UM_ATTRIBUTE_VALUE VARCHAR(512),
            PRIMARY KEY (UM_ID),
            UNIQUE (UM_ORG_ID, UM_ATTRIBUTE_KEY),
            FOREIGN KEY (UM_ORG_ID) REFERENCES UM_ORG(UM_ID) ON DELETE CASCADE
)/

CREATE SEQUENCE UM_ORG_ATTRIBUTE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_ORG_ATTRIBUTE_TRIG NO CASCADE BEFORE INSERT ON UM_ORG_ATTRIBUTE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_ORG_ATTRIBUTE_SEQUENCE);END/

CREATE TABLE IF NOT EXISTS UM_ORG_ROLE (
            UM_ROLE_ID VARCHAR(255) NOT NULL,
            UM_ROLE_NAME VARCHAR(255) NOT NULL,
            UM_ORG_ID VARCHAR(36) NOT NULL,
            PRIMARY KEY(UM_ROLE_ID),
            CONSTRAINT FK_UM_ORG_ROLE_UM_ORG FOREIGN KEY (UM_ORG_ID) REFERENCES UM_ORG (UM_ID) ON DELETE CASCADE
)/

CREATE TABLE IF NOT EXISTS UM_ORG_PERMISSION(
            UM_ID INTEGER NOT NULL,
            UM_RESOURCE_ID VARCHAR(255) NOT NULL,
            UM_ACTION VARCHAR(255) NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (UM_ID)
)/

CREATE SEQUENCE UM_ORG_PERMISSION_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_ORG_PERMISSION_TRIG NO CASCADE BEFORE INSERT ON UM_ORG_PERMISSION
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_ORG_PERMISSION_SEQUENCE);END/

CREATE TABLE IF NOT EXISTS UM_ORG_ROLE_USER (
            UM_USER_ID VARCHAR(255) NOT NULL,
            UM_ROLE_ID VARCHAR(255) NOT NULL,
            UM_USER_RESIDENT_ORG_ID VARCHAR(36),
            CONSTRAINT FK_UM_ORG_ROLE_USER_UM_ORG_ROLE FOREIGN KEY (UM_ROLE_ID) REFERENCES UM_ORG_ROLE(UM_ROLE_ID) ON DELETE CASCADE
)/

CREATE TABLE IF NOT EXISTS UM_ORG_ROLE_GROUP(
            UM_GROUP_ID VARCHAR(255) NOT NULL,
            UM_ROLE_ID VARCHAR(255) NOT NULL,
            CONSTRAINT FK_UM_ORG_ROLE_GROUP_UM_ORG_ROLE FOREIGN KEY (UM_ROLE_ID) REFERENCES UM_ORG_ROLE(UM_ROLE_ID) ON DELETE CASCADE
)/

CREATE TABLE IF NOT EXISTS UM_ORG_ROLE_PERMISSION(
            UM_PERMISSION_ID INTEGER NOT NULL,
            UM_ROLE_ID VARCHAR(255) NOT NULL,
            CONSTRAINT FK_UM_ORG_ROLE_PERMISSION_UM_ORG_ROLE FOREIGN KEY (UM_ROLE_ID) REFERENCES UM_ORG_ROLE(UM_ROLE_ID) ON DELETE CASCADE,
            CONSTRAINT FK_UM_ORG_ROLE_PERMISSION_UM_ORG_PERMISSION FOREIGN KEY (UM_PERMISSION_ID) REFERENCES UM_ORG_PERMISSION(UM_ID) ON DELETE CASCADE
)/

CREATE TABLE UM_ORG_HIERARCHY (
            UM_PARENT_ID VARCHAR(36) NOT NULL,
            UM_ID VARCHAR(36) NOT NULL,
            DEPTH INTEGER,
            PRIMARY KEY (UM_PARENT_ID, UM_ID),
            FOREIGN KEY (UM_PARENT_ID) REFERENCES UM_ORG(UM_ID) ON DELETE CASCADE,
            FOREIGN KEY (UM_ID) REFERENCES UM_ORG(UM_ID) ON DELETE CASCADE
)/

CREATE TABLE UM_IDP_GROUP_ROLE(
            UM_ROLE_ID INTEGER NOT NULL,
            UM_GROUP_ID VARCHAR(36) NOT NULL,
            UM_TENANT_ID INTEGER NOT NULL,
            PRIMARY KEY (UM_ROLE_ID, UM_GROUP_ID, UM_TENANT_ID),
            FOREIGN KEY (UM_ROLE_ID, UM_TENANT_ID) REFERENCES UM_HYBRID_ROLE(UM_ID, UM_TENANT_ID) ON DELETE CASCADE
)/

CREATE TABLE UM_SHARED_ROLE(
            UM_ID DECIMAL(31,0) NOT NULL,
            UM_SHARED_ROLE_ID INTEGER NOT NULL,
            UM_MAIN_ROLE_ID INTEGER NOT NULL,
            UM_SHARED_ROLE_TENANT_ID INTEGER NOT NULL,
            UM_MAIN_ROLE_TENANT_ID INTEGER NOT NULL,
            PRIMARY KEY (UM_ID),
            UNIQUE (UM_SHARED_ROLE_ID, UM_MAIN_ROLE_ID, UM_SHARED_ROLE_TENANT_ID),
            FOREIGN KEY (UM_SHARED_ROLE_ID, UM_SHARED_ROLE_TENANT_ID) REFERENCES UM_HYBRID_ROLE(UM_ID, UM_TENANT_ID) ON DELETE CASCADE,
            FOREIGN KEY (UM_MAIN_ROLE_ID, UM_MAIN_ROLE_TENANT_ID) REFERENCES UM_HYBRID_ROLE(UM_ID, UM_TENANT_ID) ON DELETE CASCADE
)/

CREATE SEQUENCE UM_SHARED_ROLE_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_SHARED_ROLE_TR1 NO CASCADE BEFORE INSERT ON UM_SHARED_ROLE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_SHARED_ROLE_SEQUENCE);END/


INSERT INTO UM_ORG_HIERARCHY (UM_PARENT_ID, UM_ID, DEPTH)
SELECT '10084a8d-113f-4211-a0d5-efe36b082211', '10084a8d-113f-4211-a0d5-efe36b082211', 0 FROM "SYSIBM".SYSDUMMY1
WHERE NOT EXISTS (SELECT * FROM UM_ORG_HIERARCHY WHERE UM_PARENT_ID = '10084a8d-113f-4211-a0d5-efe36b082211' AND UM_ID = '10084a8d-113f-4211-a0d5-efe36b082211')/

CREATE TABLE IF NOT EXISTS UM_ORG_DISCOVERY (
            UM_ID INTEGER NOT NULL,
            UM_ORG_ID VARCHAR(36) NOT NULL,
            UM_ROOT_ORG_ID VARCHAR(36) NOT NULL,
            UM_DISCOVERY_TYPE VARCHAR(255) NOT NULL,
            UM_DISCOVERY_VALUE VARCHAR(255) NOT NULL,
            PRIMARY KEY (UM_ID),
            UNIQUE (UM_ROOT_ORG_ID, UM_DISCOVERY_TYPE, UM_DISCOVERY_VALUE),
            FOREIGN KEY (UM_ROOT_ORG_ID) REFERENCES UM_ORG(UM_ID) ON DELETE CASCADE,
            FOREIGN KEY (UM_ORG_ID) REFERENCES UM_ORG(UM_ID) ON DELETE CASCADE
)/

CREATE TABLE IF NOT EXISTS UM_ORG_USER_ASSOCIATION (
	SHARED_USER_ID VARCHAR(255) NOT NULL,
	SHARED_ORG_ID VARCHAR(36) NOT NULL,
	REAL_USER_ID VARCHAR(255) NOT NULL,
	USER_RESIDENT_ORG_ID VARCHAR(36) NOT NULL,
	PRIMARY KEY (SHARED_USER_ID, SHARED_ORG_ID, REAL_USER_ID, USER_RESIDENT_ORG_ID)
)/

CREATE SEQUENCE UM_ORG_DISCOVERY_SEQUENCE AS DECIMAL(27,0)
    INCREMENT BY 1
    START WITH 1
    NO CACHE/

CREATE TRIGGER UM_ORG_DISCOVERY_TRIG NO CASCADE BEFORE INSERT ON UM_ORG_DISCOVERY
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC
    SET (NEW.UM_ID)
       = (NEXTVAL FOR UM_ORG_DISCOVERY_SEQUENCE);END/
