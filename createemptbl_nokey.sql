--SQL pipeline
--Run the following in the command line (with original createemptbl.sql file with key):
--snowsql -c example -f createemptbl.sql -o output_format=csv -o header=true -o timing=false -o friendly=false  > emp_output.csv

use warehouse sf_tuts_wh;

use database sf_tuts;

create or replace table emp_table (
  first_name string ,
  last_name string ,
  email string ,
  streetaddress string ,
  city string ,
  start_date date
  );

--Creation of the table from csv files in S3
--NOTE: Key must be entered for the command to work. This was deleted in this upload to GitHub.
copy into emp_table
  from s3://jr-bucket credentials=(aws_key_id='<key1>' aws_secret_key='<key2>')
  file_format = (type = csv field_optionally_enclosed_by='"')
  pattern = '.*employees0[1-5].csv'
  on_error = 'skip_file';

--Create function that will give email, address and city:
create or replace function location()
	returns table (email string, streetaddress string, city string)
	as
	$$
		select email, streetaddress, city from emp_table
	$$
	;

--Select all rows from output table of function:
select * from table(location());	