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
