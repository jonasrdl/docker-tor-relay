#!/usr/bin/env bash
echo "Using NICKNAME=${NICK}, OR_PORT=${OR_PORT}, DIR_PORT=${DIR_PORT}, TYPE=${TYPE} and EMAIL=${EMAIL}."

ADDITIONAL_VARIABLES_PREFIX="RELAY__"
ADDITIONAL_VARIABLES=

if [[ "$RELAY_ENABLE_ADDITIONAL_VARIABLES" == "1" ]]
then
    ADDITIONAL_VARIABLES="# Additional properties from processed '$ADDITIONAL_VARIABLES_PREFIX' environment variables"
    echo "Additional properties from '$ADDITIONAL_VARIABLES_PREFIX' environment variables processing enabled"

    IFS=$'\n'
    for V in $(env | grep "^$ADDITIONAL_VARIABLES_PREFIX"); do
        VKEY_ORG="$(echo $V | cut -d '=' -f1)"
        VKEY="${VKEY_ORG#$ADDITIONAL_VARIABLES_PREFIX}"
        VVALUE="$(echo $V | cut -d '=' -f2)"
        echo "Overriding '$VKEY' with value '$VVALUE'"
        ADDITIONAL_VARIABLES="$ADDITIONAL_VARIABLES"$'\n'"$VKEY $VVALUE"
    done
fi

if [[ "$TYPE" == "middle" ]]
then
    printf "\n
    RunAsDaemon 0 \n
    SocksPort 0 \n
    DataDirectory /var/lib/tor \n
    Nickname ${NICK} \n
    ContactInfo ${EMAIL} \n
    ORPort ${OR_PORT} \n
    DirPort ${DIR_PORT} \n
    MyFamily ${FAMILY} \n
    ExtORPort auto \n
    Log notice file /var/log/tor/log \n
    Log notice stdout \n
    ExitRelay 0 \n
    ExitPolicy reject *:* \n

    $ADDITIONAL_VARIABLES
    " > /etc/tor/torrc
fi

if [[ "$TYPE" == "reduced-exit" ]]
then
    printf "\n
    RunAsDaemon 0 \n
    SocksPort 0 \n
    DataDirectory /var/lib/tor \n
    Nickname ${NICK} \n
    ContactInfo ${EMAIL} \n
    ORPort ${OR_PORT} \n
    DirPort ${DIR_PORT} \n
    MyFamily ${FAMILY} \n
    ExtORPort auto \n
    Log notice file /var/log/tor/log \n
    Log notice stdout \n
    ExitRelay 1 \n
    ExitPolicy accept *:20-21     # FTP \n
    ExitPolicy accept *:43        # WHOIS \n
    ExitPolicy accept *:53        # DNS \n
    ExitPolicy accept *:80        # HTTP \n
    ExitPolicy accept *:110       # POP3 \n
    ExitPolicy accept *:143       # IMAP \n
    ExitPolicy accept *:220       # IMAP3 \n
    ExitPolicy accept *:443       # HTTPS \n
    ExitPolicy accept *:873       # rsync \n
    ExitPolicy accept *:989-990   # FTPS \n
    ExitPolicy accept *:991       # NAS Usenet \n
    ExitPolicy accept *:992       # TELNETS \n
    ExitPolicy accept *:993       # IMAPS \n
    ExitPolicy accept *:995       # POP3S \n
    ExitPolicy accept *:1194      # OpenVPN \n
    ExitPolicy accept *:1293      # IPSec \n
    ExitPolicy accept *:3690      # SVN Subversion \n
    ExitPolicy accept *:4321      # RWHOIS \n
    ExitPolicy accept *:5222-5223 # XMPP, XMPP SSL \n
    ExitPolicy accept *:5228      # Android Market \n
    ExitPolicy accept *:9418      # git \n
    ExitPolicy accept *:11371     # OpenPGP hkp \n
    ExitPolicy accept *:64738     # Mumble \n
    ExitPolicy reject *:* \n


    $ADDITIONAL_VARIABLES
    " > /etc/tor/torrc
fi

if [[ "$TYPE" == "exit" ]]
then
    printf "\n
    RunAsDaemon 0 \n
    SocksPort 0 \n
    DataDirectory /var/lib/tor \n
    Nickname ${NICK} \n
    ContactInfo ${EMAIL} \n
    ORPort ${OR_PORT} \n
    DirPort ${DIR_PORT} \n
    MyFamily ${FAMILY} \n
    ExtORPort auto \n
    Log notice file /var/log/tor/log \n
    Log notice stdout \n
    ExitRelay 1 \n
    ExitPolicy accept *:* \n

    $ADDITIONAL_VARIABLES
    " > /etc/tor/torrc
fi

echo "Starting tor."
tor -f /etc/tor/torrc
