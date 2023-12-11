# initsystemd.sh
Convert systemd system files to an init.d type startup

What is this?  In the old days of Unix and early Linux there existed a directory in /etc called init.d.   Contained in the directory of init.d where the startup scripts to initialize the operating system.  It was a simple way of starting, stopping, and getting the status of an application or daemon since all you had to do was type /etc/init.d/service_name start to start a service. Same for stop, status, reload, etc.  If you're an old Unix admin, it became a habit 
to look into the /etc/init.d directory to see what services were available.   So way back in 2015 when Systemd was starting to spread into the Linux world, I thought the transition from the /etc/init.d was just too abrupt and disruptive to sysadmins that needed to get work done.   Systemd also broke a very important unix world rule;  That being; 'Thou shall not create a filename with a leading '-' character".   It breaks simple command line wildcards.   So if you ever go to the /lib/systemd/system directory and type cat -.slice.   It will give an error about the command line switch.   As much as I tried to get them to rename the slice file to something sane, and even reported it as a bug,  Just call it root.slice .. it was never fixed, and many, many, many excuses to leave it.  So to simplify my life,  I created this script.  It's basically a universal single script and very space-efficient.   First, create your/etc/init.d directory (mkdir /etc/init.d). Then run this script /etc/initsystemd.sh and it will create a single /etc/init.d/initsystemd.sh script and create a soft link to itself for every Systemd *.service contained in the directory /lib/systemd/system.  The initsystemd.sh provides all of the old charms of the init scripts of yesteryear.  Once done you can see all of the services available with a simple 'ls' command of the /etc/init.d directory.   You can start, stop, restart and reload services.   You can get a quick status of a service with 'status' command or get the long version with a /etc/init.d/someservice status -l.   You can enable and disable services all without ever having to type 'systemctl status someservice -l' or any of the other contorted ways of looking for a service.  So this doesn't get rid of systems, it just provides an easier means to manage the systemd services.  Just basically put the initsystemd.sh script anywhere and run it once to initialize the services, if a new service is added, run it again and the new service will be added.  If you just don't like using /etc/init.d or you just wanted to see what it does. just run 'initsystemd clean' and it will remove all the services that it created in /etc/init.d and leave anything that was not a mapped systemd service. 

