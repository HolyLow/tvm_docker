## tvm docker

[Docker](https://docs.docker-cn.com/)是一种轻量级的虚拟化技术，能够对运行一个程序所需要的操作系统、运行库依赖等运行环境进行封装，使所有的依赖被包括在一个镜像文件中，并以该镜像文件来运行一个容器（类似于开启一个虚拟机）。
使用Docker的最直接的两个好处有：
1. 使得运行环境之间可以进行独立配置，不同的运行环境之间可以互不影响；
2. 在相应的运行环境文件配置完毕之后，其他用户只需要获取这个文件即可获得相应的运行环境，而不需要再进行配置。

为了减少编译课程中对tvm运行环境进行配置的负担，本项目根据课程需求配置了课程使用的tvm docker，使用教程如下。

### 使用步骤
以下使用步骤针对OS ubuntu 16.04(or 18.04), CPU x86_64/amd64。
对于其他OS和其他CPU架构，请参照[官网教程](https://docs.docker-cn.com/engine/installation/linux/docker-ce/ubuntu/)进行安装。
#### I. 安装docker
1. 安装docker相关的依赖：
```
$ sudo apt-get update
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```
2. 添加docker的官方GPG密钥：
```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
3. 对密钥进行验证：
```
$ sudo apt-key fingerprint 0EBFCD88

    ```
    上述语句的输出应为：
    pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
    uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
    sub   rsa4096 2017-02-22 [S]
    ```
```
4. 添加docker仓库：
```
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
5. 安装docker CE：
```
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```

#### II. 添加docker使用权限
1. 创建docker用户组（如果在执行后显示用户组已存在(user group already exists)，则直接进入下一步即可）：
```
$ sudo groupadd docker
```
2. 将当前用户加入docker组：
```
$ sudo usermod -aG docker $USER
```
3. 将docker服务配置为开机启动：
```
$ sudo systemctl enable docker
```
4. 注销、重新登录（或者直接进行重启），使得以上更改生效.

#### III. 使用docker运行tvm
1. clone本项目：
```
$ git clone https://github.com/HolyLow/tvm_docker.git

```
2. 进入项目目录，在项目目录下运行start.sh：
```
$ cd tvm_docker
$ ./start.sh
```
如果运行结果的最后一行为：
```
root@tvm-docker:/tvm_workspace# 
```
说明已经成功启动tvm docker，进入了容器的bash终端.

start.sh脚本进行的操作有：
- 在本目录下面建立一个子目录tvm_workspace；
- 自动从docker仓库中下载已经配置好的tvm环境文件，并且开始运行一个拥有tvm环境的容器（类似于开始运行一个独立的虚拟机，该虚拟机已经配置好了tvm所需的各种依赖库）；
- 将tvm_workspace这个子目录与容器共享（类似于Host机器与虚拟机共享目录，对该目录的更改能够同时被Host机器和虚拟机所看到）；
- 在tvm容器中运行一个bash终端。

只需要运行该脚本，就可以自动地启动一个拥有tvm环境的容器，进而在该容器中进行tvm相关的编程工作，而无需手动配置tvm。使用的注意事项有：
- 由于tvm的依赖库较多，所下载的文件约4G左右，请保证系统中拥有足够的空间；
- 在启动了一个容器、进入容器终端之后，如果要退出该容器，可以使用快捷键control-d退出（但首先要保证该终端目前没有已输入的字符）；
- 由于start.sh中的设置，在进入容器之后，对容器的任何更改，都会在退出容器后失效。也就是说，在进入一个容器之后安装的包、环境等等，在退出容器、重新进入之后，之前所做的安装和更改全部消失；
- 在容器中，只有在/workspace目录下面的更改在退出容器之后能够被保留，该目录实际上为host机器上的子目录tvm_workspace。因此，在容器中仅对/workspace目录下进行tvm编程，在host机器中在tvm_workspace/目录下进行tvm编程。