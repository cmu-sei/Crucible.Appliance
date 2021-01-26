## 0.0.5

- Updated to the latest versions of Crucible applications.
- Added hotkeys settings to caster-ui.
- Removed `vm-console` folder. `vm-console` is now part of the `vm` stack.
- Fixed a bug in steamfitter where the custom vsphere packs were not installed.
- Updated player stack to include configurations and volumes for the file upload feature.
- Added `UserFollowUrl` setting to the vm-ui

## 0.0.4

- Updated son to handle `.conf` files.
- Fixed a bug in Identity where the admin@${DOMAIN} account was not respecting the ADMIN_PASS variable.
- Removed S3 from player-api binary

## 0.0.3

### Steamfitter bug fixes

- Various steamfitter and stackstorm deployment bugs are fixed.

### Example Data / Seed Data

Player - Two views are created, one for a standard view and one for an alloy view.

Alloy - One event connected to a Player View, Caster Directory, and Steamfitter Scenario.

Caster - One Project that deploys a single Ubuntu VM and Distributed Portgroup.

- Requirements:
  1. vSphere server with a datacenter, cluster and distributed virtual switch.
  2. Ubuntu Template or VM with a snapshot taken.
- Within caster make sure to customize `variables.auto.tfvars` file with your environment information.

Steamfitter - One scenario template with 4 simple tasks configured.

### VSPHERE_CLUSTER and STACK_CLUSTER_MOID variables added to the `env` file

- Steamfitter api requires the vSphere cluster MOID as a parameter.
- `configure.sh` attempts to get this value based on the VSPHERE_CLUSTER `env` variable. the script will automatically set the `STACK_CLUSTER_MOID`

### PowerShell and PowerCLI added

- Automatic configuration of PowerShell Core and vSphere PowerCLI added to `prep.sh` script.

### Logging stack added

- A logging stack is now available with elastic search, kibana, and filebeat.
- Sparse and minimally configured

## 0.0.2

### `son` and `soff` implemented

- `son` substitutes environment variables set in `env` file for application configuration `e.g. alloy-settings-api.json`
- `configure.sh` script now uses `son` and `soff` to deploy applications
- `son` and `soff` supports all applications when no arguments are given and multiple applications when specified `e.g. son alloy caster`

### vCenter certs trusted

- vcenter certs are now trusted by the applications based on `VCENTER_SERVER` environment variable
- Application configurations now respect the `VCENTER_SERVER` environment variable

### Multiple Terraform versions are supported

- Added env variable under the `[caster]` section `TERRAFORM_VERSIONS` to specify a comma delimited list of terraform versions to be installed
- Added env variable under the `[caster]` section `TERRAFORM_DEFAULT` to specify the default terraform version caster should use.

### ISO datastore variable

- Added env variable under the `[vm]` section `VM_ISO_DATASTORE` to specify which vSphere datastore the vm appliance will use for isos

### Improve pulling docker images

- Images not used in the stack are no longer pulled.

### Gitlab

- admin@\${DOMAIN} is now connected to the root user login with the foundry OAUTH
- Caster modules are imported into GitLab.
- Caster specific variables are updated in the `env` file

### Misc.

- Postgres server port is now exposed for easier debugging of data

## 0.0.1 Initial Release

- Deploys the appliance through bash configuration scripts.
