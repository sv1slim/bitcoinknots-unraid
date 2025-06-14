# bitcoinknots-unraid
Contains instructions on how to create your own bitcoinknots image and run it in UNRAID or Docker.
### 1. Create a Dockerfile

Dockerfile

Copy `Dockerfile` to a working folder.

### 2. Build and Deploy

Open Command Promtp on Widnows or Terminal in MAC and navigate to into your working directory. In order to be able to execute docker command you need to have either [Docker Desktop](https://www.docker.com/products/docker-desktop/) or [Rancher Desktop](https://rancherdesktop.io/) installed on your PC\MAC.
Run docker build command to create `bitcoinknots` image using `Dcokerfile` located in the same folder.

``` bash
docker build -t bitcoinknots .
```

Once finished, confirm that image exists in your local PC\MAC by listing all images.

``` bash
docker images
```

### 3. Save + Transfer the Docker Image to Unraid**

From the same working directory execute command to export the image into a `.tar` archive. bitcoinknots.tar file will be created next to 'Dockerfile'

``` bash
docker save -o bitcoinknots.tar bitcoinknots
```

Open the Unraid share on Windows (e.g., `\\tower\appdata`)
Transfer the File `bitcoin-knots-webui.tar` to Unraid `/mnt/user/appdata/docker-images/` (create if needed, can be any location)

Login to Unraid or use the `Terminal` to execute `docker load` command. The command will create an image from archive to make sure an Unraid container can be created.

``` bash
docker load -i /mnt/user/appdata/docker-images/bitcoinknots.tar
```

After completion check if image was added to the list.

```bash 
docker images
```

### 4 bitcoinknots configuration

Create `/mnt/user/appdata/bitcoinknots/` folder. If you have full access to SMB share create `bitcoinknots` folder using `\\tower\appdata`. Where tower can be your unraid hostname or ip.
Place your `bitcoin.conf` and blockchain data in: `/mnt/user/appdata/bitcoinknots/`

``` ini
server=1
rpcuser=rpcuser
rpcpassword=rpcpassword
txindex=1
zmqpubrawtx=tcp://0.0.0.0:28332
zmqpubrawblock=tcp://0.0.0.0:28333
```

Note `/mnt/user/appdata/bitcoinknots/` folder should have at least 1Tb disk space. Otherwise you have to create `bitcoinknots` folder as a dedicated Share where the full path will be something like `/mnt/user/bitcoinknots/`

---

### 5. Run the Container

To spin the `bitcoinknots` image as a container in Unraid usign Unraid GUI go to:

**Docker** → **Add Container** → Change `Basic Vinew` to `Advanced View` 

Use these settings:

| Name:             | bitcoinknots                             |
| ----------------- | ---------------------------------------- |
| Repository:       | bitcoinknots                             |
| Network Type      | `Bridge` (or `Host`, depending on setup) |
| Icon URL:         | https://bitcoinknots.org/favicon.ico     |
| Extra Parameters: | --restart unless-stopped                 |

##### **Add Volume Mapping**

Click **Add another Path, Port, Variable, Label or Device** as needed.
You should add:

First path:

| Type:          | **Path**                       |
| -------------- | ------------------------------ |
| Name:          | Blockchain data                |
| Container Path | `/bitcoin`                     |
| Host Path      | /mnt/user/appdata/bitcoinknots |

###### **Port Mappings:**

| Name             | Container Port | Host Port | Connection Type |
| ---------------- | -------------- | --------- | --------------- |
| Bitcoin P2P port | 8333           | 8333      | TCP             |
| RPC port         | 8332           | 8332      | TCP             |

here is the screenshot 

![image](https://github.com/user-attachments/assets/f2bd34b7-9a89-4432-89db-6b7229e119c0)


DONE > Click on Container icon > `Logs` > check if the blockchain is synching. 


If want to run it in Docker run the follwing command.

``` bash
docker run -d \
  --name=bitcoinknots \
  -p 8332:8332 \
  -p 8333:8333 \
  -v /mnt/user/appdata/bitcoinknots:/bitcoin \
  --restart unless-stopped \
  bitcoinknots

```
