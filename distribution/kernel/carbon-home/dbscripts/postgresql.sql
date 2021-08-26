DROP TABLE IF EXISTS REG_CLUSTER_LOCK;
CREATE TABLE REG_CLUSTER_LOCK (
             REG_LOCK_NAME VARCHAR (20),
             REG_LOCK_STATUS VARCHAR (20),
             REG_LOCKED_TIME TIMESTAMP,
             REG_TENANT_ID INTEGER DEFAULT 0,
             PRIMARY KEY (REG_LOCK_NAME)
);

DROP TABLE IF EXISTS REG_LOG;
DROP SEQUENCE IF EXISTS REG_LOG_PK_SEQ;
CREATE SEQUENCE REG_LOG_PK_SEQ;
CREATE TABLE REG_LOG (
             REG_LOG_ID INTEGER DEFAULT NEXTVAL('REG_LOG_PK_SEQ'),
             REG_PATH VARCHAR (2000),
             REG_USER_ID VARCHAR (255) NOT NULL,
             REG_LOGGED_TIME TIMESTAMP NOT NULL,
             REG_ACTION INTEGER NOT NULL,
             REG_ACTION_DATA VARCHAR (500),
             REG_TENANT_ID INTEGER DEFAULT 0,
             PRIMARY KEY (REG_LOG_ID, REG_TENANT_ID)
);

CREATE INDEX REG_LOG_IND_BY_REG_LOGTIME ON REG_LOG(REG_LOGGED_TIME, REG_TENANT_ID);

DROP TABLE IF EXISTS REG_PATH;
DROP SEQUENCE IF EXISTS REG_PATH_PK_SEQ;
CREATE SEQUENCE REG_PATH_PK_SEQ;
CREATE TABLE REG_PATH(
             REG_PATH_ID INTEGER DEFAULT NEXTVAL('REG_PATH_PK_SEQ'),
             REG_PATH_VALUE VARCHAR(2000) NOT NULL,
             REG_PATH_PARENT_ID INTEGER,
             REG_TENANT_ID INTEGER DEFAULT 0,
             CONSTRAINT PK_REG_PATH PRIMARY KEY(REG_PATH_ID, REG_TENANT_ID),
             CONSTRAINT UNIQUE_REG_PATH_TENANT_ID UNIQUE (REG_PATH_VALUE,REG_TENANT_ID)
);

CREATE INDEX REG_PATH_IND_BY_PATH_PARENT_ID  ON REG_PATH(REG_PATH_PARENT_ID, REG_TENANT_ID);

DROP TABLE IF EXISTS REG_CONTENT;
DROP SEQUENCE IF EXISTS REG_CONTENT_PK_SEQ;
CREATE SEQUENCE REG_CONTENT_PK_SEQ;
CREATE TABLE REG_CONTENT (
             REG_CONTENT_ID INTEGER DEFAULT NEXTVAL('REG_CONTENT_PK_SEQ'),
             REG_CONTENT_DATA BYTEA,
             REG_TENANT_ID INTEGER DEFAULT 0,
             CONSTRAINT PK_REG_CONTENT PRIMARY KEY(REG_CONTENT_ID, REG_TENANT_ID)
);

DROP TABLE IF EXISTS REG_CONTENT_HISTORY;
CREATE TABLE REG_CONTENT_HISTORY (
             REG_CONTENT_ID INTEGER NOT NULL,
             REG_CONTENT_DATA BYTEA,
             REG_DELETED   SMALLINT,
             REG_TENANT_ID INTEGER DEFAULT 0,
             CONSTRAINT PK_REG_CONTENT_HISTORY PRIMARY KEY(REG_CONTENT_ID, REG_TENANT_ID)
);

DROP TABLE IF EXISTS REG_RESOURCE;
DROP SEQUENCE IF EXISTS REG_RESOURCE_PK_SEQ;
CREATE SEQUENCE REG_RESOURCE_PK_SEQ;
CREATE TABLE REG_RESOURCE (
            REG_PATH_ID         INTEGER NOT NULL,
            REG_NAME            VARCHAR(256),
            REG_VERSION         INTEGER DEFAULT NEXTVAL('REG_RESOURCE_PK_SEQ'),
            REG_MEDIA_TYPE      VARCHAR(500),
            REG_CREATOR         VARCHAR(255) NOT NULL,
            REG_CREATED_TIME    TIMESTAMP NOT NULL,
            REG_LAST_UPDATOR    VARCHAR(255),
            REG_LAST_UPDATED_TIME    TIMESTAMP NOT NULL,
            REG_DESCRIPTION     VARCHAR(1000),
            REG_CONTENT_ID      INTEGER,
            REG_TENANT_ID INTEGER DEFAULT 0,
            REG_UUID VARCHAR(100) NOT NULL,
            CONSTRAINT PK_REG_RESOURCE PRIMARY KEY(REG_VERSION, REG_TENANT_ID)
);

ALTER TABLE REG_RESOURCE ADD CONSTRAINT REG_RESOURCE_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
ALTER TABLE REG_RESOURCE ADD CONSTRAINT REG_RESOURCE_FK_BY_CONTENT_ID FOREIGN KEY (REG_CONTENT_ID, REG_TENANT_ID) REFERENCES REG_CONTENT (REG_CONTENT_ID, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_IND_BY_NAME  ON REG_RESOURCE(REG_NAME, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_IND_BY_PATH_ID_NAME  ON REG_RESOURCE(REG_PATH_ID, REG_NAME, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_IND_BY_UUID  ON REG_RESOURCE(REG_UUID);
CREATE INDEX REG_RESOURCE_IND_BY_TENANT ON REG_RESOURCE(REG_TENANT_ID, REG_UUID);
CREATE INDEX REG_RESOURCE_IND_BY_TYPE ON REG_RESOURCE(REG_TENANT_ID, REG_MEDIA_TYPE);

DROP TABLE IF EXISTS REG_RESOURCE_HISTORY;
CREATE TABLE REG_RESOURCE_HISTORY (
            REG_PATH_ID         INTEGER NOT NULL,
            REG_NAME            VARCHAR(256),
            REG_VERSION         INTEGER NOT NULL,
            REG_MEDIA_TYPE      VARCHAR(500),
            REG_CREATOR         VARCHAR(255) NOT NULL,
            REG_CREATED_TIME    TIMESTAMP NOT NULL,
            REG_LAST_UPDATOR    VARCHAR(255),
            REG_LAST_UPDATED_TIME    TIMESTAMP NOT NULL,
            REG_DESCRIPTION     VARCHAR(1000),
            REG_CONTENT_ID      INTEGER,
            REG_DELETED         SMALLINT,
            REG_TENANT_ID INTEGER DEFAULT 0,
            REG_UUID VARCHAR(100) NOT NULL,
            CONSTRAINT PK_REG_RESOURCE_HISTORY PRIMARY KEY(REG_VERSION, REG_TENANT_ID)
);

ALTER TABLE REG_RESOURCE_HISTORY ADD CONSTRAINT REG_RESOURCE_HIST_FK_BY_PATHID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
ALTER TABLE REG_RESOURCE_HISTORY ADD CONSTRAINT REG_RESOURCE_HIST_FK_BY_CONTENT_ID FOREIGN KEY (REG_CONTENT_ID, REG_TENANT_ID) REFERENCES REG_CONTENT_HISTORY (REG_CONTENT_ID, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_HISTORY_IND_BY_NAME  ON REG_RESOURCE_HISTORY(REG_NAME, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_HISTORY_IND_BY_PATH_ID_NAME  ON REG_RESOURCE(REG_PATH_ID, REG_NAME, REG_TENANT_ID);

DROP TABLE IF EXISTS REG_COMMENT;
DROP SEQUENCE IF EXISTS REG_COMMENT_PK_SEQ;
CREATE SEQUENCE REG_COMMENT_PK_SEQ;
CREATE TABLE REG_COMMENT (
            REG_ID        INTEGER DEFAULT NEXTVAL('REG_COMMENT_PK_SEQ'),
            REG_COMMENT_TEXT      VARCHAR(500) NOT NULL,
            REG_USER_ID           VARCHAR(255) NOT NULL,
            REG_COMMENTED_TIME    TIMESTAMP NOT NULL,
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_COMMENT PRIMARY KEY(REG_ID, REG_TENANT_ID)
);

DROP TABLE IF EXISTS REG_RESOURCE_COMMENT;
CREATE TABLE REG_RESOURCE_COMMENT (
            REG_COMMENT_ID          INTEGER NOT NULL,
            REG_VERSION             INTEGER,
            REG_PATH_ID             INTEGER,
            REG_RESOURCE_NAME       VARCHAR(256),
            REG_TENANT_ID INTEGER DEFAULT 0
);

ALTER TABLE REG_RESOURCE_COMMENT ADD CONSTRAINT REG_RESOURCE_COMMENT_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
ALTER TABLE REG_RESOURCE_COMMENT ADD CONSTRAINT REG_RESOURCE_COMMENT_FK_BY_COMMENT_ID FOREIGN KEY (REG_COMMENT_ID, REG_TENANT_ID) REFERENCES REG_COMMENT (REG_ID, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_COMMENT_IND_BY_PATH_ID_AND_RESOURCE_NAME  ON REG_RESOURCE_COMMENT(REG_PATH_ID, REG_RESOURCE_NAME, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_COMMENT_IND_BY_VERSION  ON REG_RESOURCE_COMMENT(REG_VERSION, REG_TENANT_ID);

DROP TABLE IF EXISTS REG_RATING;
DROP SEQUENCE IF EXISTS REG_RATING_PK_SEQ;
CREATE SEQUENCE REG_RATING_PK_SEQ;
CREATE TABLE REG_RATING (
            REG_ID     INTEGER DEFAULT NEXTVAL('REG_RATING_PK_SEQ'),
            REG_RATING        INTEGER NOT NULL,
            REG_USER_ID       VARCHAR(255) NOT NULL,
            REG_RATED_TIME    TIMESTAMP NOT NULL,
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_RATING PRIMARY KEY(REG_ID, REG_TENANT_ID)
);

DROP TABLE IF EXISTS REG_RESOURCE_RATING;
CREATE TABLE REG_RESOURCE_RATING (
            REG_RATING_ID           INTEGER NOT NULL,
            REG_VERSION             INTEGER,
            REG_PATH_ID             INTEGER,
            REG_RESOURCE_NAME       VARCHAR(256),
            REG_TENANT_ID INTEGER DEFAULT 0
);

ALTER TABLE REG_RESOURCE_RATING ADD CONSTRAINT REG_RESOURCE_RATING_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
ALTER TABLE REG_RESOURCE_RATING ADD CONSTRAINT REG_RESOURCE_RATING_FK_BY_RATING_ID FOREIGN KEY (REG_RATING_ID, REG_TENANT_ID) REFERENCES REG_RATING (REG_ID, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_RATING_IND_BY_PATH_ID_AND_RESOURCE_NAME  ON REG_RESOURCE_RATING(REG_PATH_ID, REG_RESOURCE_NAME, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_RATING_IND_BY_VERSION  ON REG_RESOURCE_RATING(REG_VERSION, REG_TENANT_ID);

DROP TABLE IF EXISTS REG_TAG;
DROP SEQUENCE IF EXISTS REG_TAG_PK_SEQ;
CREATE SEQUENCE REG_TAG_PK_SEQ;
CREATE TABLE REG_TAG (
            REG_ID         INTEGER DEFAULT NEXTVAL('REG_TAG_PK_SEQ'),
            REG_TAG_NAME       VARCHAR(500) NOT NULL,
            REG_USER_ID        VARCHAR(255) NOT NULL,
            REG_TAGGED_TIME    TIMESTAMP NOT NULL,
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_TAG PRIMARY KEY(REG_ID, REG_TENANT_ID)
);

DROP TABLE IF EXISTS REG_RESOURCE_TAG;
CREATE TABLE REG_RESOURCE_TAG (
            REG_TAG_ID              INTEGER NOT NULL,
            REG_VERSION             INTEGER,
            REG_PATH_ID             INTEGER,
            REG_RESOURCE_NAME       VARCHAR(256),
            REG_TENANT_ID INTEGER DEFAULT 0
);

ALTER TABLE REG_RESOURCE_TAG ADD CONSTRAINT REG_RESOURCE_TAG_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
ALTER TABLE REG_RESOURCE_TAG ADD CONSTRAINT REG_RESOURCE_TAG_FK_BY_TAG_ID FOREIGN KEY (REG_TAG_ID, REG_TENANT_ID) REFERENCES REG_TAG (REG_ID, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_TAG_IND_BY_PATH_ID_AND_RESOURCE_NAME  ON REG_RESOURCE_TAG(REG_PATH_ID, REG_RESOURCE_NAME, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_TAG_IND_BY_VERSION  ON REG_RESOURCE_TAG(REG_VERSION, REG_TENANT_ID);

DROP TABLE IF EXISTS REG_PROPERTY;
DROP SEQUENCE IF EXISTS REG_PROPERTY_PK_SEQ;
CREATE SEQUENCE REG_PROPERTY_PK_SEQ;
CREATE TABLE REG_PROPERTY (
            REG_ID         INTEGER DEFAULT NEXTVAL('REG_PROPERTY_PK_SEQ'),
            REG_NAME       VARCHAR(100) NOT NULL,
            REG_VALUE        VARCHAR(1000),
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_PROPERTY PRIMARY KEY(REG_ID, REG_TENANT_ID)
);

DROP TABLE IF EXISTS REG_RESOURCE_PROPERTY;
CREATE TABLE REG_RESOURCE_PROPERTY (
            REG_PROPERTY_ID         INTEGER NOT NULL,
            REG_VERSION             INTEGER,
            REG_PATH_ID             INTEGER,
            REG_RESOURCE_NAME       VARCHAR(256),
            REG_TENANT_ID INTEGER DEFAULT 0
);

ALTER TABLE REG_RESOURCE_PROPERTY ADD CONSTRAINT REG_RESOURCE_PROPERTY_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);
ALTER TABLE REG_RESOURCE_PROPERTY ADD CONSTRAINT REG_RESOURCE_PROPERTY_FK_BY_TAG_ID FOREIGN KEY (REG_PROPERTY_ID, REG_TENANT_ID) REFERENCES REG_PROPERTY (REG_ID, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_PROPERTY_IND_BY_PATH_ID_AND_RESOURCE_NAME  ON REG_RESOURCE_PROPERTY(REG_PATH_ID, REG_RESOURCE_NAME, REG_TENANT_ID);
CREATE INDEX REG_RESOURCE_PROPERTY_IND_BY_VERSION  ON REG_RESOURCE_PROPERTY(REG_VERSION, REG_TENANT_ID);


DROP TABLE IF EXISTS REG_ASSOCIATION;
DROP SEQUENCE IF EXISTS REG_ASSOCIATION_PK_SEQ;
CREATE SEQUENCE REG_ASSOCIATION_PK_SEQ;
CREATE TABLE REG_ASSOCIATION (
            REG_ASSOCIATION_ID INTEGER DEFAULT NEXTVAL('REG_ASSOCIATION_PK_SEQ'),
            REG_SOURCEPATH VARCHAR (2000) NOT NULL,
            REG_TARGETPATH VARCHAR (2000) NOT NULL,
            REG_ASSOCIATION_TYPE VARCHAR (2000) NOT NULL,
            REG_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (REG_ASSOCIATION_ID, REG_TENANT_ID)
);

DROP TABLE IF EXISTS REG_SNAPSHOT;
DROP SEQUENCE IF EXISTS REG_SNAPSHOT_PK_SEQ;
CREATE SEQUENCE REG_SNAPSHOT_PK_SEQ;
CREATE TABLE REG_SNAPSHOT (
            REG_SNAPSHOT_ID     INTEGER DEFAULT NEXTVAL('REG_SNAPSHOT_PK_SEQ'),
            REG_PATH_ID            INTEGER NOT NULL,
            REG_RESOURCE_NAME      VARCHAR(255),
            REG_RESOURCE_VIDS     BYTEA NOT NULL,
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_SNAPSHOT PRIMARY KEY(REG_SNAPSHOT_ID, REG_TENANT_ID)
);

CREATE INDEX REG_SNAPSHOT_IND_BY_PATH_ID_AND_RESOURCE_NAME  ON REG_SNAPSHOT(REG_PATH_ID, REG_RESOURCE_NAME, REG_TENANT_ID);

ALTER TABLE REG_SNAPSHOT ADD CONSTRAINT REG_SNAPSHOT_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID, REG_TENANT_ID) REFERENCES REG_PATH (REG_PATH_ID, REG_TENANT_ID);


-- ################################
-- USER MANAGER TABLES
-- ################################

DROP TABLE IF EXISTS UM_TENANT;
DROP SEQUENCE IF EXISTS UM_TENANT_PK_SEQ;
CREATE SEQUENCE UM_TENANT_PK_SEQ;
CREATE TABLE UM_TENANT (
			UM_ID INTEGER DEFAULT NEXTVAL('UM_TENANT_PK_SEQ'),
			UM_TENANT_UUID VARCHAR(36) NOT NULL,
			UM_DOMAIN_NAME VARCHAR(255) NOT NULL,
            UM_EMAIL VARCHAR(255),
            UM_ACTIVE BOOLEAN DEFAULT FALSE,
	        UM_CREATED_DATE TIMESTAMP NOT NULL,
	        UM_USER_CONFIG BYTEA,
			PRIMARY KEY (UM_ID),
			UNIQUE(UM_DOMAIN_NAME),
			UNIQUE(UM_TENANT_UUID));

CREATE INDEX INDEX_UM_TENANT_UM_DOMAIN_NAME
                    ON UM_TENANT (UM_DOMAIN_NAME); 


DROP TABLE IF EXISTS UM_DOMAIN;
DROP SEQUENCE IF EXISTS UM_DOMAIN_PK_SEQ;
CREATE SEQUENCE UM_DOMAIN_PK_SEQ;
CREATE TABLE UM_DOMAIN(
            UM_DOMAIN_ID INTEGER DEFAULT NEXTVAL('UM_DOMAIN_PK_SEQ'),
            UM_DOMAIN_NAME VARCHAR(255) NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (UM_DOMAIN_ID, UM_TENANT_ID),
            UNIQUE(UM_DOMAIN_NAME,UM_TENANT_ID)
);


DROP TABLE IF EXISTS UM_USER CASCADE;			
DROP SEQUENCE IF EXISTS UM_USER_PK_SEQ;
CREATE SEQUENCE UM_USER_PK_SEQ;
CREATE TABLE UM_USER ( 
             UM_ID INTEGER DEFAULT NEXTVAL('UM_USER_PK_SEQ'), 
             UM_USER_ID VARCHAR(255) NOT NULL,
             UM_USER_NAME VARCHAR(255) NOT NULL,
             UM_USER_PASSWORD VARCHAR(255) NOT NULL,
             UM_SALT_VALUE VARCHAR(31),
             UM_REQUIRE_CHANGE BOOLEAN DEFAULT FALSE,
             UM_CHANGED_TIME TIMESTAMP NOT NULL,
             UM_TENANT_ID INTEGER DEFAULT 0, 
             PRIMARY KEY (UM_ID, UM_TENANT_ID), 
             UNIQUE(UM_USER_ID, UM_TENANT_ID)
);
 
CREATE INDEX INDEX_UM_USERNAME_UM_TENANT_ID ON UM_USER(UM_USER_NAME, UM_TENANT_ID);

DROP TABLE IF EXISTS UM_SYSTEM_USER  CASCADE;			
DROP SEQUENCE IF EXISTS UM_SYSTEM_USER_PK_SEQ;
CREATE SEQUENCE UM_SYSTEM_USER_PK_SEQ;
CREATE TABLE UM_SYSTEM_USER ( 
             UM_ID INTEGER DEFAULT NEXTVAL('UM_SYSTEM_USER_PK_SEQ'), 
             UM_USER_NAME VARCHAR(255) NOT NULL, 
             UM_USER_PASSWORD VARCHAR(255) NOT NULL,
             UM_SALT_VALUE VARCHAR(31),
             UM_REQUIRE_CHANGE BOOLEAN DEFAULT FALSE,
             UM_CHANGED_TIME TIMESTAMP NOT NULL,
             UM_TENANT_ID INTEGER DEFAULT 0, 
             PRIMARY KEY (UM_ID, UM_TENANT_ID), 
             UNIQUE(UM_USER_NAME, UM_TENANT_ID)
); 

DROP TABLE IF EXISTS UM_ROLE CASCADE;
DROP SEQUENCE IF EXISTS UM_ROLE_PK_SEQ;
CREATE SEQUENCE UM_ROLE_PK_SEQ;
CREATE TABLE UM_ROLE ( 
             UM_ID INTEGER DEFAULT NEXTVAL('UM_ROLE_PK_SEQ'), 
             UM_ROLE_NAME VARCHAR(255) NOT NULL,
             UM_TENANT_ID INTEGER DEFAULT 0,
		UM_SHARED_ROLE BOOLEAN DEFAULT FALSE,  
             PRIMARY KEY (UM_ID, UM_TENANT_ID),
             UNIQUE(UM_ROLE_NAME, UM_TENANT_ID) 
);


DROP TABLE IF EXISTS UM_MODULE CASCADE;
DROP SEQUENCE IF EXISTS UM_MODULE_PK_SEQ;
CREATE SEQUENCE UM_MODULE_PK_SEQ;
CREATE TABLE UM_MODULE(
	UM_ID INTEGER  DEFAULT NEXTVAL('UM_MODULE_PK_SEQ'),
	UM_MODULE_NAME VARCHAR(100),
	UNIQUE(UM_MODULE_NAME),
	PRIMARY KEY(UM_ID)
);

DROP TABLE IF EXISTS UM_MODULE_ACTIONS CASCADE;
CREATE TABLE UM_MODULE_ACTIONS(
	UM_ACTION VARCHAR(255) NOT NULL,
	UM_MODULE_ID INTEGER NOT NULL,
	PRIMARY KEY(UM_ACTION, UM_MODULE_ID),
	FOREIGN KEY (UM_MODULE_ID) REFERENCES UM_MODULE(UM_ID) ON DELETE CASCADE
);


DROP TABLE IF EXISTS UM_PERMISSION CASCADE;
DROP SEQUENCE IF EXISTS UM_PERMISSION_PK_SEQ;
CREATE SEQUENCE UM_PERMISSION_PK_SEQ;
CREATE TABLE UM_PERMISSION ( 
             UM_ID INTEGER DEFAULT NEXTVAL('UM_PERMISSION_PK_SEQ'), 
             UM_RESOURCE_ID VARCHAR(255) NOT NULL, 
             UM_ACTION VARCHAR(255) NOT NULL, 
             UM_TENANT_ID INTEGER DEFAULT 0, 
	     UM_MODULE_ID INTEGER DEFAULT 0,
	         	 UNIQUE(UM_RESOURCE_ID,UM_ACTION, UM_TENANT_ID),
             PRIMARY KEY (UM_ID, UM_TENANT_ID)
); 

CREATE INDEX INDEX_UM_PERMISSION_UM_RESOURCE_ID_UM_ACTION 
                    ON UM_PERMISSION (UM_RESOURCE_ID, UM_ACTION, UM_TENANT_ID); 

					
DROP TABLE IF EXISTS UM_ROLE_PERMISSION;
DROP SEQUENCE IF EXISTS UM_ROLE_PERMISSION_PK_SEQ;
CREATE SEQUENCE UM_ROLE_PERMISSION_PK_SEQ;
CREATE TABLE UM_ROLE_PERMISSION ( 
             UM_ID INTEGER DEFAULT NEXTVAL('UM_ROLE_PERMISSION_PK_SEQ'), 
             UM_PERMISSION_ID INTEGER NOT NULL, 
             UM_ROLE_NAME VARCHAR(255) NOT NULL,
             UM_IS_ALLOWED SMALLINT NOT NULL, 
             UM_TENANT_ID INTEGER DEFAULT 0, 
	     UM_DOMAIN_ID INTEGER,
             FOREIGN KEY (UM_PERMISSION_ID, UM_TENANT_ID) REFERENCES UM_PERMISSION(UM_ID, UM_TENANT_ID) ON DELETE CASCADE,
	     FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE, 
             PRIMARY KEY (UM_ID, UM_TENANT_ID) 
); 

-- REMOVED UNIQUE (UM_PERMISSION_ID, UM_ROLE_ID) 
DROP TABLE IF EXISTS UM_USER_PERMISSION;
DROP SEQUENCE IF EXISTS UM_USER_PERMISSION_PK_SEQ;
CREATE SEQUENCE UM_USER_PERMISSION_PK_SEQ;
CREATE TABLE UM_USER_PERMISSION ( 
             UM_ID INTEGER DEFAULT NEXTVAL('UM_USER_PERMISSION_PK_SEQ'), 
             UM_PERMISSION_ID INTEGER NOT NULL, 
             UM_USER_NAME VARCHAR(255) NOT NULL,
             UM_IS_ALLOWED SMALLINT NOT NULL,          
             UM_TENANT_ID INTEGER DEFAULT 0, 
             FOREIGN KEY (UM_PERMISSION_ID, UM_TENANT_ID) REFERENCES UM_PERMISSION(UM_ID, UM_TENANT_ID) ON DELETE CASCADE,
             PRIMARY KEY (UM_ID, UM_TENANT_ID)
);

-- REMOVED UNIQUE (UM_PERMISSION_ID, UM_USER_ID) 
DROP TABLE IF EXISTS UM_USER_ROLE;
DROP SEQUENCE IF EXISTS UM_USER_ROLE_PK_SEQ;
CREATE SEQUENCE UM_USER_ROLE_PK_SEQ;
CREATE TABLE UM_USER_ROLE ( 
             UM_ID INTEGER DEFAULT NEXTVAL('UM_USER_ROLE_PK_SEQ'), 
             UM_ROLE_ID INTEGER NOT NULL, 
             UM_USER_ID INTEGER NOT NULL,
             UM_TENANT_ID INTEGER DEFAULT 0,  
             UNIQUE (UM_USER_ID, UM_ROLE_ID, UM_TENANT_ID), 
             FOREIGN KEY (UM_ROLE_ID, UM_TENANT_ID) REFERENCES UM_ROLE(UM_ID, UM_TENANT_ID),
             FOREIGN KEY (UM_USER_ID, UM_TENANT_ID) REFERENCES UM_USER(UM_ID, UM_TENANT_ID),
             PRIMARY KEY (UM_ID, UM_TENANT_ID)
); 

DROP TABLE IF EXISTS UM_SHARED_USER_ROLE;
CREATE TABLE UM_SHARED_USER_ROLE(
    UM_ROLE_ID INTEGER NOT NULL,
    UM_USER_ID INTEGER NOT NULL,
    UM_USER_TENANT_ID INTEGER NOT NULL,
    UM_ROLE_TENANT_ID INTEGER NOT NULL,
    UNIQUE(UM_USER_ID,UM_ROLE_ID,UM_USER_TENANT_ID, UM_ROLE_TENANT_ID),
    FOREIGN KEY(UM_ROLE_ID,UM_ROLE_TENANT_ID) REFERENCES UM_ROLE(UM_ID,UM_TENANT_ID) ON DELETE CASCADE ,
    FOREIGN KEY(UM_USER_ID,UM_USER_TENANT_ID) REFERENCES UM_USER(UM_ID,UM_TENANT_ID) ON DELETE CASCADE 
);

DROP TABLE IF EXISTS UM_ACCOUNT_MAPPING;
DROP SEQUENCE IF EXISTS UM_ACCOUNT_MAPPING_SEQ;
CREATE SEQUENCE UM_ACCOUNT_MAPPING_SEQ;
CREATE TABLE UM_ACCOUNT_MAPPING(
	UM_ID INTEGER DEFAULT NEXTVAL('UM_ACCOUNT_MAPPING_SEQ'),
	UM_USER_NAME VARCHAR(255) NOT NULL,
	UM_TENANT_ID INTEGER NOT NULL,
	UM_USER_STORE_DOMAIN VARCHAR(100),
	UM_ACC_LINK_ID INTEGER NOT NULL,
	UNIQUE(UM_USER_NAME, UM_TENANT_ID, UM_USER_STORE_DOMAIN, UM_ACC_LINK_ID),
	FOREIGN KEY (UM_TENANT_ID) REFERENCES UM_TENANT(UM_ID) ON DELETE CASCADE,
	PRIMARY KEY (UM_ID)
);

DROP TABLE IF EXISTS UM_USER_ATTRIBUTE;
DROP SEQUENCE IF EXISTS UM_USER_ATTRIBUTE_PK_SEQ;
CREATE SEQUENCE UM_USER_ATTRIBUTE_PK_SEQ;
CREATE TABLE UM_USER_ATTRIBUTE ( 
            UM_ID INTEGER DEFAULT NEXTVAL('UM_USER_ATTRIBUTE_PK_SEQ'), 
            UM_ATTR_NAME VARCHAR(255) NOT NULL, 
            UM_ATTR_VALUE VARCHAR(1024), 
            UM_PROFILE_ID VARCHAR(255), 
            UM_USER_ID INTEGER, 
            UM_TENANT_ID INTEGER DEFAULT 0, 
            FOREIGN KEY (UM_USER_ID, UM_TENANT_ID) REFERENCES UM_USER(UM_ID, UM_TENANT_ID), 
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
); 

CREATE INDEX UM_USER_ID_INDEX ON UM_USER_ATTRIBUTE(UM_USER_ID);
CREATE INDEX UM_ATTR_NAME_VALUE_INDEX ON UM_USER_ATTRIBUTE(UM_ATTR_NAME, UM_ATTR_VALUE);

DROP TABLE IF EXISTS UM_DIALECT CASCADE;
DROP SEQUENCE IF EXISTS UM_DIALECT_PK_SEQ;
CREATE SEQUENCE UM_DIALECT_PK_SEQ;
CREATE TABLE UM_DIALECT( 
            UM_ID INTEGER DEFAULT NEXTVAL('UM_DIALECT_PK_SEQ'), 
            UM_DIALECT_URI VARCHAR(255) NOT NULL, 
            UM_TENANT_ID INTEGER DEFAULT 0, 
            UNIQUE(UM_DIALECT_URI, UM_TENANT_ID), 
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
); 

DROP TABLE IF EXISTS UM_CLAIM;
DROP SEQUENCE IF EXISTS UM_CLAIM_PK_SEQ;
CREATE SEQUENCE UM_CLAIM_PK_SEQ;
CREATE TABLE UM_CLAIM( 
            UM_ID INTEGER DEFAULT NEXTVAL('UM_CLAIM_PK_SEQ'), 
            UM_DIALECT_ID INTEGER NOT NULL, 
            UM_CLAIM_URI VARCHAR(255) NOT NULL, 
            UM_DISPLAY_TAG VARCHAR(255), 
            UM_DESCRIPTION VARCHAR(255), 
            UM_MAPPED_ATTRIBUTE_DOMAIN VARCHAR(255),
            UM_MAPPED_ATTRIBUTE VARCHAR(255), 
            UM_REG_EX VARCHAR(255), 
            UM_SUPPORTED SMALLINT, 
            UM_REQUIRED SMALLINT, 
            UM_DISPLAY_ORDER INTEGER,
	    UM_CHECKED_ATTRIBUTE SMALLINT,
	    UM_READ_ONLY SMALLINT,
            UM_TENANT_ID INTEGER DEFAULT 0, 
            UNIQUE(UM_DIALECT_ID, UM_CLAIM_URI, UM_TENANT_ID), 
            FOREIGN KEY(UM_DIALECT_ID, UM_TENANT_ID) REFERENCES UM_DIALECT(UM_ID, UM_TENANT_ID), 
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
); 

DROP TABLE IF EXISTS UM_PROFILE_CONFIG;
DROP SEQUENCE IF EXISTS UM_PROFILE_CONFIG_PK_SEQ;
CREATE SEQUENCE UM_PROFILE_CONFIG_PK_SEQ;
CREATE TABLE UM_PROFILE_CONFIG( 
            UM_ID INTEGER DEFAULT NEXTVAL('UM_PROFILE_CONFIG_PK_SEQ'), 
            UM_DIALECT_ID INTEGER NOT NULL, 
            UM_PROFILE_NAME VARCHAR(255), 
            UM_TENANT_ID INTEGER DEFAULT 0, 
            FOREIGN KEY(UM_DIALECT_ID, UM_TENANT_ID) REFERENCES UM_DIALECT(UM_ID, UM_TENANT_ID), 
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
); 

DROP TABLE IF EXISTS UM_CLAIM_BEHAVIOR;    
DROP SEQUENCE IF EXISTS UM_CLAIM_BEHAVIOR_PK_SEQ;
CREATE SEQUENCE UM_CLAIM_BEHAVIOR_PK_SEQ;
CREATE TABLE UM_CLAIM_BEHAVIOR( 
            UM_ID INTEGER DEFAULT NEXTVAL('UM_CLAIM_BEHAVIOR_PK_SEQ'), 
            UM_PROFILE_ID INTEGER, 
            UM_CLAIM_ID INTEGER, 
            UM_BEHAVIOUR SMALLINT, 
            UM_TENANT_ID INTEGER DEFAULT 0, 
            FOREIGN KEY(UM_PROFILE_ID, UM_TENANT_ID) REFERENCES UM_PROFILE_CONFIG(UM_ID, UM_TENANT_ID), 
            FOREIGN KEY(UM_CLAIM_ID, UM_TENANT_ID) REFERENCES UM_CLAIM(UM_ID, UM_TENANT_ID), 
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
); 

DROP TABLE IF EXISTS UM_HYBRID_ROLE;
DROP SEQUENCE IF EXISTS UM_HYBRID_ROLE_PK_SEQ;
CREATE SEQUENCE UM_HYBRID_ROLE_PK_SEQ;
CREATE TABLE UM_HYBRID_ROLE(
            UM_ID INTEGER DEFAULT NEXTVAL('UM_HYBRID_ROLE_PK_SEQ'),
            UM_ROLE_NAME VARCHAR(255) NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (UM_ID, UM_TENANT_ID),
            UNIQUE (UM_ROLE_NAME, UM_TENANT_ID)
);

CREATE INDEX UM_ROLE_NAME_IND ON UM_HYBRID_ROLE(UM_ROLE_NAME);

DROP TABLE IF EXISTS UM_HYBRID_USER_ROLE;
DROP SEQUENCE IF EXISTS UM_HYBRID_USER_ROLE_PK_SEQ;
CREATE SEQUENCE UM_HYBRID_USER_ROLE_PK_SEQ;
CREATE TABLE UM_HYBRID_USER_ROLE(
            UM_ID INTEGER DEFAULT NEXTVAL('UM_HYBRID_USER_ROLE_PK_SEQ'),
            UM_USER_NAME VARCHAR(255),
            UM_ROLE_ID INTEGER NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
	    UM_DOMAIN_ID INTEGER,
            UNIQUE (UM_USER_NAME, UM_ROLE_ID, UM_TENANT_ID, UM_DOMAIN_ID),
            FOREIGN KEY (UM_ROLE_ID, UM_TENANT_ID) REFERENCES UM_HYBRID_ROLE(UM_ID, UM_TENANT_ID) ON DELETE CASCADE,
	    FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE,
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
);

DROP TABLE IF EXISTS UM_HYBRID_GROUP_ROLE;
DROP SEQUENCE IF EXISTS UM_HYBRID_GROUP_ROLE_PK_SEQ;
CREATE SEQUENCE UM_HYBRID_GROUP_ROLE_PK_SEQ;
CREATE TABLE UM_HYBRID_GROUP_ROLE(
            UM_ID INTEGER DEFAULT NEXTVAL('UM_HYBRID_GROUP_ROLE_PK_SEQ'),
            UM_GROUP_NAME VARCHAR(255),
            UM_ROLE_ID INTEGER NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            UM_DOMAIN_ID INTEGER,
            UNIQUE (UM_GROUP_NAME, UM_ROLE_ID, UM_TENANT_ID, UM_DOMAIN_ID),
            FOREIGN KEY (UM_ROLE_ID, UM_TENANT_ID) REFERENCES UM_HYBRID_ROLE(UM_ID, UM_TENANT_ID) ON DELETE CASCADE,
            FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE,
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
);

DROP TABLE IF EXISTS UM_SYSTEM_ROLE;
DROP SEQUENCE IF EXISTS UM_SYSTEM_ROLE_PK_SEQ;
CREATE SEQUENCE UM_SYSTEM_ROLE_PK_SEQ;
CREATE TABLE UM_SYSTEM_ROLE(
            UM_ID INTEGER DEFAULT NEXTVAL('UM_SYSTEM_ROLE_PK_SEQ'),
            UM_ROLE_NAME VARCHAR(255) NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (UM_ID, UM_TENANT_ID),
            UNIQUE(UM_ROLE_NAME,UM_TENANT_ID)
);

DROP TABLE IF EXISTS UM_SYSTEM_USER_ROLE;
DROP SEQUENCE IF EXISTS UM_SYSTEM_USER_ROLE_PK_SEQ;
CREATE SEQUENCE UM_SYSTEM_USER_ROLE_PK_SEQ;
CREATE TABLE UM_SYSTEM_USER_ROLE(
            UM_ID INTEGER DEFAULT NEXTVAL('UM_SYSTEM_USER_ROLE_PK_SEQ'),
            UM_USER_NAME VARCHAR(255),
            UM_ROLE_ID INTEGER NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            UNIQUE (UM_USER_NAME, UM_ROLE_ID, UM_TENANT_ID),
            FOREIGN KEY (UM_ROLE_ID, UM_TENANT_ID) REFERENCES UM_SYSTEM_ROLE(UM_ID, UM_TENANT_ID),
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
);



DROP TABLE IF EXISTS UM_HYBRID_REMEMBER_ME;
DROP SEQUENCE IF EXISTS UM_HYBRID_REMEMBER_ME_PK_SEQ;
CREATE SEQUENCE UM_HYBRID_REMEMBER_ME_PK_SEQ;
CREATE TABLE UM_HYBRID_REMEMBER_ME(
            UM_ID INTEGER DEFAULT NEXTVAL('UM_HYBRID_REMEMBER_ME_PK_SEQ'),
            UM_USER_NAME VARCHAR(255) NOT NULL,
			UM_COOKIE_VALUE VARCHAR(1024),
			UM_CREATED_TIME TIMESTAMP,
            UM_TENANT_ID INTEGER DEFAULT 0,
			PRIMARY KEY (UM_ID, UM_TENANT_ID)
);

DROP TABLE IF EXISTS UM_UUID_DOMAIN_MAPPER;
DROP SEQUENCE IF EXISTS UM_UUID_DOMAIN_MAPPER_PK_SEQ;
CREATE SEQUENCE UM_UUID_DOMAIN_MAPPER_PK_SEQ;
CREATE TABLE IF NOT EXISTS UM_UUID_DOMAIN_MAPPER (
            UM_ID INTEGER DEFAULT NEXTVAL('UM_HYBRID_REMEMBER_ME_PK_SEQ'),
            UM_USER_ID VARCHAR(255) NOT NULL,
            UM_DOMAIN_ID INTEGER NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (UM_ID),
            UNIQUE (UM_USER_ID),
            FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE
);

CREATE INDEX UUID_DM_UID_TID ON UM_UUID_DOMAIN_MAPPER(UM_USER_ID, UM_TENANT_ID);

DROP TABLE IF EXISTS UM_GROUP_UUID_DOMAIN_MAPPER;
DROP SEQUENCE IF EXISTS UM_GROUP_UUID_DOMAIN_MAPPER_PK_SEQ;
CREATE SEQUENCE UM_GROUP_UUID_DOMAIN_MAPPER_PK_SEQ;
CREATE TABLE IF NOT EXISTS UM_GROUP_UUID_DOMAIN_MAPPER (
            UM_ID INTEGER DEFAULT NEXTVAL('UM_HYBRID_REMEMBER_ME_PK_SEQ'),
            UM_GROUP_ID VARCHAR(255) NOT NULL,
            UM_DOMAIN_ID INTEGER NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (UM_ID),
            UNIQUE (UM_GROUP_ID),
            FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE
);

CREATE INDEX UUID_GRP_UID_TID ON UM_GROUP_UUID_DOMAIN_MAPPER(UM_GROUP_ID, UM_TENANT_ID);
