# docker-hadoop
Docker-container with hadoop service.

Link to images in the Docker Hub:

aliavm/namenode:1.1

aliavm/datanode:1.1

## Instruction 

Command to create docker-image Namenode 
```bash
docker build -f Dockerfile -t namenode:1.1 .
```
Next step you need to create docker-image Datanode
```bash
docker build -f Dockerfile1 -t datanode:1.1 .
```
After that you can run my script `start-all.sh`.
```bash
chmod +x start-all.sh
./start-all.sh
```
After a few minutes, you can test the Hadoop service.
If you use images from Docker Hub, you need to rename with help command:
```bash
docker tag aliavm/namenode:1.1 namenode:1.1
docker tad aliavm/datanode:1.1 datanode:1.1
```
Then you can use my script `start-all.sh`.
