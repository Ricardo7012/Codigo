SELECT name, 
       type
  FROM dbo.sysobjects
 WHERE (type = 'P')
 and name like 'rr%'
 order by name 