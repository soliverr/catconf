--
-- Parameter enumeration
--

define L_SEQ_NAME = MONITORING_CONFIG_ID

-- Create sequence if it not exists
declare
  l$cnt integer := 0;
  l$sql varchar2(1024) := '
create sequence &&L_SEQ_NAME
  start with 1
  increment by 1
  minvalue 1
  nomaxvalue
  nocycle
  cache 10
';
begin
  select count(1) into l$cnt
    from sys.all_sequences
   where sequence_name = '&&L_SEQ_NAME'
     and sequence_owner = upper('&&ORA_SCHEMA_OWNER');

   if l$cnt = 0 then
     begin
       execute immediate l$sql;
       dbms_output.put_line( CHR(10) || 'I: Sequence &&L_SEQ_NAME created' );
     end;
   else
       dbms_output.put_line( CHR(10) || 'W: Sequence &&L_SEQ_NAME already exists' );
   end if;
end;
/

undefine L_SEQ_NAME
