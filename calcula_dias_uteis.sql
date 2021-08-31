/* funcção em postgresql para calculo de dias uteis
Parametros:
select calcula_dias_uteis( '2021-08-31', -20)
calcula a data '2021-08-31' menos 20 dias uteis
*/
create or replace function calcula_dias_uteis( from_date date, num_days int)
returns date

as $fbd$
declare dd date;
begin

if num_days>0 then


 dd =  (select d
    from (
        select d::date, row_number() over (order by d)
        from generate_series(from_date + 1, from_date + num_days * 2 + 5, '1d') d
        where 
            extract('dow' from d) not in (0, 6) 
        ) s
    where row_number = num_days);
    
else
 
  dd = (select d
    from (
        select d::date, row_number() over (order by d)
        from generate_series(from_date - ( num_days * -2 + (num_days*-1) ) , from_date , '1d') d
        where 
            extract('dow' from d) not in (0, 6) 
        ) s order by d desc offset (num_days*-1) limit 1
   );
     
    
end if;
  
  return dd;  
  
  
end;    
$fbd$ language 'plpgsql';

