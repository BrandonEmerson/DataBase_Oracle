load data
infile '%ORA_ARG_SCRIPTS%\aircraft.txt'
  replace
  into table aircraft
  fileds terminated by ','
  (aid,aname,cruisingrange)

load data
infile '%ORA_ARG_SCRIPTS%\catalog.txt'
  replace
  into table catalog
  fileds terminated by ','
  (sid,pid,cost)

load data
infile '%ORA_ARG_SCRIPTS%\certified.txt'
  replace
  into table certified
  fileds terminated by ','
  (eid,aid)

load data
infile '%ORA_ARG_SCRIPTS%\class.txt'
  replace
  into table class
  fileds terminated by ','
  (name,meets_at,room,fid)

load data
infile '%ORA_ARG_SCRIPTS%\dept.txt'
  replace
  into table dept
  fileds terminated by ','
  (did,dname,budget,managerid)

load data
infile '%ORA_ARG_SCRIPTS%\emp.txt'
  replace
  into table emp
  fileds terminated by ','
  (eid,ename,age,salary)

load data
infile '%ORA_ARG_SCRIPTS%\employees.txt'
  replace
  into table employees
  fileds terminated by ','
  (eid,ename,salary)

load data
infile '%ORA_ARG_SCRIPTS%\enrolled.txt'
  replace
  into table enrolled
  fileds terminated by ','
  (snum,cname)

load data
infile '%ORA_ARG_SCRIPTS%\faculty.txt'
  replace
  into table faculty
  fileds terminated by ','
  (fid,fname,deptid)

load data
infile '%ORA_ARG_SCRIPTS%\flights.txt'
  replace
  into table flights
  fileds terminated by ','
  (fino,origin,destination,distance,departs DATE 'YYYY/MM/DD HH24:MI',arrives DATE 'YYYY/MM/DD HH24:MI',price)

load data
infile '%ORA_ARG_SCRIPTS%\parts.txt'
  replace
  into table parts
  fileds terminated by ','
  (pid,pname,color)

load data
infile '%ORA_ARG_SCRIPTS%\saliors.txt'
  replace
  into table saliors
  fileds terminated by ','
  (sid,sname,rating,age)

load data
infile '%ORA_ARG_SCRIPTS%\student.txt'
  replace
  into table student
  fileds terminated by ','
  (snum,sname,major,standing,age)

load data
infile '%ORA_ARG_SCRIPTS%\suppliers.txt'
  replace
  into table suppliers
  fileds terminated by ','
  (sid,sname,address)

load data
infile '%ORA_ARG_SCRIPTS%\works.txt'
  replace
  into table works
  fileds terminated by ','
  (eid,did,pct_time)
