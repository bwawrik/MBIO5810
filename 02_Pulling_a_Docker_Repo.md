## Downloading and launching a docker file

- Create a droplet called 'bioinformatics'.

I then log onto my digial ocean droplet and at the command prompt (root@bioinformatics:~# ) I type:

root@bioinformatics:~# mkdir /data

This creates a data folder in your droplet.  This is the folder we will mount into our docker.  This is needed so you can retrieve your analysis results after you are done.

root@bioinformroatics:~# docker pull bwawrik/bioinformatics:latest

It will now download my bioinformatics docker.  This may take a second since the docker is over six gigabites in size.
Then start your docker by typing

root@bioinformatics:~# docker run -t -i -v /data:/data bwawrik/bioinformatics:latest

Congratulations !! You are now running my bioinformatics docker ! Perform all your analyses in /data. When you exit the docker your files will be in /data on your droplet.


