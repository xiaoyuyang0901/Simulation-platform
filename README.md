基于 Carsim 2016 和 Simulink的无人车运动控制联合仿真（二）

该节主要说明OPTI非线性求解工具箱的安装与使用

1、简介
OPTI是一个开源的MATLAB优化工具箱，相比MATLAB自带非线性优化求解函数fmincon，该优化器更加人性化,同时也有丰富的求解方法可供选择，后续的MPC求解将使用该工具箱完成求解。

2、下载链接链接
https://www.inverseproblem.co.nz/OPTI/index.php/DL/DownloadOPTI
GitHub源码下载链接
https://github.com/jonathancurrie/OPTI

3、可供选择的求解器
线性规划
CLP，CSDP，DSDP，GLPK，LP_SOLVE，OOQP，SCIP

混合整数线性规划
CBC，GLPK，LP_SOLVE，SCIP

二次规划
CLP，OOQP，SCIP

混合整数二次规划
SCIP

二次约束二次规划
SCIP

混合整数二次约束二次规划
SCIP

半定规划
CSDP，DSDP

非线性方程组
HYBRJ，LM_DER，MKLTRNLS，NL2SOL

非线性最小二乘
LEVMAR，LM_DER，MKLTRNLS，NL2SOL

非线性规划
FILTERSD，IPOPT，L-BFGS-B，M1QN3，NLOPT，SCIP

全局非线性规划
NLOPT，NOMAD，PSWARM，SCIP

混合整数非线性规划
BONMIN，NOMAD，SCIP

4、安装过程
a.使用2中的链接完成opti的源码下载，弄完成解压，放置在合适的文件夹
b.打开MATLAB，进入到文件夹所在路径
c.点击opti_Install.m文件，并运行
d.按照命令窗口的提示，选择‘Y’完成安装

5、示例
https://www.inverseproblem.co.nz/OPTI/index.php/Examples/Examples
带约束的非线性方程组求解
