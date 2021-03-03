# Crucible Appliance

The following describes the set of scripts needed to configure a Crucible appliance. This application stack consists of a single-node Docker swarm utilizing a Traefik reverse proxy. They are assembled using Docker Compose files on an Ubuntu 20.04 operating system.

## Quick Start

1. Create an Ubuntu 20.04 VM. The scripts should work with a default install.
   - 30GB+ HD
   - 4 processors
   - 6GB RAM
2. Clone this repository:
`sudo git clone https://github.com/cmu-sei/Crucible.Appliance.git /deploy`
3. Navigate to:  `cd /deploy`.
4. `vim env` and set the variables based upon the comments. Pay close attention to the `ID_SERVER` and `SWARM_SERVER` values; these need to match the `DOMAIN`.
5. Run `sudo /deploy/docs/appliance/scripts/prep.sh`. This will install the binaries needed for the appliance, including Docker. `prep.sh` can take some time because it pulls any Docker images the appliance needs.
6. Run `newgrp docker` to verify that  you have permissions to run Docker commands.
7. Verify that the `env` file has the values you want and run:
`sudo /deploy/docs/appliance/scripts/configure.sh`
8. After the configure script finishes, it takes about five minutes for all the applications to be ready.
9. To seed the databases with sample data, run:
`sudo /deploy/docs/appliance/scripts/crucible-seed.sh` 
>**Caution!** Be careful running this file as it drops the databases and re-creates them; resetting the data in Alloy, Caster, Player, Steamfitter, VM, and VM-console.

## DNS

This appliance uses a Traefik reverse proxy so hostnames must be used when accessing the appliance applications. It's generally better to have a DNS server that you can place a wildcard entry for: `*.crucible.io` (DOMAIN in env file). However, a script is provided to generate a hosts entry that you can place into `/etc/hosts`.

Run `/deploy/docs/appliance/scripts/generate-hosts.sh`.

The script generates a command to run on your local workstation.

## Certificate

By default, the appliance generates a local certificate authority and issues a certificate for all the applications.

From your workstation, it may be convenient to install your Root CA cert from `https://*.crucible.io`. This can be found in the local nfs server at:

`/mnt/data/certificates/sei-ca` or by this URL: `http://[IP-ADDRESS]:8000/appliance-ca.crt`

If providing a certificate by some other means, be sure to coordinate its location with the Traefik stack: `/deploy/traefik/traefik-stack-ssl.yml`

For other certificates the applications need to trust, drop them in `/mnt/data/certificates/sei-ca`.

## Identity Configuration

The identity server is configured with default settings. Look through the `/deploy/docs/appliance/compose/identity/identity.conf` file to edit them.

A default administrator account is configured there: `admin@<DOMAIN>` | `<ADMIN_PASS>` (default '321ChangeMe!'). 

Use that username and password to login and set up other accounts, or see below to reset the database.

For more information on Identity server, see the [Identity Server Readme file](https://github.com/cmu-sei/Identity/blob/master/Readme.md). 

## Resetting the Appliance

Sometimes it may be necessary to reset the appliance, perhaps to change the domain name or the admin password. At this time, the appliance is limited to a *full* reset, selecting specific data to save is not possible.

> **Warning!** Resetting the appliance deletes *everything*: all data and all certificates.

To reset the appliance, run: `/deploy/docs/appliance/scripts/reset.sh`.

## Default Appliance Information

### **Credentials**

---

| Application   | Username                                                     | Password     | Notes                                                        |
| ------------- | ------------------------------------------------------------ | ------------ | ------------------------------------------------------------ |
| Crucible apps | [admin@crucible.io](https://github.com/cmu-sei/Identity/blob/master/Readme.md) | 321ChangeMe! | ADMIN_PASS                                                   |
| GitLab        | root                                                         | 321ChangeMe! | Also connected to the identity server; click the `foundry` button under the login section |
| StackStorm    | st2admin                                                     | 321ChangeMe! | ADMIN_PASS                                                   |
| Portainer     | admin                                                        | 321ChangeMe! | ADMIN_PASS                                                   |

### **URLs**

---

Replace `crucible.io` with the `<DOMAIN>` environment URL if changed.

| Application     | URL                                                                                |
| --------------- | ---------------------------------------------------------------------------------- |
| Alloy           | [alloy.crucible.io](https://alloy.crucible.io)                                     |
| Alloy API       | [alloy-api.crucible.io/swagger](https://alloy-api.crucible.io/swagger)             |
| Caster          | [caster.crucible.io](https://caster.crucible.io)                                   |
| Caster API      | [caster-api.crucible.io/api](https://caster-api.crucible.io/api)                   |
| Identity        | [id.crucible.io](https://id.crucible.io)                                           |
| Identity API    | [id.crucible.io/api](https://id.crucible.io/api)                                   |
| Player          | [player.crucible.io](https://player.crucible.io)                                   |
| Player API      | [player-api.crucible.io/swagger](https://player-api.crucible.io/swagger)           |
| Steamfitter     | [steamfitter.crucible.io](https://steamfitter.crucible.io)                         |
| Steamfitter API | [steamfitter-api.crucible.io/swagger](https://steamfitter-api.crucible.io/swagger) |
| VM              | [vm.crucible.io](https://vm.crucible.io)                                           |
| VM API          | [vm-api.crucible.io/swagger](https://vm-api.crucible.io/swagger)                   |
| VM Console      | [vm-console.crucible.io](https://vm-console.crucible.io)                           |

### **3rd Party URLs**

---

| 3rd Party Applications | URL                                                      |
| ---------------------- | -------------------------------------------------------- |
| GitLab                 | [gitlab.crucible.io](https://gitlab.crucible.io)         |
| Portainer              | [swarm.crucible.io](https://swarm.crucible.io)           |
| StackStorm             | [stackstorm.crucible.io](https://stackstorm.crucible.io) |
| Kibana                 | [kibana.crucible.io](https://kibana.crucible.io)         |

## Usage

### `env` file and environment variables

It's possible to override any variable within the `env` file with standard Linux environment variables. Linux environment variables will take precedent. 

>**Note:** This is untested.

### `/deploy` folder

This directory needs to be kept. All scripts are based on this directory. While it is possible to override the directory with the `$DEPLOY` environment variable it is best to leave it.

>**Note:** This is untested.

### `son` and `soff`-- Stack On / Stack Off

`son` and `soff`are shell applications placed in `/usr/local/bin`. They are there to assist in the deployment and removal of Crucible applications. This is useful for when you need to modify settings of individual Crucible applications such as the various api-settings or ui-settings.

`son` & `soff` are non-destructive. No changes will be made to your data.

| command            | notes                         |
| ------------------ | ----------------------------- |
| son                | Deploy all applications       |
| son player         | Deploy only Player            |
| son player caster  | Deploy only Player and Caster |
| soff               | Remove all applications       |
| soff player        | Remove only Player            |
| soff player caster | Remove only Player and Caster |

#### **Important**

`son` & `soff` search the `/deploy` directory for folders of applications to deploy. Due to the differences in our various environments, it is important to note: 

On the appliance root level settings, folders are overridden by folders in `/deploy/docs/appliance/compose`. 

If you find that your settings are not being applied check if a folder exists under this directory and modify your settings there.

## Example / Seed Data

Crucible can optionally be seeded with example data. Run: `/deploy/docs/appliance/scripts/crucible-seed.sh`

>**Warning:** Doing so will reset the data in the appliance.

- **Player:** Two views are created, one for a standard view and one for an Alloy view.
- **Alloy:** One event connected to a Player View, Caster Directory, and Steamfitter Scenario.
- **Caster:** One Project that deploys a single Ubuntu VM and Distributed Portgroup.
   - Requirements:
      1. vSphere server with a datacenter, cluster, and Distributed Virtual Switch.
      2. Ubuntu Template or VM with a snapshot taken.
   - Within Caster make sure to customize `variables.auto.tfvars` file with your environment information.
- **Steamfitter:** One scenario template with four simple tasks configured.

## Troubleshooting and FAQ

#### I immediately get errors when accessing an application.  

Make sure you download the appliance certificate. The default location of this file is:

 `http://[IP-ADDRESS]:8000/appliance-ca.crt`

#### Application is blank in Player.
Some applications such as VM and VM-console are set to `Require Consent` on the Identity server; open the application in a new tab to get the consent page.

#### I can't access a VM console.

The default vCenter Self-Signed certificates have an expiry that is too long for modern browsers. Go to the individual Esxi servers and accept those certificates.

#### How do I use this module in Caster?

Modules are well-documented in GitLab READMEs. Visit the GitLab repository for more in-depth instructions.

#### Crucible Documentation 

Crucible help documentation can be found [here](https://cmu-sei.github.io/crucible/). Release notes and Readme files for individual apps in the Crucible stack can be found in their respective GitHub repositories. 

#### Traefik Labs Documentation

Traefik Labs documentation, guides, configurations, and references can be found [here](https://doc.traefik.io/).

## Reporting bugs and requesting features

Think you found a bug? Please report all Crucible bugs - including bugs for the individual Crucible apps - in the [cmu-sei/crucible issue tracker](https://github.com/cmu-sei/crucible/issues). 

Include as much detail as possible including steps to reproduce, specific app involved, and any error messages you may have received.

Have a good idea for a new feature? Submit all new feature requests through the [cmu-sei/crucible issue tracker](https://github.com/cmu-sei/crucible/issues). 

Include the reasons why you're requesting the new feature and how it might benefit other Crucible users.

## License

Copyright 2021 Carnegie Mellon University. See the [LICENSE.md](https://github.com/cmu-sei/crucible/blob/master/license.md) file for details.
