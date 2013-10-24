--
-- Intarval value type
--
--

define L_TYPE_NAME = MONITORING_INTERVAL

-- Create type if it not exists
declare
  l$cnt integer := 0;
  l$sql varchar2(1024) := 'create type &&L_TYPE_NAME as varray(2) of integer';
begin
  select count(1) into l$cnt
    from sys.all_types
   where type_name = '&&L_TYPE_NAME'
     and owner = upper('&&ORA_SCHEMA_OWNER');

   if l$cnt = 0 then
     begin
       execute immediate l$sql;
       dbms_output.put_line( CHR(10) || 'I: Type &&L_TYPE_NAME created' );
     end;
   else
       dbms_output.put_line( CHR(10) || 'W: Type &&L_TYPE_NAME already exists' );
   end if;
end;
/

undefine L_TYPE_NAME
