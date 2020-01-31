# gbc security 환경구축

# Docker

- `ubuntu 18.04` 시작 

  ```shell
  docker run -it --name gbc ubuntu:18.04 /bin/bash
  ```

- 중지된 컨테이너 재시작

  ```shell
  docker start -ai gbc
  ```

## 환경 구축


apt update \
    && apt upgrade -y \
    && apt -y install git \
    && cd ~ \
    && git clone https://github.com/ccss17/dotfiles-cli \
    && cd dotfiles-cli \
    && ./install.sh
    && ./install_reversing.sh

cd ~ \
    && git clone https://github.com/ccss17/dotfiles-cli \
    && cd dotfiles-cli \
    && ./install.sh

1. 패키지 업데이트

    ```shell
    apt update && apt upgrade -y
    ```

2. `git` 설치

    ```shell
    apt -y install git
    ```

3. `dotfiles-cli` 설치 

    ```shell
    git clone https://github.com/ccss17/dotfiles-cli ~
    ~/dotfiles-cli/install.sh
    ```