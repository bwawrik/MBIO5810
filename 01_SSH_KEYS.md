## SSH KEYS

### ON PC
- download Putty (http://the.earth.li/~sgtatham/putty/latest/x86/putty.zip)
- unzip putty.exe and puttygen.exe
- open puttygen and press generate
- move mouse around in blank area till key generation is complete
- the passphrase is not required but adds an additional layer of security
- save public key
-- i have a directory on my computer where I keep my ssh keys; give it a name that lets you remember what is for e.g. 'digital_ocean_public_key'
Your public key will be uploaded to the VM when you create it.
        save private key
            e.g. 'digital_ocean_private_key.ppk'
            This private key will only work for the machine you are working on. It can not be copied to another computer and used there. You will generate a new key for each computer you want to log onto a machine with.
            NEVER share your private key, email it, or store it in the cloud e.g. in dropbox.
### ON MAC
        open iTERM
        type 'cd /Users/[username]/.ssh'
        type 'ssh-keygen'
        name your key (e.g. 'digital_ocean')


## Setting up the server:

    Go to DigitalOcean.com and set up an account.
        https://cloud.digitalocean.com
    Add $5 to your account by using the paypal option to charge your credit card
    Add $5 to your account using the promo code 'EMAIL5AUG!' (this will only work if you first make a $5 payment)
    You should now have $10 in your account.  The smallest instance is 0.7c per hour, so you can happily hack for >1400 hours
    To start your instance go to 'Droplets'
        select 'create droplet'
            Name your droplet
            select the smallest size i.e. 0.007 per hour (512 MB / 1 CPU 20 GB SSD Disk 1000 GB Transfer)
            select region 'New York'
            under image select 'CENTOS 7X64'
                select the Applications tab
                check DOCKER 1.5.0
            either select the SSH keys you want to use or press the 'Add SSH Keys' button
                ON PC
                    open up puttygen and load your private key (e.g. 'digital_ocean_public_key')
                    copy the text from the puttygen public key text box into the web browser text box
                             remove the last part of the key that looks something like this (rsa-key-20150220); this line is not needed
                        e.g. a key should looks something like this:
                        ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA0iHWWDkJRXqQytjV6jaESVFuhqSbdrEBpP0e ztW/cRU2hWlHgpk9isp8yDXeaNHsySLeSncmw09SkMoXaib6YPp2a2tLz9QrjpiaZ7Hkcmw7Xc cy/jnJ287wn0se7B0yGtMRzLaRcBAlkF5iL09v65/tnVPQa22JGc0yhBS6eptRO1 IbKQ/Dahzc1AvK9ivOxC7Hkcmw7Xcwbl7a0kR57vXrov76Il2rHW25FIDswvdnFYV6w+M4 4+6IRIPOVXB5zY7IJJq1eum3J4UzrozsrX6wQiSHuPyjRcuzeJSARUO265QoVqxv i+PnVrxN6PRJMCP3hFW/Hrg0RFQ6E+Cqv8OqvdY3GYuhJa0d4w==
                    press add key; you will only have to do this once.  Next time you create a VM you will be albe to recycle this key
                ON MAC
                    type 'cd ~/.ssh'
                    to display your public key type 'cat digital_ocean.pub'
                    copy text from public key into the web browser text box (see above for what a public key should look like)
                    press add key; you will only have to do this once.  Next time you create a VM you will be albe to recycle this key
            Press create droplet
            copy down the IP address of the server

## Logging onto your VM

### ON PC

    open putty
    paste IP address into 'Host Name' box
    Name the session (e.g. 'Digital Ocean') under 'Saved Sessions' and press 'Save'
    Under 'Connection' click the little plus to open up the SSH sub-menu
    Select 'Auth'
    Press browse and select your public key (e.g. 'digital_ocean_private_key.ppk')
    select 'Data'
    in 'Auto-login username' enter the word "root"
    Go back to 'Session' tab and press 'save'
    Press open
    Press 'yes' if you get the PuTTY Security Alert window
    On future logins, you  can simply load this setup without having to re-configure.


### ON MAC

open iTerm
type 'cd ~/.ssh'
type 'rm -f ~/.ssh/known_hosts'
type 'ssh -i key_name root@IP'

      key_name e.g. digital_ocean
      IP is the IP address of the host you are trying to connect to.
      you log on as root on these droplets

if you get an error about permissions 600, reset permissions for your key by typing 'cd .ssh'
