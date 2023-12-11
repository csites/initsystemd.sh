#!/bin/sh
#
SCRIPTNAME=initsystemd.sh
BASENAME=`basename $0`

# initsystemd.sh fixed-that-for-you-script.  Copy this script into /etc/init.d using the name in the $SCRIPTNAME
# variable. Running this script using the SCRIPTNAME (/etc/init.d/$SCRIPTNAME) above will list all systemd 
# services names and create softlinks in init.d that point back to this script.  This script will then provide each
# service with a init.d like wrapper that calls systemd using the $0 argument and provide command to control
# that systemd services.  Each service in init.d will have the following options: 
# {start|status|stop|restart|condrestart|reload|enable|disable}

# CBS: 12/2015

if [ "$BASENAME" == "$SCRIPTNAME" ]; then
    TMPFILE=`mktemp`
    systemctl list-unit-files --type=service | grep -v static | cut -f 1 -d ' ' | sed s/.service//g > $TMPFILE

    for i in `cat $TMPFILE`
    do
           if [ "$1" == "clean" ]; then
            A=`find $i -maxdepth 1  -type l -ls | grep $SCRIPTNAME`
            if [ -n A ]; then 
                rm $i
            fi
        else
            if [ ! -f /etc/init.d/$i ]; then 
                 ln -s /etc/init.d/$SCRIPTNAME /etc/init.d/$i
            fi
        fi
    done
    rm $TMPFILE
    exit 0
fi

# Now the systemd wrapper command start|status|stop|restart|condrestart|reload|enable|disable
# enable and disable would normally be done with chkconfig but I put them here for convience. 
start () {
    echo -n "Starting $BASENAME..."

    systemctl start $BASENAME

    RETVAL=$?
    if [ $RETVAL = 0 ]
    then
        echo "done."
    else
        echo "failed. See error code for more information."
    fi
    return $RETVAL
}

stop () {
    # stop daemon
    echo -n "Stopping $BASENAME..."

    systemctl stop $BASENAME
    RETVAL=$?

    if [ $RETVAL = 0 ]
    then
        echo "done."
    else
        echo "failed. See error code for more information."
    fi
    return $RETVAL
}


restart () {
    systemctl restart $BASENAME
}

condrestart () {
    systemctl condrestart $BASENAME
}

reload () {
    systemctl reload $BASENAME
}

enable () {
    systemctl enable $BASENAME
}

disable () {
    systemctl disable $BASENAME
}


status () {
    systemctl status $BASENAME
    return $?
}

statusl () {
    systemctl status -l $BASENAME
    return $?
}


case "$1" in
    start)
        start
    ;;
    status)
	if [ "$2" == "-l" ]; then
	    statusl
        else
	    status
	fi
    ;;
    statusl)
	statusl
    ;;
    stop)
        stop
    ;;
    restart)
        restart
    ;;
    condrestart)
        restart
    ;;
    reload)
        reload
    ;;
    enable)
        enable
        start
    ;;
    disable)
        stop
        disable
    ;;
    *)
        echo $"Usage: $BASENAME {start|status|stop|restart|condrestart|reload|enable|disable}"
        exit 3
    ;;
esac

exit $RETVAL
