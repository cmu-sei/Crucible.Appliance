# Crucible Appliance

A set of scripts to configure a Crucible appliance.

## Overview

This application stack consists of a single node docker swarm utilizing a traefik reverse proxy

They are assembled using docker-compose files on an Ubuntu 20.04 operating system.

Release notes and further documentation can be found at https://github.com/cmu-sei/crucible/wiki

## Quick Start

1. Create an Ubuntu 20.04 VM, the scripts should work with a default install.

- 30GB+ HD
- 4 Processors
- 6GB RAM

1. Clone this repository `git clone https://github.com/cmu-sei/Crucible.Appliance.git /deploy`

1. Navigate to `cd /deploy`
1. `vim env` and set the variables based on the comments. pay close attention to the `ID_SERVER` and `SWARM_SERVER` values these need to match the `DOMAIN`

1. run `sudo /deploy/docs/appliance/scripts/prep.sh` This will install the binaries needed for the appliance including docker. `prep.sh` can take a while since it pulls any docker images the appliance needs.
1. run `newgrp docker` to make sure you have permissions to run docker commands.
1. Doublecheck the `env` file has the values you want. and run `sudo /deploy/docs/appliance/scripts/configure.sh`
1. After the configure script finishes, it's takes about ~5 minutes for all the applications to be ready
1. To seed the databases with sample data run `sudo /deploy/docs/appliance/scripts/crucible-seed.sh` Be carful running this file as it drops the databases and re-creates them resetting the data in alloy, caster, player, steamfitter, vm, and vm-console

## DNS

This appliance uses a traefik reverse proxy so hostnames must be used when accessing the appliance applications. it's generally better to have a DNS server that you can place a wildcard entry for `*.crucible.io` (DOMAIN in env file). However, a script is provided to generate a hosts entry that you can place into `/etc/hosts`

1. run `/deploy/docs/appliance/scripts/generate-hosts.sh`

The script generates a command to run on your local workstation

## Certificate

By default, the appliance generates a local certificate authority and issues a certificate for all the applications.

From your workstation, it may be convenient to install your Root CA cert from `https://*.crucible.io` this can be found in the local nfs server at `/mnt/data/certificates/sei-ca` or by this url `http://[IP-ADDRESS]:8000/appliance-ca.crt`

If providing a certificate by some other means, be sure to coordinate its location with the traefik stack `/deploy/traefik/traefik-stack-ssl.yml`

For other certificates the applications need to trust, drop them in `/mnt/data/certificates/sei-ca`.

## Identity Configuration

The identity server is configured with default settings. Look through the `/deploy/docs/appliance/compose/identity/identity.conf` file to edit them.

A default admin account is configured there: `admin@<DOMAIN>` and `<ADMIN_PASS>` (default '321ChangeMe!'). Use that username and password to login and set up other accounts, or see below to reset the database.

More information for Identity server might exist at https://github.com/cmu-sei/Identity.

## Reset Appliance

Sometimes it may be necessary to reset the appliance, perhaps to change the domain name or the Admin password. At this time the appliance is limited to a full reset, cherry picking data to save is not possible.

#### _*this will delete all data, certificates, everything! You've been WARNED*_

Run `/deploy/docs/appliance/scripts/reset.sh`

## Default Appliance Info

**Credentials**

| Application   | Username          | Password     | Notes                                                                                     |
| ------------- | ----------------- | ------------ | ----------------------------------------------------------------------------------------- |
| Crucible Apps | admin@crucible.io | 321ChangeMe! |                                                                                           |
| Gitlab        | root              | 321ChangeMe! | Also connected to the identity server, click the `foundry` button under the login section |

**URLS**

Replace `crucible.io` with the `<DOMAIN>` environment Url if changed.

| Application     | URL                            |
| --------------- | ------------------------------ |
| Alloy           | alloy.crucible.io              |
| Alloy API       | alloy-api.crucible.io/swagger  |
| Caster          | caster.crucible.io             |
| Caster API      | caster-api.crucible.io/api     |
| Identity        | id.crucible.io                 |
| Identity API    | id.crucible.io/api             |
| Player          | player.crucible.io             |
| Player API      | player-api.crucible.io/swagger |
| Steamfitter     | steamfitter.crucible.io        |
| Steamfitter API | steamfitter-api.crucible.io    |
| VM              | vm.crucible.io                 |
| VM API          | vm-api.crucible.io/swagger     |
| VM Console      | vm-console.crucible.io         |

## Usage

### `env` file and environment variables.

it's possible to override any variable within the `env` file with standard Linux environment variables. Linux environment variables will take precedent. This is untested.

### `/deploy` folder

This directory needs to be kept. all scripts are based on this directory. While it's possible to override the directory with the `$DEPLOY` environment variable it's best to leave it. This is untested.

### `son` & `soff` - Stack On / Stack Off

are shell application placed in `/usr/local/bin` they aim to assist in the deployment and removal of crucible applications. This is useful when you need to modify settings of individual crucible applications. such as the various api-settings or ui-settings.

`son` & `soff` are non-destructive. No changes will be made to your data.

| commad             | notes                         |
| ------------------ | ----------------------------- |
| son                | Deploy all applications       |
| son player         | Deploy only player            |
| son player caster  | deploy only player and caster |
| soff               | Remove all application        |
| soff player        | Remove only player            |
| soff player caster | Remove only player and caster |

#### **IMPORTANT**

`son` & `soff` search the `/deploy` directory for folders of applications to deploy, due to the differences in our various environments it's important to note that on the appliance root level settings folders are overridden by folders in `/deploy/docs/appliance/compose` if you find your settings are not being applied check if a folder exists under this directory and modify your settings there.

## FAQ

**I Immediately get errors when accessing an application**  
_Make sure you download the appliance certificate the default location of this file is `http://[IP-ADDRESS]:8000/appliance-ca.crt`_

**Application is blank in player<br>**
_some applications such as vm and vm-console are set to `Require Consent` on the identity server, open the application in a new tab to get the consent page_

**I can't access a vm console<br>**
_The default vCenter Self-Signed certificates have an expiry that is too long for modern browsers. you will need to go to the individual esxi servers and accept those certificates._

**How do I use this module in caster<br>**
_Modules are well documented in GitLab READMEs Visit the GitLab repository for more in-depth instructions_
