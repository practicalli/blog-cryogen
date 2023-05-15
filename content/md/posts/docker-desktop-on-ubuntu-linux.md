{:title "Docker Desktop on Ubuntu Linux"
:layout :post
:date "2023-05-15"
:topic "docker"
:tags  ["docker"]}

Docker can support local development and provide an effective workflow for system integration before changes are pushed to a remote continuous integration service. Docker can be used to spin up local databases and persist data in a volume, helping keep a separation between applications and supporting test of schema changes, migrations and data loading.

Docker desktop simplifies the install and provides a desktop client to manage docker images, containers, volumes and the new dev environments.  [Extensions Marketplace for Docker Desktop](https://hub.docker.com/search?q=&type=extension) provides tooling to unify logging, manage local resources and many more

The Docker install instructions are more of a reference of information than a simple tutorial. Essential Docker Community Edition is installed via the Docker package archive and Docker Desktop is installed from a [manually downloaded DEB file](https://docs.docker.com/desktop/install/ubuntu/).

> [Practicalli Engineering Playbook](https://practical.li/engineering-playbook/continuous-integration/docker/clojure-multi-stage-dockerfile/) covers Docker and Compose in more detail

<!-- more -->

## Install Docker Community Edition

Docker community edition provides the back-end services to run docker images in containers.  Install via the package archive manage by the Docker team.  Add the Docker team public key and archive, then install the Docker community edition (CE) related packages.

Ubuntu Prerequisites to use the Docker team keys (may already be installed).

```shell
sudo apt-get install ca-certificates curl gnupg lsb-release
```

Add the Docker team public key to Ubuntu package manager, ensuring only official Docker packages are used

```shell
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Add the Docker PPA to the Ubuntu package manager, creating a `/etc/apt/sources.list.d/docker.list` file.

```shell
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install Docker community edition packages

```shell
sudo apt update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-desktop
```

## Install Docker Desktop

[Download the DEB package](https://docs.docker.com/desktop/install/ubuntu/) for Docker Desktop UI and install using Ubuntu package manager

```shell
sudo apt install ./Downloads/docker-desktop-4.19.0-amd64.deb
```


### Post Install

Add the current operating system user account to the `docker` operating system group, creating the `docker` group if it doesn't already exist

```
sudo groupadd docker
sudo usermod -aG docker $USER
```

A user must completely logout of the current login session before the `docker` group is applied.

`groups` lists all the operating system groups the current user is assigned to.

## Start Docker & Docker Desktop

Starting Docker Desktop will automatically start the underlying Docker community edition that provides the run-time for docker comtainers.

Use the Ubuntu application launcher to start Docker Desktop, or use the `systemctl` command from a terminal.

```shell
systemctl --user start docker-desktop
```

> Docker desktop may automatically restart itself on first run

## Check Docker works

Use the [Docker tutorial](https://www.docker.com/101-tutorial/) image to check that Docker can run a container from an image (and also learn about Docker if new to the tools).

```shell
docker run -dp 80:80 docker/getting-started
```

The tutorial image will be downloaded and the image run in a container

```shell
❯ docker run -dp 80:80 docker/getting-started

Unable to find image 'docker/getting-started:latest' locally
latest: Pulling from docker/getting-started
c158987b0551: Already exists
1e35f6679fab: Pull complete
cb9626c74200: Pull complete
b6334b6ace34: Pull complete
f1d1c9928c82: Pull complete
9b6f639ec6ea: Pull complete
ee68d3549ec8: Pull complete
33e0cbbb4673: Pull complete
4f7e34c2de10: Pull complete
Digest: sha256:d79336f4812b6547a53e735480dde67f8f8f7071b414fbd9297609ffb989abc1
Status: Downloaded newer image for docker/getting-started:latest
215c033924260874013394d1f27fa5ec587f183ee9851d3a48884a1422fcc732
```

Open the tutorial website at [http://localhost/](http://localhost/) and follow the tutorial steps to learn more about Docker.


## Check installed versions

Print the version of Docker CE installed.  If Docker Desktop is running, then version its information is also printed.

```shell
docker version
```

Example output (once Docker Desktop is running)

```shell
❯ docker version
Client: Docker Engine - Community
 Cloud integration: v1.0.31
 Version:           23.0.6
 API version:       1.42
 Go version:        go1.19.9
 Git commit:        ef23cbc
 Built:             Fri May  5 21:18:13 2023
 OS/Arch:           linux/amd64
 Context:           desktop-linux

Server: Docker Desktop 4.19.0 (106363)
 Engine:
  Version:          23.0.5
  API version:      1.42 (minimum version 1.12)
  Go version:       go1.19.8
  Git commit:       94d3ad6
  Built:            Wed Apr 26 16:17:45 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.20
  GitCommit:        2806fc1057397dbaeefbea0e4e17bddfbd388f38
 runc:
  Version:          1.1.5
  GitCommit:        v1.1.5-0-gf19387a
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

Check compose version

```shell
docker compose version
```

Example output

```shell
❯ docker compose version
Docker Compose version v2.17.3
```


## Optimise Log rotation

Docker uses the `json-file` driver which creates JSON objects of log events from all containers.  To avoid disk space issues, configure log rotation in a `/etc/docker/daemon.json` file

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

Use the [local file logging driver](https://docs.docker.com/config/containers/logging/local/) if a longer logging history is desirable.  The local file logging driver preserves 100Mb of logs per container (5 x 20Mb files) and uses automatic compression to greatly reduce disk consumption.

```json
{
  "log-driver": "local",
  "log-opts": {
    "max-size": "10m"
  }
}
```

<!-- TODO: does local logging driver work with Docker Desktop log explorer? -->

> --log-driver flag with `docker container create` or `docker run` commands sets the log driver for the specific container, over-riding the global setting

* [JSON File logging driver](https://docs.docker.com/config/containers/logging/json-file/)


## Access Private images on Docker Hub

[Create an account on Docker Hub](https://hub.docker.com/repositories) to push and pull custom Docker images.  [Enable 2-Factor authentication for the account](https://docs.docker.com/desktop/get-started/#two-factor-authentication) is highly recommended.

Docker Desktop uses a GNU gpg public-private key with the `pass` command to encrypt Docker hub credentials locally.

use an existing key for the operating system user account or create a new key with `gpg`.

```shell
gpg --generate-key
```

Enter an account name and email to generate the PGP key.

Use the `pass` command to initialise the GPG key for Docker Hub

```
pass init 700000033XXXXXXXXXXXXXXXXXXXXX6888888881
```

## Login in via Docker CLI

To use the access token from your Docker CLI client:

```shell
docker login -u practicalli
```

At the password prompt, enter the personal access token which has the form `dckr_pat_qLZq_XXXXXXXXXXXXXXXXXXXXXX`

* [GNU pgp credentials management](https://docs.docker.com/desktop/get-started/#credentials-management-for-linux-users)



## Docker Desktop Extensions

Practicalli uses the following extensions to manage the local Docker environment more effectively and provide additional tools to manage the services running in containers.

* [Log Explorer](https://hub.docker.com/extensions/docker/logs-explorer-extension)
* [Disk usage](https://hub.docker.com/extensions/docker/disk-usage-extension)
* [Resource usage](https://hub.docker.com/extensions/docker/resource-usage-extension)
* [Volumes backup & Share](https://hub.docker.com/extensions/docker/volumes-backup-extension)
* [Snyk security vulnerability scanner](https://hub.docker.com/extensions/snyk/snyk-docker-desktop-extension)
* [PostgreSQL database monitoring](https://hub.docker.com/extensions/mochoa/pgadmin4-docker-extension) - embedded PGAdmin4 tool

[Practicalli Engineering Playbook](https://practical.li/engineering-playbook/continuous-integration/docker/desktop-extensions/) details the use of these Docker Extensions

## References

* [Docker Getting Started](https://docs.docker.com/get-started/)
* [Alpine Linux package search](https://pkgs.alpinelinux.org/packages)
* [Repositories on Docker Hub](https://hub.docker.com/repositories)



Thank you

[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practcial_li)

<!-- Follow-on articles -->

<!-- * working with containers -->
<!-- * running a docker image -->
<!-- * connecting to an existing image -->
<!--   * Alpine Linux based image -->
<!--     * docker exec -it container-name ash -->
<!--     * docker exec -it container-name /bin/sh -->
<!--   * Ubuntu Linux based image -->
<!--     * docker exec -it container-name /bin/bash -->
<!-- * inspect -->
<!-- * docker ps -->
