## Downloading and launching a docker file

- Create a droplet called 'bioinformatics'.
- Log onto your digial ocean droplet and at the command prompt (root@bioinformatics:~# ) type:

```sh
mkdir /data
```

- This creates a data folder in your droplet.  The folder we will mount into our docker and is needed so you can retrieve your analysis results after you are done.
- Now pull the docker file

```sh
docker pull bwawrik/bioinformatics:latest
```
- This pulls my bioinformatics docker.  It may take a few minutes since the docker is over six gigabites in size.
- Start your docker by typing

```sh
docker run -t -i -v /data:/data bwawrik/bioinformatics:latest
```

Congratulations !! You are now running my bioinformatics docker ! Perform all your analyses in /data. When you exit the docker your files will be in /data on your droplet.


