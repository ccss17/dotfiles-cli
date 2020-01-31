# gbc security 환경구축

# Docker

## 관리

- `ubuntu 18.04` 시작 

  ```shell
  docker run -it --name gbc ubuntu:18.04 /bin/bash
  ```

- 실행중인 컨테이너 중지 

  ```shell
  docker stop <container>
  ```

- 중지된 컨테이너 재시작

  ```shell
  docker start -ai gbc
  ```

- 변경된 컨테이너로부터 이미지 생성 

  ```shell
  docker commit <컨테이너> <새이미지이름>
  ```

  - 중지된 컨테이너로부터 이미지 생성하고 privileged mode 로 시작하기 위해 사용할 수도 있음. 

- `ubuntu 18.04` 시작(privileged mode)

  ```shell
  docker run -it --privileged --name gbc ubuntu:18.04 /bin/bash
  ```

## 상태

- 이미지 상태 보기

  ```shell
  docker images 
  ```

- 실행 중인 컨테이너 상태 보기

  ```shell
  docker ps 
  ```

- 중지된 컨테이너를 포함한 모든 컨테이너 상태 보기

  ```shell
  docker ps -a
  ```

## 환경 구축


### 명령어 정리 

```shell
apt update \
    && apt upgrade -y \
    && apt -y install git \
    && cd ~ \
    && git clone https://github.com/ccss17/dotfiles-cli \
    && cd dotfiles-cli \
    && ./install.sh \
    && ./install_reversing.sh \
    && rm -rf ~/dotfiles-cli \
    && cd ~ \
    && wget http://security.cs.rpi.edu/courses/binexp-spring2015/lectures/2/challenges.zip \
    && unzip challenges.zip \
    && mv challenges crackme \
    && rm -rf __MAXOSX challenges.zip \
    && wget http://security.cs.rpi.edu/courses/binexp-spring2015/lectures/3/bombs.zip \
    && unzip bombs.zip \
    && chmod +x ~/bombs/bomb \
    && rm bombs.zip \
    && git clone https://github.com/ccss17/bof \ 
    && cd bof \
    && ./setup.sh \
    && rm -rf ~/bof \
    && cd ~ \
    && git clone https://github.com/ccss17/security-tutorial
```

```shell
apt update -qq \
    && apt -y -qq upgrade \
    && apt -y -qq install git \
    && cd ~ \
    && git clone -q https://github.com/ccss17/dotfiles-cli \
    && cd dotfiles-cli \
    && ./install.sh \
    && ./install_reversing.sh \
    && rm -rf ~/dotfiles-cli \
    && cd ~ \
    && wget http://security.cs.rpi.edu/courses/binexp-spring2015/lectures/2/challenges.zip \
    && unzip challenges.zip \
    && mv challenges crackme \
    && rm -rf __MAXOSX challenges.zip \
    && wget http://security.cs.rpi.edu/courses/binexp-spring2015/lectures/3/bombs.zip \
    && unzip bombs.zip \
    && chmod +x ~/bombs/bomb \
    && rm bombs.zip \
    && git clone -q https://github.com/ccss17/bof \ 
    && cd bof \
    && ./setup.sh \
    && rm -rf ~/bof \
    && cd ~ \
    && git clone -q https://github.com/ccss17/security-tutorial
```

### Dockerfile

```dockerfile
FROM       ubuntu:18.04
MAINTAINER chansol0505@naver.com
RUN apt -qq update \
    && apt -y -qq upgrade \
    && apt -y -qq install git \
    && cd ~ \
    && git clone -q https://github.com/ccss17/dotfiles-cli \
    && cd dotfiles-cli \
    && ./install.sh \
    && ./install_reversing.sh \
    && cd ~ \
    && wget http://security.cs.rpi.edu/courses/binexp-spring2015/lectures/2/challenges.zip \
    && unzip challenges.zip \
    && mv challenges crackme \
    && wget http://security.cs.rpi.edu/courses/binexp-spring2015/lectures/3/bombs.zip \
    && unzip bombs.zip \
    && chmod +x ~/bombs/bomb \
    && git clone -q https://github.com/ccss17/bof \ 
    && cd bof \
    && ./setup.sh \
    && rm -rf ~/dotfiles-cli ~/__MAXOSX ~/challenges.zip ~/bombs.zip ~/bof \
    && git clone -q https://github.com/ccss17/security-tutorial ~/security-tutorial
CMD zsh
```