Run your own `bitcoin-knots` container on Unraid (Docker) and access `bitcoin-qt` in `WebUI` using browser.

![Pasted image 20250627161810](https://github.com/user-attachments/assets/3b01d4c0-498c-4f30-8c14-e0188b08878d)



---

### 1. Prepare a new share in Unraid using NVMe as a primary storage

 Bitcoin nodes needs **fast random I/O** and Prefer **low latency**, **high write endurance**, and **fast reads**. A `Nvme` Pool Device with at least 1Tb in disk space will be perfect for that. Do not use Unraid Array to store blockchain data as it's verry slow due to parity. 
 Once your NVMe is attached and added to the list of Pool Device:
 
Go to **Unraid** → **Shares** → **Add Share**

| Line            | Value   | Comments                                                                                                                               |
| --------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| Share Name      | bitcoin | Can be any name of your dedicated share to store blockchain data and configurations.                                                   |
| Primary Storage | Nvme    | It's important to select from drop down menu your Pool device pointing to nvme                                                         |
| Export          | Yes     | temporary grant read/write access to the share to make sure dockerfile can be uploaded from github.                                    |
| Security        | Public  | You need read/write access to the share. Do not forget to change to **Secure** or **Private** at the end once everything is configured |

![Pasted image 20250627114331](https://github.com/user-attachments/assets/8dd7997f-6a21-4a41-aa68-de112cc0074d)


---

### 2. Copy Dockerfile, blockchain data and bitcoin.conf file.

If you have a copy of blockchain data: `blocks` and `chainstate` folders - move blockchain data using **Unraid's mover tool** or do it manually:

``` bash
# Move appdata from cache to nvme pool 
mv -v /mnt/cache/appdata/bitcoin/* /mnt/user/bitcoin/
```


Download the project manually as a ZIP or clone it using `git` 

``` shell
git clone https://github.com/sv1slim/bitcoinknots-unraid
```


Copy `Dockerfile-BitcoinKnots-GUI-xx.x` folder with the latest version `xx.x` into your `\\unraid.local\bitcoin` share.

Copy `bitcoin.conf` to the main `bitcoin` share. Don't forget to change RPC password.

---

### 3. Build the image on Unraid

Open Unraid Terminal and get into `Dockerfile` folder.

``` bash
cd /mnt/user/bitcoin/Dockerfile-BitcoinKnots-GUI-28.1/
```

Run docker build command to create `bitcoin-knots-gui` image using `Dcokerfile` located in `/mnt/user/bitcoin/Dockerfile-BitcoinKnots-GUI-xx.x/` folder.

``` bash
docker build -t bitcoin-knots-gui .
```

Once finished, confirm that image exists in Unraid by listing all images. The first one in the list should be `bitcoin-knots-gui` image.

``` bash
docker images
```

![image](https://github.com/user-attachments/assets/6c908fa5-923a-4338-b780-be7b9abf321f)

---

### 4. Deploy Unraid container from bitcoin-knots-gui image**

To deploy the `bitcoin-knots-gui` image in Unraid go to:

**Docker** → **Add Container** → Change **Basic View** to **Advanced View**

Use these settings:

| Line             | Value                                    |
| ---------------- | ---------------------------------------- |
| Name             | bitcoin-knots-gui                        |
| Repository       | bitcoin-knots-gui                        |
| Icon URL         | https://bitcoinknots.org/favicon.ico     |
| WebUI            | http://[IP]:[PORT:6080]/vnc.html         |
| Network Type     | `Bridge` (or `Host`, depending on setup) |
| Extra Parameters | --restart unless-stopped                 |

![Pasted image 20250627160403](https://github.com/user-attachments/assets/914e3f3e-cbeb-4d97-8a2b-87d121ee4891)


###### **Add Volume Mapping**

Click **Add another Path, Port, Variable, Label or Device** → Config Type: **Path**

| Config Type    | Path                 |
| -------------- | -------------------- |
| Name           | Blockchain data      |
| Container Path | `/bitcoin`           |
| Host Path      | `/mnt/user/bitcoin/` |

###### **Add Port Mappings:**

| Name             | Container Port | Host Port | Connection Type |
| ---------------- | -------------- | --------- | --------------- |
| Bitcoin P2P port | 8333           | 8333      | TCP             |
| RPC port         | 8332           | 8332      | TCP             |
| VNC_PORT         | 5900           | 5900      | TCP             |
| NOVNC_PORT       | 6080           | 6080      | TCP             |

![Pasted image 20250627160657](https://github.com/user-attachments/assets/ca40f43e-1c06-465d-aae3-561c0dcbcab0)


`APPLY` the changes → Go to **Docker** tab → Click on `bitcoinknots` container icon → `Logs` → check if the blockchain is synching. 

---

Note: If want to run `bitcoin-knots-gui` image in Docker on your PC or MAC - you need to download [Docker Desktop](https://www.docker.com/products/docker-desktop/) or [Rancher Desktop](https://rancherdesktop.io/) and build the image on your PC that contains the app.

Use `docker run` command below if you want to spin the container in Docker instead. 

``` bash
docker run -d \
  --name=bitcoin-knots-gui \
  -p 8332:8332 \
  -p 8333:8333 \
  -p 8333:5900 \
  -p 8333:6080 \
  -v /mnt/user/bitcoin:/bitcoin \
  --restart unless-stopped \
  bitcoin-knots-gui

```
