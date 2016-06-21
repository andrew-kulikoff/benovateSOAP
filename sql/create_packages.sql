--------------------------------------------------------------------------------
-- WS_LOGGER PACKAGE SPEC ------------------------------------------------------
--------------------------------------------------------------------------------
create or replace package ws_logger is
	log_java		int := 1;
	log_pls			int := 2; 
	log_level_info	int := 1;
	log_level_error	int := 3;
	
	function log(
		v_sd			timestamp	:= systimestamp,
		v_fd			timestamp	:= null,
		v_db_id			number		:= 0,
		v_service_id	number,
		v_log_type		number		:= ws_logger.log_pls,
		v_log_level		number		:= ws_logger.log_level_info,
		v_step			number		:= 0,
		v_text			varchar2,
		v_text_error	varchar2	:= null
	) return number;

	procedure log(
		v_sd			timestamp	:= systimestamp,
		v_fd			timestamp	:= null,
		v_db_id			number		:= 0,
		v_service_id	number,
		v_log_type		number		:= ws_logger.log_pls,
		v_log_level		number		:= ws_logger.log_level_info,
		v_step			number		:= 0,
		v_text			varchar2,
		v_text_error	varchar2	:= null,
		v_message_id	varchar2
	);

	procedure log_error( 
		v_sd			timestamp	:= systimestamp,
		v_fd			timestamp	:= null,
		v_db_id			number		:= 0,
		v_service_id	number,
		v_log_type		number		:= ws_logger.log_pls,
		v_log_level		number		:= ws_logger.log_level_error,
		v_step			number		:= 0,
		v_text			varchar2,
		v_text_error	varchar2	:= null
	);

	procedure log_error( 
		v_sd			timestamp	:= systimestamp,
		v_fd			timestamp	:= null,
		v_db_id			number		:= 0,
		v_service_id	number,
		v_log_type		number		:= ws_logger.log_pls,
		v_log_level		number		:= ws_logger.log_level_error,
		v_step			number		:= 0,
		v_text			varchar2,
		v_text_error	varchar2	:= null,
		v_xml_in_id		number,
		v_message_id	varchar2	:= null
	);

	procedure log_set_error(
		v_log_id		number,
		v_text_error	varchar2
	);

	procedure log_set_fd(
		v_log_id		number
	);

	function log_xml(
		v_service_id	number,
		v_message		clob,
		v_is_outbound	number
	) return number;
	
end ws_logger;
/
commit
/
--------------------------------------------------------------------------------
-- WS_LOGGER PACKAGE BODY ------------------------------------------------------
--------------------------------------------------------------------------------
create or replace package body ws_logger is

	function log( 
		v_sd timestamp := systimestamp,
		v_fd timestamp := null,
		v_db_id number := 0,
		v_service_id number,
		v_log_type number := ws_logger.log_pls,
		v_log_level number := ws_logger.log_level_info,
		v_step number := 0,
		v_text varchar2,
		v_text_error varchar2 := null
	) return number is
		pragma autonomous_transaction;
		log_id_v number;
	begin
		insert into ws_log (log_id, sd, fd, db_id, service_id, log_type, log_level, step, text, text_error)
		values (sq_ws_log.nextval, v_sd, v_fd, v_db_id, v_service_id, v_log_type, v_log_level, v_step, v_text, v_text_error) 
		returning log_id into log_id_v;
		commit;
		return log_id_v;
	end log;
	
	------------------------------------------------------------------------
	
	procedure log( v_sd timestamp := systimestamp,
		v_fd timestamp := null,
		v_db_id number := 0,
		v_service_id number,
		v_log_type number := ws_logger.log_pls,
		v_log_level number := ws_logger.log_level_info,
		v_step number := 0,
		v_text varchar2,
		v_text_error varchar2 := null,
		v_message_id varchar2
	) is
	begin
		insert into ws_log (log_id, sd, fd, db_id, service_id, log_type, log_level, step, text, text_error, message_id)
		values (sq_ws_log.nextval, v_sd, v_fd, v_db_id, v_service_id, v_log_type, v_log_level, v_step, v_text, v_text_error, v_message_id);
	end log;
	
	------------------------------------------------------------------------
	
	procedure log_error( v_sd timestamp := systimestamp,
		v_fd timestamp := null,
		v_db_id number := 0,
		v_service_id number,
		v_log_type number := ws_logger.log_pls,
		v_log_level number := ws_logger.log_level_error,
		v_step number := 0,
		v_text varchar2,
		v_text_error varchar2 := null
	) is
		pragma autonomous_transaction;
	begin
		insert into ws_log (log_id, sd, fd, db_id, service_id, log_type, log_level, step, text, text_error)
		values (sq_ws_log.nextval, v_sd, v_fd, v_db_id, v_service_id, v_log_type, v_log_level, v_step, v_text, v_text_error);
		commit;
	end log_error;
	
	------------------------------------------------------------------------
	
	procedure log_error( v_sd timestamp := systimestamp,
		v_fd timestamp := null,
		v_db_id number := 0,
		v_service_id number,
		v_log_type number := ws_logger.log_pls,
		v_log_level number := ws_logger.log_level_error,
		v_step number := 0,
		v_text varchar2,
		v_text_error varchar2 := null,
		v_xml_in_id number,
		v_message_id varchar2 := null
	) is
		pragma autonomous_transaction;
	begin
		insert into ws_log (log_id, sd, fd, db_id, service_id, log_type, log_level, step, text, text_error, xml_in_id, message_id)
		values (sq_ws_log.nextval, v_sd, v_fd, v_db_id, v_service_id, v_log_type, v_log_level, v_step, v_text, v_text_error, v_xml_in_id, v_message_id);
		commit;
	end log_error;
	
	------------------------------------------------------------------------
	
	procedure log_set_error( 
		v_log_id number,
		v_text_error varchar2
	) is
		pragma autonomous_transaction;
	begin
		update ws_log set log_level = ws_logger.log_level_error, text_error = text_error||v_text_error where log_id = v_log_id;
		commit;
	end log_set_error;
	
	------------------------------------------------------------------------
	
	procedure log_set_fd(
		v_log_id number
	) is
		pragma autonomous_transaction;
	begin
		update ws_log set fd = systimestamp where log_id = v_log_id;
		commit;
	end log_set_fd;
	
	------------------------------------------------------------------------
	
	function log_xml(
		v_service_id number, 
		v_message clob, 
		v_is_outbound number
	) return number is
		v_xml_id number;
	begin
		if v_is_outbound = 1 then
			insert into ws_xml_out (xml_id, trans, service_id, message)
			values (sq_ws_xml_out.nextval, systimestamp, v_service_id, v_message) 
			returning xml_id into v_xml_id;
		else
			insert into ws_xml_in (xml_id, trans, service_id, message)
			values (sq_ws_xml_in.nextval, systimestamp, v_service_id, v_message) 
			returning xml_id into v_xml_id;
		end if;
		commit;
		return v_xml_id;
	end;

end;
/
commit
/