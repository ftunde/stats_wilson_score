create or replace function stats_wilson_score(

/*****************************************************************************************************************

Author      : Matthew Grogan
Website     : https://github.com/mattgrogan
Name        : stats_wilson_score.sql 
Description : Oracle PL/SQL function to return the Wilson Score Interval for the given proportion. 
Citation    : Wilson E.B. J Am Stat Assoc 1927, 22, 209-212

Example:
  select 
    round(29 / 250, 4) point_estimate, 
    stats_wilson_score(29, 250, 0.10, 'LCL') lcl, 
    stats_wilson_score(29, 250, 0.10, 'UCL') ucl
  from dual;

/*****************************************************************************************************************/
  
  x integer,  -- Number of successes
  m integer,  -- Number of trials
  alpha number default 0.95,  -- Probability of a Type I error
  return_value varchar2 default 'LCL' -- LCL = Lower control limit, UCL = upper control limit
)

return number is
  
  z float(10);
  phat float(10)  := 0.0;
  lcl float(10)   := 0.0;
  ucl float(10)   := 0.0;
  
begin

  if m = 0 then
    return(0);
  end if;
  
  case alpha
    when 0.10 then z := 1.644854;
    when 0.05 then z := 1.959964;
    when 0.01 then z := 2.575829;
    else return(null); -- No Z value for this alpha
  end case;
  
  phat := x/m;
  
  lcl := (phat + z*z/(2*m) - z * sqrt( (phat * (1-phat) ) / m + z * z / (4 * (m * m)) ) ) / (1 + z * z / m);
  ucl := (phat + z*z/(2*m) + z * sqrt((phat*(1-phat)+z*z/(4*m))/m))/(1+z*z/m);
  
  case return_value
    when 'LCL' then return(lcl);
    when 'UCL' then return(ucl);
    else return(null);
  end case;
  
end;
/
grant execute on stats_wilson_score to public;

-- EXAMPLE:



  
  
  
  
  
  