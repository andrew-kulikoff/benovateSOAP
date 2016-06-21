--------------------------------------------------------------------------------
-- WS_LOG TABLE ----------------------------------------------------------------
--------------------------------------------------------------------------------
create table ws_log( 
	log_id		number(12) not null,
	sd			timestamp(2) not null,
	fd			timestamp(2),
	db_id		number(3),
	service_id	number(3) not null,
	log_type	number(1) not null,
	log_level	number(1),
	step		number(4),
	text		varchar2(4000),
	text_error	varchar2(4000),
	message_id	varchar2(13),
	xml_in_id	number
)
/
create index ws_log_idx_sd on ws_log (sd, service_id, log_type)
/
alter table ws_log add constraint pk_ws_inf_log primary key (log_id) using index
/
alter table ws_log add constraint ws_log$service_id$fk foreign key (service_id) references ws_services (service_id)
/
create sequence sq_ws_log start with 1 increment by 1 nocache nocycle
/
commit
/
--------------------------------------------------------------------------------
-- WS_SERVICES TABLE -----------------------------------------------------------
--------------------------------------------------------------------------------
create table ws_services( 
	service_id	number(3) not null, 
	name 		varchar2(500) 
)
/
alter table ws_services add constraint pk_ws_services primary key (service_id) using index
/
commit
/
--------------------------------------------------------------------------------
-- WS_XML_IN TABLE -------------------------------------------------------------
--------------------------------------------------------------------------------
create table ws_xml_in( 
	xml_id		number not null,
	trans		timestamp(2) default systimestamp not null,
	service_id	number(3) not null,
	message		clob
)
/
create index ws_xml_in$trans$idx on ws_xml_in (trans)
/
alter table ws_xml_in add constraint ws_xml_in$pk primary key (xml_id) using index
/
alter table ws_xml_in add constraint ws_xml_in$service$fk foreign key (service_id) references ws_services (service_id)
/
create sequence sq_ws_xml_in start with 1 increment by 1 nocache nocycle
/
commit
/
--------------------------------------------------------------------------------
-- WS_XML_OUT TABLE ------------------------------------------------------------
--------------------------------------------------------------------------------
create table ws_xml_out( 
	xml_id		number not null,
	trans		timestamp(2) default systimestamp not null,
	service_id	number(3) not null,
	message		clob
) 
/
create index ws_xml_out$trans$idx on ws_xml_out (trans)
/
alter table ws_xml_out add constraint ws_xml_out$pk primary key (xml_id) using index
/
alter table ws_xml_out add constraint ws_xml_out$service$fk foreign key (service_id) references ws_services (service_id)
/
create sequence sq_ws_xml_out start with 1 increment by 1 nocache nocycle
/
commit
/
--------------------------------------------------------------------------------
-- WS_CONFIG TABLE -------------------------------------------------------------
--------------------------------------------------------------------------------
create table ws_config( 
	name_param	varchar2(200) not null,
	service_id 	number(3) not null,
	val_string	varchar2(1000),
	val_num		number,
	val_date	date,
	description	varchar2(4000) not null
)
/
alter table ws_config add constraint ws_config_pk primary key (name_param, service_id) using index
/
alter table ws_config add constraint ws_services_ws_config_fk foreign key (service_id) references ws_services (service_id)
/
commit
/