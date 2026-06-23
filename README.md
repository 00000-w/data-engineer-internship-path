# data-engineer-internship-path

【本阶段学习任务拆解】
本阶段分为 4个模块，预计 10-14天 完成（每天至少3小时有效学习时间，不是混时长）。

📦 模块一：SQL基础硬核复盘（第1-3天）
不是重新看一遍教程。 是用"面试标准"重新审视以为会的知识。基础不牢，后面窗口函数一定卡死。

学习内容：
知识点	深度要求	常见误区
SELECT/WHERE/ORDER BY/LIMIT	理解SQL执行顺序（FROM→WHERE→GROUP BY→HAVING→SELECT→ORDER BY→LIMIT），不是语法顺序	90%的人说不清楚HAVING和WHERE的区别，只会背"HAVING过滤聚合"
JOIN全家桶	INNER/LEFT/RIGHT/FULL OUTER/CROSS JOIN + 自连接。必须会画JOIN的维恩图，能一句话说清楚LEFT JOIN和INNER JOIN在数据行数上的区别	LEFT JOIN后WHERE过滤右表字段=INNER JOIN效果，这个坑面试必考
NULL值处理	IS NULL vs = NULL、COALESCE()、IFNULL()、聚合函数忽略NULL	COUNT(*) vs COUNT(列名) 的区别，面试极高频率
数据类型与隐式转换	INT/VARCHAR/DATE/DATETIME类型，隐式转换导致的索引失效	字符串不加引号导致全表扫描
实操任务（必须全部完成）：
1. 在本地MySQL中创建一张"学生成绩表"（至少包含：学号、姓名、科目、成绩、考试日期）
   插入至少30条数据（覆盖：有人缺考/NULL、有人补考、同科目多次考试）
2. 手写以下查询（不许查资料，先自己写，卡住30分钟再查）：
   - 查询每个学生的平均成绩，只显示平均分>70的学生
   - 查询"数学"科目最高分的3个学生（考虑并列）
   - 找出所有科目都及格的学生（不存在不及格记录的学生）
   - 找出缺考过任意科目的学生名单
验收标准：
4条查询全部跑通，结果正确
能口头解释每一条SQL的执行逻辑（不是念SQL，是解释"数据库拿到这条SQL后怎么一步步算出结果"）
📦 模块二：子查询与CTE（第4-5天）
这是区分"学过SQL"和"会写SQL"的分水岭。面试官让你写一个复杂的多步骤查询，你不会CTE，代码一定又臭又长。

学习内容：
知识点	深度要求
标量子查询	返回单个值的子查询，用于SELECT列表或WHERE条件
派生表子查询	FROM子句中的子查询，必须给别名
关联子查询	子查询引用外部查询列，理解执行次数（外部每行执行一次子查询）
EXISTS vs IN	什么场景用EXISTS（外表大内表小？还是反过来？），与NOT EXISTS的NULL安全性
CTE（WITH子句）	把一个复杂查询拆成多个命名步骤，可读性碾压子查询嵌套
实操任务：
在下表完成（可以在之前的学生成绩表基础上扩展）：
1. 用子查询找出"成绩高于所在科目平均分"的所有记录
2. 用CTE重写第1题
3. 用NOT EXISTS找出"没有任何科目不及格的学生"
4. 用CTE实现：先计算每个科目前3名，再从前3名中选出所有学生的总分排名
避坑要点：
关联子查询的性能陷阱：如果外表100万行，内表每次扫描100万行，那就是100万×100万。什么时候用JOIN替代关联子查询？
NOT IN的NULL陷阱：WHERE id NOT IN (SELECT id FROM t2)——如果t2中有NULL值，整个查询返回空！这是经典面试题。
📦 模块三：窗口函数——面试大杀器（第6-8天）
这一关过了，你SQL能力直接提升一个档次。窗口函数是数据开发岗面试必考内容。90%的基础SQL题都可以用窗口函数写出更优雅的解法。

学习内容：
知识点	函数	应用场景
排名函数	ROW_NUMBER() / RANK() / DENSE_RANK()	各组排名、去重保留最新一条
偏移函数	LAG() / LEAD()	同比环比、连续登录天数
聚合窗口	SUM/AVG/COUNT OVER	累计求和、移动平均
分桶函数	NTILE()	数据分桶、百分位分析
窗口定义	PARTITION BY / ORDER BY / ROWS BETWEEN	精确控制窗口范围
学习方式：
不要看视频（太慢）。直接看 PostgreSQL官方窗口函数文档 的tutorial部分，然后去 LeetCode 刷题
每学一个函数，立刻去LeetCode找对应题目验证
实操任务：
必刷LeetCode SQL题（按顺序，不许跳）：
- 176. 第二高的薪水（简单，但NULL处理细节要注意）
- 177. 第N高的薪水（函数+窗口函数两种写法）
- 178. 分数排名（RANK vs DENSE_RANK区别）
- 180. 连续出现的数字（LAG解法）
- 184. 部门工资最高的员工（窗口函数 vs 子查询两种写法）
- 185. 部门工资前三高的所有员工（DENSE_RANK经典应用）
- 601. 体育馆的人流量（ROWS BETWEEN窗口范围）

每道题要求：
- 先自己想15分钟，写不出来可以看题目标签提示
- 写出至少一种解法并AC
- 看评论区TOP3解法，理解不同解法的性能差异
- 在你的GitHub仓库里建一个 /sql-solutions 文件夹，每道题保存你的解法+注释
避坑要点：
ROW_NUMBER vs RANK vs DENSE_RANK：并列值怎么处理？这是面试高频题
窗口函数 vs GROUP BY：窗口函数不改变行数，GROUP BY会折叠行。什么时候该用哪个？
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW：不加这个，ORDER BY下的聚合窗口默认就是这个范围
📦 模块四：索引与查询性能基础（第9-10天）
面试官问"这个查询为什么慢"，你不能只说"没加索引"。你要能看EXPLAIN。

学习内容：
知识点	深度要求
B+Tree索引原理	为什么范围查询快？为什么LIKE 'abc%'走索引但'%abc'不走？
聚簇索引 vs 二级索引	InnoDB下主键索引和数据存储在一起，二级索引存储主键值
回表	什么是回表？覆盖索引如何避免回表？
EXPLAIN解读	type字段（ALL/index/range/ref/eq_ref/const）、rows、Extra（Using filesort/Using temporary是坏消息）
联合索引最左前缀	(a,b,c)索引，WHERE b=1走不走索引？WHERE a=1 AND c=3呢？
实操任务：
1. 在你的学生成绩表上插入10万条测试数据（用存储过程或Python脚本生成）
2. 对以下查询执行EXPLAIN，截图保存：
   - 无索引时的全表扫描
   - 加单列索引后的变化
   - 加联合索引(科目, 成绩)后，WHERE科目='数学' AND 成绩>80的执行计划
3. 对比以下两条SQL的EXPLAIN输出，解释为什么：
   SELECT * FROM scores WHERE score > 80;
