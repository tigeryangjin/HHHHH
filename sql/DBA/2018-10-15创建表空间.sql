create tablespace dim_data  
logging  
datafile '/data/u01/oradata/bihappigo/dim_data00.dbf' 
size 50m  
autoextend on  
next 50m maxsize 20480m  
extent management local;  

create tablespace dim_index  
logging  
datafile '/data/u01/oradata/bihappigo/dim_index00.dbf' 
size 50m  
autoextend on  
next 50m maxsize 20480m  
extent management local; 

create tablespace fpv_index 
logging  
datafile '/data/u01/oradata/bihappigo/fpv_index.dbf' 
size 50m  
autoextend on  
next 50m maxsize 20480m  
extent management local; 

create tablespace fpv_data_2015 
logging  
datafile '/data/u01/oradata/bihappigo/fpv_data_2015_00.dbf' 
size 50m  
autoextend on  
next 50m maxsize 20480m  
extent management local; 

create tablespace fpv_data_2016 
logging  
datafile '/data/u01/oradata/bihappigo/fpv_data_2016_00.dbf' 
size 50m  
autoextend on  
next 50m maxsize 20480m  
extent management local; 

create tablespace fpv_data_2017 
logging  
datafile '/data/u01/oradata/bihappigo/fpv_data_2017_00.dbf' 
size 50m  
autoextend on  
next 50m maxsize 20480m  
extent management local; 

create tablespace fpv_data_2018 
logging  
datafile '/data/u01/oradata/bihappigo/fpv_data_2018_00.dbf' 
size 50m  
autoextend on  
next 50m maxsize 20480m  
extent management local; 

create tablespace fpv_data_2019 
logging  
datafile '/data/u01/oradata/bihappigo/fpv_data_2019_00.dbf' 
size 50m  
autoextend on  
next 50m maxsize 20480m  
extent management local; 

create tablespace fact_par_data 
logging  
datafile '/data/u01/oradata/bihappigo/fact_par_data_00.dbf' 
size 50m  
autoextend on  
next 50m maxsize 20480m  
extent management local; 

create tablespace fact_par_index 
logging  
datafile '/data/u01/oradata/bihappigo/fact_par_index_00.dbf' 
size 50m  
autoextend on  
next 50m maxsize 20480m  
extent management local; 

create tablespace acquisition_data 
logging  
datafile '/data/u01/oradata/bihappigo/acquisition_data_00.dbf' 
size 100m  
autoextend on  
next 5m maxsize unlimited  
extent management local; 

create tablespace acquisition_index 
logging  
datafile '/data/u01/oradata/bihappigo/acquisition_index_00.dbf' 
size 100m  
autoextend on  
next 5m maxsize unlimited  
extent management local; 

