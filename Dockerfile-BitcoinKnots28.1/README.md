Run your own `bitcoinknots` container on Unraid or Docker.

![image](https://github.com/user-attachments/assets/6acc47ad-3c0a-4676-9813-fbc583f906db)

---

### 1. Prepare a new share in Unraid

Go to **Unraid** → **Shares** → **Add Share**

Share Name: **bitcoin**

Export:     **Yes**

Security:   **Public** (do not forget to change to **Secure** or **Private** at the end)

![image](https://github.com/user-attachments/assets/830b45b1-ea0a-42e7-b0de-6955363eaada)

---

### 2. Copy Dockerfile, blockchain data and bitcoin.conf file.

Download the project as a ZIP and copy `Dockerfile-BitcoinKnotsXX.X` folder with the latest version into your `\\unraid.local\bitcoin` location.

If you have a copy of blockchain data, copy `blocks` and `chainstate` folders into the same Unraid share. 

Create a `bitcoin.conf` file in your `bitcoin` Unraid share. This file must be created, otherwise you would not be able to connect to your copy of blockchain.

Replace `myuser` and `mypassword` with a strong username and password.

`bitcoin.conf`
``` ini
server=1
rpcuser=myuser
rpcpassword=mypassword
txindex=1
zmqpubrawtx=tcp://0.0.0.0:28332
zmqpubrawblock=tcp://0.0.0.0:28333
```

![image](https://github.com/user-attachments/assets/137af59f-f3b2-4d10-b47b-57ad09a30220)


---

### 3. Build the image on Unraid

Open Unraid Terminal and get into `Dockerfile` folder

``` bash
cd /mnt/user/bitcoin/Dockerfile-BitcoinKnots28.1/
```

Run docker build command to create `bitcoinknots` image using `Dcokerfile` located in `/mnt/user/bitcoin/Dockerfile-BitcoinKnotsXX.X/` folder.

``` bash
docker build -t bitcoinknots .
```

Once finished, confirm that image exists in Unraid by listing all images. The first one in the list should be `bitcoinknots` image.

``` bash
docker images
```

![image](https://github.com/user-attachments/assets/6c908fa5-923a-4338-b780-be7b9abf321f)

---

### 4. Deploy Unraid container from bitcoinknots image**

To deploy the `bitcoinknots` image in Unraid go to:

**Docker** → **Add Container** → Change `**Basic Vinew**` to `**Advanced View**` 

Use these settings:

| Line              | Value                             |
| ----------------- | ---------------------------------------- |
| Name              | bitcoinknots                             |
| Repository        | bitcoinknots                             |
| Icon URL          | https://bitcoinknots.org/favicon.ico     |
| Network Type      | `Bridge` (or `Host`, depending on setup) |
| Extra Parameters  | --restart unless-stopped                 |

##### **Add Volume Mapping**

Click **Add another Path, Port, Variable, Label or Device** → Config Type: **Path**


| Config Type    | Path                           |
| -------------- | ------------------------------ |
| Name           | Blockchain data                |
| Container Path | `/bitcoin`                     |
| Host Path      | `/mnt/user/bitcoin/`           |

###### **Add Port Mappings:**

| Name             | Container Port | Host Port | Connection Type |
| ---------------- | -------------- | --------- | --------------- |
| Bitcoin P2P port | 8333           | 8333      | TCP             |
| RPC port         | 8332           | 8332      | TCP             |


![image](https://github.com/user-attachments/assets/a1c9d8a8-f775-40b5-b570-a71a436c51a4)



`APPLY` the changes → Go to **Docker** tab → Click on `bitcoinknots` container icon → `Logs` → check if the blockchain is synching. 

---

Note: If want to run same immage in Docker on your PC or MAC - you need to download [Docker Desktop](https://www.docker.com/products/docker-desktop/) or [Rancher Desktop](https://rancherdesktop.io/) and execute all the commands abouve.

Use `docker run` command below if you want to spin the container in Docker instead. 

``` bash
docker run -d \
  --name=bitcoinknots \
  -p 8332:8332 \
  -p 8333:8333 \
  -v /mnt/user/appdata/bitcoinknots:/bitcoin \
  --restart unless-stopped \
  bitcoinknots

```
