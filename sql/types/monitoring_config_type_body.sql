create or replace type body monitoring_config_type as
    --
    -- Configuration parameter type
    --
    /* Constructors */
    constructor function monitoring_config_type return self as result is
     i number;
    begin
        select monitoring_config_id.nextval into i from dual;
        id := i;
        ptyp := 0;
        return;
    end monitoring_config_type;
    constructor function monitoring_config_type( c_name nvarchar2, c_ns nvarchar2 ) return self as result is
     i number;
     p monitoring_config_type;
    begin
        begin
          select v.id into i from monitoring_config v where v.name = lower(c_name) and v.ns = lower(c_ns);
        exception
          when NO_DATA_FOUND then
            select monitoring_config_id.nextval into i from dual;
        end;
        id := i;
        ptyp := 0;
        name := c_name;
        ns   := c_ns;
        return;
    end monitoring_config_type;
    constructor function monitoring_config_type( c_name nvarchar2, c_ns nvarchar2, c_dsc nvarchar2 ) return self as result is
     i number;
    begin
        begin
          select v.id into i from monitoring_config v where v.name = lower(c_name) and v.ns = lower(c_ns);
        exception
          when NO_DATA_FOUND then
            select monitoring_config_id.nextval into i from dual;
        end;
        id := i;
        ptyp := 0;
        name := c_name;
        ns   := c_ns;
        dsc  := c_dsc;
        return;
    end monitoring_config_type;
    constructor function monitoring_config_type( i integer ) return self as result is
    begin
        id := i;
        ptyp := 0;
        return;
    end monitoring_config_type;

    /* Setters */	      
    member procedure set_value( n number ) is
    begin
        num := n;
        ptyp := 1;
    end set_value;

    member procedure set_value( s varchar2 ) is
    begin
        str := s;
        ptyp := 2;
    end set_value;

    member procedure set_value( d date ) is
    begin
        dat := d;
        ptyp := 3;
    end set_value;

    member procedure set_value( i monitoring_interval ) is
    begin
        int := i;
        ptyp := 4;
    end set_value;

    /* Getters */
    member function get_value( n number ) return number is
    begin
        if ptyp = 1 then return num;
        else return null;
        end if;
    end get_value;

    member function get_value( s varchar2 ) return varchar2 is
    begin
        if ptyp = 2 then return str;
        else return null;
        end if;
    end get_value;

    member function get_value( d date ) return date is
    begin
        if ptyp = 3 then return dat;
        else return null;
        end if;
    end get_value;

    member function get_value( i monitoring_interval ) return monitoring_interval is
    begin
        if ptyp = 4 then return int;
        else return null;
        end if;
    end get_value;

    member function get_value return varchar2 is
    begin
        if    ptyp = 1 then return num;
        elsif ptyp = 2 then return str;
        elsif ptyp = 3 then return to_char(dat);
        elsif ptyp = 4 then return 'N/A'; -- FIXME: convert to string
        else return null;
        end if;
    end get_value;

    -- Get paramter from catalog
    member function get_parameter( cfg_id integer ) return monitoring_config_type is
        p monitoring_config_type := null;
    begin
        begin
            select monitoring_config_type(id,hid,name,ns,dsc,ptyp,num,str,dat,int)
              into p from monitoring_config where id = cfg_id;
        exception
          when NO_DATA_FOUND then null;
        end;
        return p;
    end get_parameter;

    member function get_parameter( cfg_name nvarchar2, cfg_ns nvarchar2 ) return monitoring_config_type is
        p monitoring_config_type := null;
    begin
        begin
            if cfg_ns is null then
                select monitoring_config_type(id,hid,name,ns,dsc,ptyp,num,str,dat,int)
                  into p from monitoring_config where name = lower(cfg_name) and rownum = 1;
            else
                select monitoring_config_type(id,hid,name,ns,dsc,ptyp,num,str,dat,int)
                  into p from monitoring_config where name = lower(cfg_name) and ns = lower(cfg_ns);
            end if;
        exception
          when NO_DATA_FOUND then null;
        end;
        return p;
    end get_parameter;

  -- Store parameter into catalog
  member function set_parameter( cfg_p monitoring_config_type, upd boolean ) return integer is
    i integer := 0;
    p monitoring_config_type := null;
  begin
    -- Check existence
    p := get_parameter( cfg_p.name, cfg_p.ns );
    if p is null then
       i := 0;
    else
       i := p.id;
    end if;

    if i = 0 then
      -- It is new parameter
      insert into monitoring_config (id,hid,name,ns,dsc,ptyp,num,str,dat,int)
                             values (cfg_p.id,cfg_p.hid,cfg_p.name,cfg_p.ns,
                                     cfg_p.dsc,cfg_p.ptyp,cfg_p.num,
                                     cfg_p.str,cfg_p.dat,cfg_p.int);
    elsif i = cfg_p.id then
      -- Update parameter if allowed
      if upd = true then
        update monitoring_config m
           set m.hid = cfg_p.hid,
              m.name = cfg_p.name,
                m.ns = cfg_p.ns,
               m.dsc = cfg_p.dsc,
              m.ptyp = cfg_p.ptyp,
               m.num = cfg_p.num,
               m.str = cfg_p.str,
               m.dat = cfg_p.dat,
               m.int = cfg_p.int
          where m.id = cfg_p.id;
      end if;
    else
      return 0;
    end if;
    commit work;
    -- Check if object inserted/exists
    select count(1) into i from monitoring_config v where v.id = cfg_p.id;
    return i;
  end set_parameter;

  member procedure del_parameter( cfg_name nvarchar2, cfg_ns nvarchar2 ) is
  begin
    if cfg_name is null then
        delete from monitoring_config 
         where ns = lower(cfg_ns);
    else
        delete from monitoring_config 
         where ns = lower(cfg_ns)
           and name = lower(cfg_name);
    end if;
  end del_parameter;

end;
/
