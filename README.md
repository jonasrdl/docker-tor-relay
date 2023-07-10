# docker-tor-relay

This repository contains the docker files for an Tor relay.

## Installation

`docker-compose build`

After that simply start the container:

`docker-compose up -d`

You can have a look at the logs with:

`docker-compose logs`

## Configuration

The following enviroment variables can be configured in the docker-compose.yml:

| Variable                          | Default Value    | Meaning                                                           |
|-----------------------------------|------------------|-------------------------------------------------------------------|
| OR_PORT                           | 1234             | Specifies the Tor port                                            |
| DIR_PORT                          | 1235             | Specifies the Tor directory port                                  |
| NICK                              | TorRelayDocker   | Specifies the Nickname of the relay                               |
| EMAIL                             | EMAIL@EMAIL.EMAIL| Specifies the contact email                                       |
| TYPE                              | middle           | Choose between `middle`, `reduced-exit`, `exit`                   |
| FAMILY                            |                  | Specify fingerprints for your other relays here. Separate with `,`|
| RELAY_ENABLE_ADDITIONAL_VARIABLES | 0                | Set it to 1 to specify more variables with `RELAY__` as prefix     |

## Updating your relay
Simply run `docker-compose build --no-cache`.
