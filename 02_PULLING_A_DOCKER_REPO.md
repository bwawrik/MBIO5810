## Downloading and launching a docker file

1. Create a droplet called 'bioinformatics'.
1. Log onto your digial ocean droplet and at the command prompt (root@bioinformatics:~# ) type:
    
    ```sh
    mkdir /data
    ```

    This creates a data folder in your droplet.  The folder we will mount into our docker and is needed so you can retrieve your analysis results after you are done.

1. Pull the docker file

    ```sh
    docker pull bwawrik/bioinformatics:latest
    ```
    This pulls my bioinformatics docker.  It may take a few minutes since the docker is over six gigabites in size.

1. Start your docker by typing

    ```sh
    docker run -t -i -v /data:/data bwawrik/bioinformatics:latest
    ```

Congratulations!! You are now running my bioinformatics docker! Perform all your analyses in the `/data` directory. When you exit the docker your files will be in `/data` on your droplet.

## Variations
Here are some tips if things aren't working as expected, and you're not using the standard Digital Ocean Droplet.

* You may need to install Docker, and start its daemon.  The different branches of Linux have different commands for installing Docker.  Once installed, check the status (and start the daemon if necessary) with 
    ```shell
    sudo service docker status
    sudo service docker start
    ```
* You may not be running as root (ie, with admin privileges) by default, so some commands may need to be prefaced with `sudo`.  Typically a command prompt ending with `#` indicates you're root; a prompt ending with `$` indicates you're a normal user who needs `sudo`.
    ```shell
    sudo mkdir /data #Instead of just "mkdir /data"
    
    sudo docker pull bwawrik/bioinformatics:latest
    ```