# 1、第一行必须指定 基础镜像信息
# 定制的镜像都是基于 FROM 的镜像，这里的ubuntu 就是定制需要的基础镜像。
# 后续的操作都是基于 nginx。
# FROM <image>:<tag>
FROM ubuntu  
 
# 2、维护者信息
MAINTAINER docker_user docker_user@email.com

# 3、镜像操作指令
# RUN：用于执行后面跟着的命令行命令。 有以下俩种格式：
# shell 格式：RUN <命令行命令>
# exec 格式：RUN ["可执行文件", "参数1", "参数2"]
# 例如：RUN ["./test.php", "dev", "offline"] 等价于 RUN ./test.php dev offline
RUN apt-get update && apt-get install -y htop
