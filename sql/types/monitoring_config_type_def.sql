create or replace type monitoring_config_type as object (
    --
    -- Configuration parameter type
    --
    --
    -- Tree hierarchy
    id   integer,			    -- Parameter unique identifier (for fast access)
    hid  integer,		        -- Group identitfier (parent identifier)
    --
    name nvarchar2(128),		-- Parameter unique name
    ns   nvarchar2(128),		-- NameSpace (or parameter type
    dsc  nvarchar2(2000),		-- Parameter description
    --
    ptyp integer,               -- Parameter value type:
    num  number,		        -- 1: Numeric value
    str  nvarchar2(2000),		-- 2: String value
    dat  date,				    -- 3: Date value
    int  monitoring_interval,   -- 4: Interval value
    --
    -- Default constructor
    constructor function monitoring_config_type return self as result,
    -- Constructor for parameter initialization
    constructor function monitoring_config_type( c_name nvarchar2, c_ns nvarchar2 ) return self as result,
    constructor function monitoring_config_type( c_name nvarchar2, c_ns nvarchar2, c_dsc nvarchar2 ) return self as result,
    -- Constructor without id initialization
    constructor function monitoring_config_type( i integer ) return self as result,
    --
    -- Setters
    --
    member procedure set_value( n number ),
    member procedure set_value( s varchar2 ),
    member procedure set_value( d date ),
    member procedure set_value( i monitoring_interval ),
    --
    -- Getters
    --
    member function get_value( n number ) return number,
    member function get_value( s varchar2 ) return varchar2,
    member function get_value( d date ) return date,
    member function get_value( i monitoring_interval ) return monitoring_interval,
    -- General function to get value
    member function get_value return varchar2,
    --
    -- Parameters collection
    --
    -- Get parameter from catalog
    member function get_parameter( cfg_id integer ) return monitoring_config_type,
    member function get_parameter( cfg_name nvarchar2, cfg_ns nvarchar2 default null ) return monitoring_config_type,
    --
    -- Store/update parameter into catalog
    member function set_parameter( cfg_p monitoring_config_type, upd boolean default false ) return integer,
    --
    -- Delete parameter from catalog
    member procedure del_parameter( cfg_name nvarchar2 default null, cfg_ns nvarchar2 )
    --
) instantiable not final;
/
