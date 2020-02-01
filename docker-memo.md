# gbc security 환경구축

# Docker

## 관리

- `ubuntu 18.04` 시작 

  ```shell
  docker run -it --name gbc ubuntu:18.04 /bin/bash
  ```

- 실행중인 컨테이너 중지 

  ```shell
  # 그냥 컨테이너 내부 쉘에서 exit 입력 
  exit
  ```
  
  또는 로컬 쉘에서 다음 명령어 입력 

  ```shell
  docker stop <container>
  ```

- 중지된 컨테이너 재시작

  ```shell
  docker start -ai <container>
  ```

- 변경된 컨테이너로부터 이미지 생성 

  ```shell
  docker commit <컨테이너> <새이미지이름>
  ```

  - 중지된 컨테이너로부터 이미지 생성하고 privileged mode 로 시작하기 위해 사용할 수도 있음. 

- `ubuntu 18.04` 시작(privileged mode)

  ```shell
  docker run -it --privileged --name gbc -w /root ubuntu:18.04 /usr/bin/zsh
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

- 컨테이너 삭제 

  ```shell
  docker rm container
  ```

  - 중지된 컨테이너 모두 삭제 

    ```shell
    docker rm -v $(docker ps -a -q -f status=exited)
    ```

- 이미지 생성 

  ```shell
  docker build -t username/image .
  ```

  ```shell
  docker build -t app .
  ```

- 이미지 이름 변경 : 

  - `app` 에서 `username/image:1` 으로 (`버전 == 1`)

    ```shell
    docker tag app username/image:1
    ```

- 이미지 푸쉬 

  ```shell
  docker login
  docker push username/image
  ```
  ccss17/security-tutorial   3                   7dd9eb6dc09e        About a minute ago   1.14GB
ccss17/security-tutorial   latest              1bcdddcb9479        24 minutes ago       1.13GB

