SELECT p.FirstName, p.LastName, a.City, a.State
FROM `Person` p
LEFT JOIN `Address` a
ON p.PersonId = a.PersonId
# 题目要求报告 Person 表中每个人的姓、名、城市和州，Person表中用户无论是否拥有Address表对应地址，都要输出
