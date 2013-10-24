--
-- Parameter tables
--
--

define L_TABLE_NAME = MONITORING_CONFIG

-- Create table if it not exists
declare
  l$cnt integer := 0;

  l$sql varchar2(1024) := '
create table &&L_TABLE_NAME  (
    -- Tree hierarchy
    id   integer,               -- Parameter unique identifier (for fast access)
    hid  integer,               -- Group identitfier (parent identifier)
    --
    name nvarchar2(128),        -- Parameter unique name
    ns   nvarchar2(128),        -- NameSpace (or parameter type)
    dsc  nvarchar2(2000),       -- Parameter description
    --
    ptyp integer,               -- Parameter value type:
    num  number,                -- 1: Numeric value
    str  nvarchar2(2000),       -- 2: String value
    dat  date,                  -- 3: Date value
    int  monitoring_interval    -- 4: Interval value
)';
begin
  select count(1) into l$cnt
    from sys.all_tables
   where table_name = '&&L_TABLE_NAME'
     and owner = upper('&&ORA_SCHEMA_OWNER');

   if l$cnt = 0 then
     begin
       execute immediate l$sql || ' tablespace &&ORA_TBSP_TBLS';
       dbms_output.put_line( CHR(10) || 'I: Table &&L_TABLE_NAME created' );
     end;

     -- Create indexes
     execute immediate '
     create unique index pk_monitoring_config on &&L_TABLE_NAME(
        id
     ) tablespace &&ORA_TBSP_INDX';
     execute immediate '
     create unique index monitoring_config_name on &&L_TABLE_NAME(
        name, ns
     ) tablespace &&ORA_TBSP_INDX';
     execute immediate '
     create index monitoring_config_hid on &&L_TABLE_NAME(
        hid
     ) tablespace &&ORA_TBSP_INDX';

     -- Create constraints
     execute immediate '
     alter table &&L_TABLE_NAME modify name constraint monitoring_config_name not null';
     execute immediate '
     alter table &&L_TABLE_NAME add (
        constraint pk_monitoring_config primary key( id ) using index,
        constraint fk_monitoring_config foreign key( hid ) references monitoring_config( id )
     )';

   else
       dbms_output.put_line( CHR(10) || 'W: Table &&L_TABLE_NAME already exists' );
   end if;
end;
/

comment on table  &&L_TABLE_NAME is 'Configuration parameter table for ORADBA packages';
comment on column "&&L_TABLE_NAME".id is 'Parameter unique identifier (for fast access)';
comment on column "&&L_TABLE_NAME".hid is 'Group identitfier (parent identifier)';
comment on column "&&L_TABLE_NAME".name is 'Parameter unique name';
comment on column "&&L_TABLE_NAME".ns is 'NameSpace (or parameter type)';
comment on column "&&L_TABLE_NAME".dsc is 'Parameter description';
comment on column "&&L_TABLE_NAME".ptyp is 'Parameter value type';
comment on column "&&L_TABLE_NAME".num is '1: Numeric value';
comment on column "&&L_TABLE_NAME".str is '2: String value';
comment on column "&&L_TABLE_NAME".dat is '3: Date value';
comment on column "&&L_TABLE_NAME".int is '4: Interval value';
