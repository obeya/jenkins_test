# 拉取编译环境
FROM maven:3.6.1 as builder
#拷贝源码到固定的目录
COPY . /project
# 切换到源码目录
WORKDIR /project
# 使用maven进行编译
RUN mvn clean package -Dmaven.test.skip=true
# 拉取运行环境，这个镜像打包出的镜像比较小，如需要可换成oracle的jre
FROM fabric8/java-alpine-openjdk8-jre
# 从编译好的镜像中将jar拷贝到运行时容器
COPY --from=builder /project/target/your-jar-name.jar /
# 容器启动时执行的命令，这里可加jvm参数
ENTRYPOINT ["java","-jar","/ruoyi-activiti.jar"]
# 开放端口
EXPOSE 9090