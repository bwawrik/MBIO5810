Lets make a simple docker that allows you to assemble with Ray and predict ORFs with Prodigal as done in the prior tutorials.
First, you will need to visit the Docker website and create an account (if you don't have one already)
   

    Go to www.docker.com
    Enter a login name, email address, and password
    Go do your email and verify account creation
    Once you have verified your account go to 'login' and enter your credentials
        https://hub.docker.com/account/login/


Create a repository by clicking the blue '+ Add Repository \/' Button on the right hand side of the screen. If you can't see the button, make sure you have selected 'Summary' on the left had side under your login ID.

    The repository will need a name.  I will name mine 'Gulpereel' for this tutoria
    Provide a description like 'Hello World docker repository'
    select 'public' (private cost money)
    push 'Create Repository'
        This creates a repository to which you can push a docker you create


Go to a Linux environment that has Docker installed.  This can be a droplet, boot2docker on your laptop, or a Linux PC.

The first step will be to pull a basic Linux installation from which we can make modifications.

docker pull centos
note: This command pulls the latest version of centos. By default the latest verion is pulled. 'docker pull ubuntu' will pull Ubuntu 14.04.


After it is done pulling the image layers, you can inspect which images are present on your machine using

docker images

Note: Your output will look something like this:
REPOSITORY           TAG                    IMAGE ID                CREATED            VIRTUAL SIZE
bwawrik/qiime            latest                   c7b8ab1b04fc        12 days ago          5.935 GB
centos                       latest                   fd44297e2ddb        3 weeks ago         215.47 MB

You should see an image tagged as REPOSITORY = 'centos'  and TAG = 'latest'.  The nomenclature for this repository is centos:latest. Alternatively, the repository can be identified with the IMAGE ID. In my case IMAGE ID = ' fd44297e2ddb'. This will be important further down.

Now lets run your docker

docker run -t -i centos:latest

You will need to install some dependencies for Ray and Prodigal, which we will install below. 'Yum' is a package manager used by centos. It is similar to 'apt-get' under ubuntu. First update Yum

yum update
note: select 'yes' throughout the process when prompted

Now install the needed dependencies

yum install nano wget -y
yum groupinstall -y 'Development Tools' -y
yum install zlib-devel.x86_64yum install sudo -y
yum install openmpi.x86_64 openmpi-devel.x86_64
yum install mpich2.x86_64 mpich-devel.x86_64 mpich.x86_64 -y

Now lets make a directory to deploy software

mkdir -p /opt/local/software

Install Prodigal 2.50

cd /opt/local/software
wget http://prodigal.ornl.gov/zips/prodigal.v2_50.tar.gz
gunzip prodigal.v2_50.tar.gz
tar -xvf prodigal.v2_50.tar

cd prodigal.v2_50

make
cd /usr/local/bin
sudo ln -s /opt/local/software/prodigal.v2_50/prodigal ./prodigal

Install Ray 2.3.2

cd /opt/local/software
wget http://sourceforge.net/projects/denovoassembler/files/Ray-2.3.1.tar.bz2
bunzip2 Ray-2.3.1.tar.bz2
tar -xvf Ray-2.3.1.tar
cd Ray-2.3.1
make prefix=ray-build MAXKMERLENGTH=64 MPICXX=/usr/lib64/openmpi/bin/mpicxx
make install
mv install-prefix/ ray-build/
echo 'export PATH=$PATH:/opt/local/software/Ray-2.3.1/ray-build' | tee -a ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/openmpi/bin' | tee -a ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/openmpi/lib' | tee -a ~/.bashrc
source ~/.bashrc

Lets commit your changes. First you'll need to exit the docker. Then you will need to find the 'container' that contains all the software you just installed.

exit

Note: on occasion you get the message 'There are stopped jobs.'. In that case, you will need to type 'exit' again until you exit the docker.

Find the last container that was edited:

docker ps -l

In my case, I got:
CONTAINER ID  IMAGE           COMMAND        CREATED        STATUS        PORTS               NAMES
206278e38cd6  centos:latest   "/bin/bash"    19 minutes ago     Exited                            mad_einstein

Find your CONTAINER ID and commit your changes

docker commit 206278e38cd6

Note: you should get a long hash tag as confirmation. In my case here: 1b9db728ff675cd69d4767b27f2cedb230c024885f743b4522683a1e1640c268

You will now need to tag your docker image. To do this, you will need to find the new IMAGE ID

docker images

Note the new untagged image that appeared in my list.
REPOSITORY           TAG                    IMAGE ID                CREATED            VIRTUAL SIZE
<none>                     <none>               1b9db728ff67          2 minutes ago       1.03 GB
bwawrik/qiime            latest                   c7b8ab1b04fc        12 days ago          5.935 GB
centos                       latest                   fd44297e2ddb        3 weeks ago         215.47 MB

Tag your image with REPOSITORY and a TAG identifying the version'

docker tag IMAGE ID <dockerID>/<repository>:version

Note: In my case, this command was: docker tag 1b9db728ff67 bwawrik/gulpereel:version_1

You can re-list your images to see if it worked:

docker images

Note the new untagged image that appeared in my list.
REPOSITORY           TAG                    IMAGE ID                CREATED            VIRTUAL SIZE
bwawrik/gulpereel     version_1            1b9db728ff67          2 minutes ago       1.03 GB
bwawrik/qiime            latest                   c7b8ab1b04fc        12 days ago          5.935 GB
centos                       latest                   fd44297e2ddb        3 weeks ago         215.47 MB


There is only one thing left to do - push your new docker to your repository:
docker push REPOSITORYl:TAG
In my example:

docker push bwawrik/gulpereel:version_1

Note: If this is your first commit from your computer since booting up the VM, the command prompt will ask you for your ID, password, and email address. Enter those and sit back. The push can take a little while.

You are now ready to pull your assembly & gene prediction docker on any other machine.

