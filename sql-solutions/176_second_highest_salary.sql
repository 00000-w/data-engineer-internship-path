#-- 解法说明：先找到最高工资，再在小于最高工资的记录中取最大值，即第二高工资
#-- 为什么能处理NULL：MAX()是聚合函数，作用于空结果集时返回NULL而非空行
SELECT MAX(salary) as SecondHighestSalary
FROM Employee 
WHERE salary < (SELECT MAX(salary) FROM Employee);

