<h1> Nextcloud All-in-One </h1>

<h2> Table of Contents </h2>

- [Introduction](#introduction)
- [Create the Docker Image](#create-the-docker-image)
- [Convert the Docker Image to Zero-OS FList](#convert-the-docker-image-to-zero-os-flist)
- [TFGrid Deployment](#tfgrid-deployment)
  - [Playground Steps](#playground-steps)
  - [Set the DNS Record for Your Domain](#set-the-dns-record-for-your-domain)
- [Conclusion](#conclusion)

***

## Introduction

This Nextcloud All-in-One (AIO) FList can be deployed on a micro VM on the ThreeFold Grid, either via the TF Playground, or Terraform. This FList uses `Ubuntu 22.04` and also includes the preinstalled `openssh-server` package. Docker is installed directly from [www.get.docker.com](https://get.docker.com/). This FList  Nextcloud All-in-One is installed based on the latest Nextcloud All-in-One release from the Docker Hub.

To simply deploy the available FList on the ThreeFold Playground, skip to [this section](#playground-steps).

Note that the official FList for Nextcloud All-in-One is the following:

```
https://hub.grid.tf/tf-official-apps/threefoldtech-nextcloudaio-latest.flist
```

***

## Create the Docker Image

To create the the Nextcloud AIO image, clone this repository, then build and push the image to the Docker Hub.

* Clone the repository:
  * ```
    git clone https://github.com/threefoldtech/tf-images
    ```
  * ```
    cd tf-images
    ```
* Build the image:
  * ```
    docker build -t <docker_username>/<docker_repo_name> .
    ```
* Push the image to the Docker Hub:
  * ```
    docker push <your_username>/<docker_repo_name>
    ```
 
***

## Convert the Docker Image to Zero-OS FList

The easiest way to convert the docker image to an FList is by using the [Docker Hub Converter Tool](https://hub.grid.tf/docker-convert). This can be done once you've built and pushed the docker image on the [Docker Hub](https://hub.docker.com/).

> Note: A docker image has already been converted to an FList (see below).

* Go to the [ThreeFold Hub](https://hub.grid.tf/).
* Sign in with the ThreeFold Connect app.
* Go to the [Docker Hub Converter](https://hub.grid.tf/docker-convert) section.
* Next to `Docker Image Name`, add the docker image repository and name, see the example below:
  * Template:
    * `<docker_username>/docker_image_name:tagname`
* Click `Convert the docker image`.
* Once the conversion is done, the FList is available as a public link on the ThreeFold Hub.
* To get the FList URL, go to the [TF Hub main page](https://hub.grid.tf/), scroll down to your 3Bot ID and click on it.
* Under `Name`, you will see all your available FLists.
* Right-click on the FList you want and select `Copy Clean Link`. This URL will be used when deploying on the ThreeFold Playground. We show below the template and an example of what the FList URL looks like.
  * Template:
    * ```
      https://hub.grid.tf/<3BOT_name.3bot>/<docker_username>-<docker_image_name>-<tagname>.flist
      ```

***
## TFGrid Deployment

The easiest way to deploy a micro VM using the Nextcloud AIO FList is to head to to the [ThreeFold Playground](https://play.grid.tf) and deploy a [Micro Virtual Machine](https://play.grid.tf/#/vm) by providing the FList URL. Make sure to select `IPv4`.

Make sure to provide the correct entrypoint (`/sbin/zinit init`). Note that the entrypoint should already be set by default when you open the micro VM page. 

You could also use Terraform instead of the Playground to deploy the Nextcloud AIO Micro VM. Read more on this [here](https://github.com/threefoldtech/terraform-provider-grid).

### Playground Steps

* Go to the [ThreeFold Playground](https://play.grid.tf)
* Log into your TF wallet
* Go to the [Micro VM](https://play.grid.tf/#/vm) page
* In the section `Config`, 
  * Choose a name for your VM under `Name`.
  * Under `VM Image`, select `Other`.
    * Enter the Nextcloud FList under `FList`:
      * Template:
        * ```
          https://hub.grid.tf/<3BOT_name.3bot>/<docker_username>-<docker_image_name>-<tagname>.flist
          ```
      * Example:
        * ```
          https://hub.grid.tf/tf-official-apps/threefoldtech-nextcloudaio-latest.flist
          ```
  * Under `Entry Point`, the following should be set by default: `/sbin/zinit init`
  * Under `Root File System (GB)`, choose at least 8 GB.
  * Under `CPU (vCores)`, choose at least 2 vCores (minimum).
  * Under `Memory (MB)`, choose at least 4096 MB of RAM (minimum).
  * Make sure that `Public IPv4` is enabled (required).
* In the section `Disks`, click on the `+` button and choose at least 50 GB of storage  under `Size (GB)`.
* Click `Deploy`.
* Go to the following URL:
  * ```
    https://<VM_IPv4_Address>:8080
    ```
  * It might take a couple of minutes to start the Nextcloud instance
* Follow the Nextcloud AIO steps

### Set the DNS Record for Your Domain

* Go to your domain name registrar (e.g. Namecheap)
  * In the section Advanced DNS, add a DNS A Record to your domain and link it to the VM IPv4 Address
    * Type: A Record
    * Host: @
    * Value: VM IPv4 Address
    * TTL: Automatic
  * It might take up to 30 minutes to set the DNS properly.
  * To check if the A record has been registered, you can use a common DNS checker:
    * ```
      https://dnschecker.org/#A/<domain-name>
      ```

Note that you can also use DDNS services such as [DuckDNS](https://www.duckdns.org/) for a domain name.

## Conclusion

We've seen the overall process of creating a new FList to deploy a Nextcloud AIO workload on a Micro VM on the ThreeFold Playground.

If you have any questions or feedback, please let us know by either writing a post on the [ThreeFold Forum](https://forum.threefold.io/), or by chatting with us on the [TF Grid Tester Community](https://t.me/threefoldtesting) Telegram channel.