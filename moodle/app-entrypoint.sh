#!/bin/bash -e
set -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

# set PHP error mode on
sed -i 's/display_errors = Off/display_errors = On/g' /opt/bitnami/php/lib/php.ini
sed -i 's/display_startup_errors = Off/display_startup_errors = On/g' /opt/bitnami/php/lib/php.ini
sed -i 's/;error_log = php_errors.log/error_log = php_errors.log/g' /opt/bitnami/php/lib/php.ini

# possibly first time intalling
if [ ! -d "/bitnami/moodle" ]; then
  mkdir -p /bitnami/moodle
  cp -r /opt/bitnami/moodle /bitnami
fi

# remove old files and link to the persistent dir
rm -rf /opt/bitnami/moodle
ln -s /bitnami/moodle /opt/bitnami/moodle

# use to sleep the script if work needs to get done first
#while [ ! -f /tmp/sleep.txt ]; do sleep 1m; done

# update permissions for moodledata
info "updating ownership of moodle directory"
chown -R daemon:daemon /opt/bitnami/moodle/
chown -R daemon:daemon /opt/bitnami/moodle/*

# update foundry theme
CURRENTPLUGIN=$(find /tmp -name "theme_foundry*" -printf "%f\n")
INSTALLEDVERSION="${CURRENTPLUGIN: -14:10}"
if [ ! -d /opt/bitnami/moodle/theme/foundry ]; then
  info "installing theme files"
  cd /opt/bitnami/moodle/theme
  mv /tmp/$CURRENTPLUGIN .
  unzip -oqq $CURRENTPLUGIN
  rm $CURRENTPLUGIN
  cd -
  chown -R daemon:daemon /opt/bitnami/moodle/theme/foundry/
else
  VERSIONLINE=$(grep "plugin->version" /opt/bitnami/moodle/theme/foundry/version.php)
  # Split the above line at the semicolon, to get the first half of the line, which ends in the version
  VERSIONLINE=$(echo $VERSIONLINE |  cut -d';' -f 1)
  # Take the substring, the last 10 characters of the line, that is just the version number
  OLDVERSION="${VERSIONLINE: -10:10}"
  if [[ $OLDVERSION -lt $INSTALLEDVERSION ]]; then
    info "updating theme files"
    rm -rf /opt/bitnami/moodle/theme/foundry/
    cd /opt/bitnami/moodle/theme
    mv /tmp/$CURRENTPLUGIN .
    unzip -oqq $CURRENTPLUGIN
    rm $CURRENTPLUGIN
    cd -
    chown -R daemon:daemon /opt/bitnami/moodle/theme/foundry/
  else
    info "Foundry theme plugin installed and up to date."
  fi
fi

# install foundrysync plugin
CURRENTPLUGIN=$(find /tmp -name "tool_foundrysync*" -printf "%f\n")
INSTALLEDVERSION="${CURRENTPLUGIN: -14:10}"
if [ ! -d /opt/bitnami/moodle/admin/tool/foundrysync ]; then
  info "installing foundrysync files"
  cd /opt/bitnami/moodle/admin/tool
  mv /tmp/$CURRENTPLUGIN .
  unzip -oqq $CURRENTPLUGIN
  rm $CURRENTPLUGIN
  cd -
  chown -R daemon:daemon /opt/bitnami/moodle/admin/tool/foundrysync/
else
  VERSIONLINE=$(grep "plugin->version" /opt/bitnami/moodle/admin/tool/foundrysync/version.php)
  # Split the above line at the semicolon, to get the first half of the line, which ends in the version
  VERSIONLINE=$(echo $VERSIONLINE |  cut -d';' -f 1)
  # Take the substring, the last 10 characters of the line, that is just the version number
  OLDVERSION="${VERSIONLINE: -10:10}"
  if [[ $OLDVERSION -lt $INSTALLEDVERSION ]]; then
    rm -rf /opt/bitnami/moodle/admin/tool/foundrysync/
    cd /opt/bitnami/moodle/admin/tool
    mv /tmp/$CURRENTPLUGIN .
    unzip -oqq $CURRENTPLUGIN
    rm $CURRENTPLUGIN
    cd -
    chown -R daemon:daemon /opt/bitnami/moodle/admin/tool/foundrysync/
  else
    info "Foundrysync plugin installed and up to date."
  fi
fi

# update groupquiz
CURRENTPLUGIN=$(find /tmp -name "mod_groupquiz*" -printf "%f\n")
INSTALLEDVERSION="${CURRENTPLUGIN: -14:10}"
if [ ! -d /opt/bitnami/moodle/mod/groupquiz ]; then
  info "installing groupquiz files"
  cd /opt/bitnami/moodle/mod
  mv /tmp/$CURRENTPLUGIN .
  unzip -oqq $CURRENTPLUGIN
  rm $CURRENTPLUGIN
  cd -
  chown -R daemon:daemon /opt/bitnami/moodle/mod/groupquiz/
else
  VERSIONLINE=$(grep "plugin->version" /opt/bitnami/moodle/mod/groupquiz/version.php)
  # Split the above line at the semicolon, to get the first half of the line, which ends in the version
  VERSIONLINE=$(echo $VERSIONLINE |  cut -d';' -f 1)
  # Take the substring, the last 10 characters of the line, that is just the version number
  OLDVERSION="${VERSIONLINE: -10:10}"
  if [[ $OLDVERSION -lt $INSTALLEDVERSION ]]; then
    info "updating groupquiz files"
    rm -rf /opt/bitnami/moodle/mod/groupquiz/
    cd /opt/bitnami/moodle/mod
    mv /tmp/$CURRENTPLUGIN .
    unzip -oqq $CURRENTPLUGIN
    rm $CURRENTPLUGIN
    cd -
    chown -R daemon:daemon /opt/bitnami/moodle/mod/groupquiz/
  else
    info "Groupquiz plugin installed and up to date."
  fi
fi

# update crucible
CURRENTPLUGIN=$(find /tmp -name "mod_crucible*" -printf "%f\n")
INSTALLEDVERSION="${CURRENTPLUGIN: -14:10}"
if [ ! -d /opt/bitnami/moodle/mod/crucible ]; then
  info "installing crucible files"
  cd /opt/bitnami/moodle/mod
  mv /tmp/$CURRENTPLUGIN .
  unzip -oqq $CURRENTPLUGIN
  rm $CURRENTPLUGIN
  cd -
  chown -R daemon:daemon /opt/bitnami/moodle/mod/crucible/
else
  VERSIONLINE=$(grep "plugin->version" /opt/bitnami/moodle/mod/crucible/version.php)
  # Split the above line at the semicolon, to get the first half of the line, which ends in the version
  VERSIONLINE=$(echo $VERSIONLINE |  cut -d';' -f 1)
  # Take the substring, the last 10 characters of the line, that is just the version number
  OLDVERSION="${VERSIONLINE: -10:10}"
  if [[ $OLDVERSION -lt $INSTALLEDVERSION ]]; then
    info "updating crucible files"
    rm -rf /opt/bitnami/moodle/mod/crucible/
    cd /opt/bitnami/moodle/mod
    mv /tmp/$CURRENTPLUGIN .
    unzip -oqq $CURRENTPLUGIN
    rm $CURRENTPLUGIN
    cd -
    chown -R daemon:daemon /opt/bitnami/moodle/mod/crucible/
  else
    info "Crucible plugin installed and up to date."
  fi
fi

if [ -d /tmp/steplms ]; then
  info "updating import/backup plugin files"
  cp -pr /tmp/steplms /opt/bitnami/moodle/backup/
  chown -R daemon:daemon /opt/bitnami/moodle/backup/
  rm -rf /tmp/steplms
fi

if [ -d /tmp/converter/steplms ]; then
  info "updating import/backup converter plugin files"
  cp -pr /tmp/converter/steplms /opt/bitnami/moodle/backup/converter/
  chown -R daemon:daemon /opt/bitnami/moodle/backup/converter/
  rm -rf /tmp/converter
fi

if [[ -z $(grep FORMAT_STEPLMS /opt/bitnami/moodle/backup/backup.class.php) ]]; then
  info "adding FORMAT_STEPLMS to backup class"
  sed -i "s/const FORMAT_UNKNOWN = 'unknown';/const FORMAT_UNKNOWN = 'unknown';\n    const FORMAT_STEPLMS = 'steplms';/" /opt/bitnami/moodle/backup/backup.class.php
fi

if [[ -z $(grep backupformatsteplms /opt/bitnami/moodle/lang/en/backup.php) ]]; then
  info "adding stepformlms to lang/en/backup"
  sed -i "s/'backupformatunknown'] = 'Unknown format';/'backupformatunknown'] = 'Unknown format';\n\$string['backupformatsteplms'] = 'STEPlms';/" /opt/bitnami/moodle/lang/en/backup.php
fi


# install h5p plugin
CURRENTPLUGIN=mod_hvp_moodle39_2020020500.zip
INSTALLEDVERSION="${CURRENTPLUGIN: -14:10}"
if [ ! -d /opt/bitnami/moodle/mod/hvp ]; then
  info "installing hvp"
  cd /opt/bitnami/moodle/mod/
  mv /tmp/$CURRENTPLUGIN .
  unzip -oqq $CURRENTPLUGIN
  rm $CURRENTPLUGIN
  cd -
  chown -R daemon:daemon /opt/bitnami/moodle/mod/hvp/
else
  info "hvp already installed"
  # Grab version from the currently installed plugin
  VERSIONLINE=$(grep '$plugin->version' /opt/bitnami/moodle/mod/hvp/version.php)
  # Split the above line at the semicolon, to get the first half of the line, which ends in the version
  VERSIONLINE=$(echo $VERSIONLINE |  cut -d';' -f 1)
  # Take the substring, the last 10 characters of the line, that is just the version number
  VERSION="${VERSIONLINE: -10:10}"
  # Compare version number to the one that is installed in this base image, update if necessary
  if [[ $VERSION -lt $INSTALLEDVERSION ]]; then
    info "hvp version out of date, upgrading..."
    cd /opt/bitnami/moodle/mod/
    mv /tmp/$CURRENTPLUGIN .
    unzip -oqq $CURRENTPLUGIN
    rm $CURRENTPLUGIN
    cd -
    chown -R daemon:daemon /opt/bitnami/moodle/mod/hvp/
    info "Done."
  fi
fi

if [[ -d /opt/bitnami/moodle/mod/hvp ]]; then
  info "patching h5p for local module metadata support"
  sed -i "s/defaultvalues\['id'\]/defaultvalues\['instance'\]/g" /opt/bitnami/moodle/mod/hvp/mod_form.php

  if [[ -z $(grep hvp_get_coursemodule_info /opt/bitnami/moodle/mod/hvp/lib.php) ]]; then
    info "appending hvp_get_coursemodule_info function to hvp/lib.php"
    cat <<'EOF'>> /opt/bitnami/moodle/mod/hvp/lib.php

function hvp_get_coursemodule_info($coursemodule) {
    global $DB;
    $defaulturl = null;

    $info = new cached_cm_info();

    $modtype = $DB->get_field_sql('SELECT main_library_id FROM {hvp} WHERE id = ?', array($coursemodule->instance));
    $result = $DB->get_record_sql('SELECT machine_name, major_version, minor_version FROM {hvp_libraries} WHERE id = ?', array($modtype));

    //http://cwd-moodle-1.cwd.local/moodle/pluginfile.php/1/mod_hvp/libraries/H5P.ImageHotspotQuestion-1.8/icon.svg
    //$fileurl = moodle_url::make_file_url('/pluginfile.php', '/'.$context->id.'/'.$fileoptions->component.'/'.$fileoptions->filearea.'/'.$fileoptions->filename);

    if ($result->has_icon) {
        $info->iconurl = moodle_url::make_file_url('/pluginfile.php', '/1/mod_hvp/libraries/'.$result->machine_name.'-'.$result->major_version.'.'.$result->minor_version.'/icon.svg');
    } else {
        $result2 = $DB->get_record_sql('SELECT has_icon, machine_name, major_version, minor_version FROM {hvp_libraries} WHERE has_icon = ? AND machine_name = ?', array('1', $result->machine_name));
        if ($result2) {
            $info->iconurl = moodle_url::make_file_url('/pluginfile.php', '/1/mod_hvp/libraries/'.$result2->machine_name.'-'.$result2->major_version.'.'.$result2->minor_version.'/icon.svg');
        }
    }

    if ($info->iconurl === null) {
            $info->iconurl = $defaulturl;
    }
    $info->name = $coursemodule->name;

    return $info;
}
EOF
  fi
fi

# copy files and configure logstore xapi if variables are set
CURRENTPLUGIN=logstore_xapi_moodle38_2020032801.zip
INSTALLEDVERSION="${CURRENTPLUGIN: -14:10}"
if [[ -f /tmp/$CURRENTPLUGIN ]] && [[ ! -d /opt/bitnami/moodle/admin/tool/log/store/xapi ]]; then
  info "installing logstore xapi"
  cd /opt/bitnami/moodle/admin/tool/log/store/
  mv /tmp/$CURRENTPLUGIN .
  unzip -oqq $CURRENTPLUGIN
  rm $CURRENTPLUGIN
  cd -
  chown -R daemon:daemon /opt/bitnami/moodle/admin/tool/log/store/xapi
else
  info "logstore xapi already installed"
  # Grab version from the currently installed plugin
  VERSIONLINE=$(grep '$plugin->version' /opt/bitnami/moodle/admin/tool/log/store/xapi/version.php)
  # Split the above line at the semicolon, to get the first half of the line, which ends in the version
  VERSIONLINE=$(echo $VERSIONLINE |  cut -d';' -f 1)
  # Take the substring, the last 10 characters of the line, that is just the version number
  VERSION="${VERSIONLINE: -10:10}"
  # Compare version number to the one that is installed in this base image, update if necessary
  if [[ $VERSION -lt $INSTALLEDVERSION ]]; then
    info "logstore xapi version out of date, upgrading..."
    cd /opt/bitnami/moodle/admin/tool/log/store/
    mv /tmp/$CURRENTPLUGIN .
    unzip -oqq $CURRENTPLUGIN
    rm $CURRENTPLUGIN
    cd -
    chown -R daemon:daemon /opt/bitnami/moodle/admin/tool/log/store/xapi
    info "Done."
  fi
fi

# install custom certificate plugin
CURRENTPLUGIN=mod_customcert_moodle38_2019111804.zip
INSTALLEDVERSION="${CURRENTPLUGIN: -14:10}"
if [[ -f /tmp/$CURRENTPLUGIN ]] && [[ ! -d /opt/bitnami/moodle/mod/customcert ]]; then
  info "installing custom certificate"
  cd /opt/bitnami/moodle/mod/
  mv /tmp/$CURRENTPLUGIN .
  unzip -oqq $CURRENTPLUGIN
  rm $CURRENTPLUGIN
  cd -
  chown -R daemon:daemon /opt/bitnami/moodle/mod/customcert
else
  info "custom certificate already installed"
  # Grab version from the currently installed plugin
  VERSIONLINE=$(grep '$plugin->version' /opt/bitnami/moodle/mod/customcert/version.php)
  # Split the above line at the semicolon, to get the first half of the line, which ends in the version
  VERSIONLINE=$(echo $VERSIONLINE |  cut -d';' -f 1)
  # Take the substring, the last 10 characters of the line, that is just the version number
  VERSION="${VERSIONLINE: -10:10}"
  # Compare version number to the one that is installed in this base image, update if necessary
  if [[ $VERSION -lt $INSTALLEDVERSION ]]; then
    info "custom certificate version out of date, upgrading..."
    cd /opt/bitnami/moodle/mod/
    mv /tmp/$CURRENTPLUGIN .
    unzip -oqq $CURRENTPLUGIN
    rm $CURRENTPLUGIN
    cd -
    chown -R daemon:daemon /opt/bitnami/moodle/mod/customcert/
    info "Done."
  fi
fi

# install course format board
if [[ -f /moodle-format_board ]] && [[ ! -d /opt/bitnami/moodle/course/format/board ]]; then
  info "installing board course format"
  rm -rf /moodle-format_board/.git
  mv /moodle-format_board/ /opt/bitnami/moodle/course/format/board/
  chown -R daemon:daemon /opt/bitnami/moodle/course/format/board/
fi
if [[ -d /opt/bitnami/moodle/course/format/board ]] && [[ -z $(grep format_board_inplace_editable /opt/bitnami/moodle/course/format/board/lib.php) ]]; then
  info  "updating course format board inplace_editable"
  cp /opt/bitnami/moodle/course/format/board/lib.php /opt/bitnami/moodle/course/format/board/lib.php-orig
  cat <<'EOF'>>/opt/bitnami/moodle/course/format/board/lib.php
/**
 * Implements callback inplace_editable() allowing to edit values in-place
 *
 * @param string $itemtype
 * @param int $itemid
 * @param mixed $newvalue
 * @return \core\output\inplace_editable
 */
function format_board_inplace_editable($itemtype, $itemid, $newvalue) {
    global $DB, $CFG;
    require_once($CFG->dirroot . '/course/lib.php');
    if ($itemtype === 'sectionname' || $itemtype === 'sectionnamenl') {
        $section = $DB->get_record_sql(
            'SELECT s.* FROM {course_sections} s JOIN {course} c ON s.course = c.id WHERE s.id = ? AND c.format = ?',
            array($itemid, 'board'), MUST_EXIST);
        return course_get_format($section->course)->inplace_editable_update_section_name($section, $itemtype, $newvalue);
    }
}

EOF
  chown -R daemon:daemon /opt/bitnami/moodle/course/format/board/lib.php
fi


if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
  . /apache-init.sh
  . /moodle-init.sh
  nami_initialize apache php mysql-client moodle
fi


# increase upload limit
if [[ -n $(grep 40M /opt/bitnami/php/conf/php.ini) ]]; then
  info "increasing upload limit to 500M"
  sed -i "s/40M/500M/" /opt/bitnami/php/conf/php.ini
fi
info "updating php.ini with opcache settings desired by moodle"
sed -i "s/;opcache.use_cwd=1/opcache.use_cwd=1/" /opt/bitnami/php/etc/php.ini
sed -i "s/;opcache.validate_timestamps=1/opcache.validate_timestamps=1/" /opt/bitnami/php/etc/php.ini
sed -i "s/;opcache.save_comments=1/opcache.save_comments=1/" /opt/bitnami/php/etc/php.ini
sed -i "s/;opcache.enable_file_override=0/opcache.enable_file_override=0/" /opt/bitnami/php/etc/php.ini

# set the proxy settings
if [[ ! -z "$PROXYHOST" && ! -z "$PROXYPORT" && ! -z "$PROXYBYPASS" ]]; then
  info "updating moodle proxy settings"
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=proxyhost --set=$PROXYHOST
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=proxyport --set=$PROXYPORT
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=proxybypass --set="$PROXYBYPASS"
fi

# copy files and configure xapi for hvp if variables are set
if [[ -d /tmp/js ]] && [[ ! -z $LRS_ENDPOINT ]] && [[ ! -z $LRS_USER ]] && [[ ! -z $LRS_SECRET ]]; then
  info "lrs set, copying js files to hvp"
  cp -pr /tmp/js/ /opt/bitnami/moodle/mod/hvp/
  chown -R daemon:daemon /opt/bitnami/moodle/mod/hvp/js/
  rm -rf /tmp/js/
  info "updating hvp xapi credentials"
  sed -i "s#LRS_ENDPOINT#$LRS_ENDPOINT#" /opt/bitnami/moodle/mod/hvp/js/xapi-stmt-dispatcher.js
  sed -i "s#LRS_USER#$LRS_USER#" /opt/bitnami/moodle/mod/hvp/js/xapi-stmt-dispatcher.js
  sed -i "s#LRS_SECRET#$LRS_SECRET#" /opt/bitnami/moodle/mod/hvp/js/xapi-stmt-dispatcher.js
  info "inserting xapi wrapper into html body"
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=additionalhtmltopofbody --set='<script type="text/javascript" src="/mod/hvp/js/xapiwrapper.min.js"></script><script type="text/javascript" src="/lib/jquery/jquery-'$JQUERY_VERSION'.js"></script><script type="text/javascript" src="/mod/hvp/js/xapi-stmt-dispatcher.js"></script>'
elif [ -d /opt/bitnami/moodle/mod/hvp/js/ ]; then
  info "lrs not set, removing js files from hvp"
  rm -rf /opt/bitnami/moodle/mod/hvp/js/
  info "lrs not set, removing xapi wrapper from body"
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=additionalhtmltopofbody --unset
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=mod_hvp --name=enable_lrs_content_types --set=1
fi


info "updating ownership of moodle directory"
chown -R daemon:daemon /opt/bitnami/moodle/

# upgrade the moodle database to install plugins before attempting to configure them
info "upgrading the moodle database"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/upgrade.php --non-interactive
info "upgrade script returned"

# update logstore xapi settings
if [[ -d /opt/bitnami/moodle/admin/tool/log/store/xapi ]] && [[ ! -z $LRS_ENDPOINT ]] && [[ ! -z $LRS_USER ]] && [[ ! -z $LRS_SECRET ]]; then
  info "updating settings for logstore xapi plugin"
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=logstore_xapi --name=endpoint --set="$LRS_ENDPOINT"
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=logstore_xapi --name=password --set="$LRS_SECRET"
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=logstore_xapi --name=username --set="$LRS_USER"
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=logstore_xapi --name=send_username --set=1
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=logstore_xapi --name=sendidnumber --set=1
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=logstore_xapi --name=sendresponsechoices --set=1
  info "enabling logstore xapi"
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=tool_log --name=enabled_stores --set="logstore_standard,logstore_xapi"
fi

# set the theme
info "setting theme foundry"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=theme --set=foundry

# Query Moodle to see if any oauth2 providers are configured
read FOUNDRY_OAUTH_EXITCODE FOUNDRY_OAUTH < <(echo $(sudo -u daemon php /opt/bitnami/moodle/admin/tool/foundrysync/cli/manage.php --list --json | jq -r '.success, (.data | length)'))

if [ "$FOUNDRY_OAUTH_EXITCODE" != "true" ]; then
  info "Failed to obtain list of OAuth2 providers from Moodle, exiting..."
  exit 1
fi

# if FOUNDRY_OAUTH is not set, allow local login and disable foundry redirect
if [ $FOUNDRY_OAUTH -eq 0 ]; then
  info "OAuth2 Provider not found..."
  if  [[ ! -z $IDENTITY_URL ]] && [[ ! -z $IDENTITY_CLIENTID ]] && [[ ! -z $IDENTITY_CLIENTSECRET ]] && [[ ! -z $IDENTITY_LOGINSCOPES ]] && \
      [[ ! -z $IDENTITY_LOGINSCOPESOFFLINE ]] && [[ ! -z $IDENTITY_NAME ]] && [[ ! -z $IDENTITY_SHOWONLOGINPAGE ]] && [[ ! -z $IDENTITY_IMAGE ]] && \
      [[ ! -z $IDENTITY_REQUIRECONFIRMATION ]]; then
    info "OAuth2 Provider environment variables set, configuring..."
    read NEW_ISSUER_EXITCODE NEW_ISSUER_ID < <(echo $(sudo -u daemon php /opt/bitnami/moodle/admin/tool/foundrysync/cli/manage.php \
      --baseurl="$IDENTITY_URL" \
      --clientid="$IDENTITY_CLIENTID" \
      --clientsecret="$IDENTITY_CLIENTSECRET" \
      --loginscopes="$IDENTITY_LOGINSCOPES" \
      --loginscopesoffline="$IDENTITY_LOGINSCOPESOFFLINE" \
      --name="$IDENTITY_NAME" \
      --showonloginpage="$IDENTITY_SHOWONLOGINPAGE" \
      --image="$IDENTITY_IMAGE" \
      --requireconfirmation="$IDENTITY_REQUIRECONFIRMATION" \
      --json | jq '.success, (.data | .id)'))

    if [ "$NEW_ISSUER_EXITCODE" != "true" ]; then
      info "Failed to create new OAuth2 issuer, exiting..."
      exit 1
    fi

    info "OAuth2 Provider configured."
    info "Setting theme_foundry id to newly created issuer..."
    sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=theme_foundry --name=issuerid --set="$NEW_ISSUER_ID"
    info "Done."
  else
    info "No OAuth2 environment variables set, turning on local login..."
    info "Disabling foundryredirect:  --component=theme_foundry --name=foundryredirect --set=0..."
    sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=theme_foundry --name=foundryredirect --set=0
    info "Done."
    info "Enabling canloginlocal:  --component=theme_foundry --name=canloginlocal --set=1..."
    sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=theme_foundry --name=canloginlocal --set=1
    info "Done."
  fi
else
  info "OAuth2 Provider found, checking to see if an issuerid is set..."
  ISSUER_ID_ISSET=$(sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=theme_foundry --json | jq -r '.issuerid')
  if [ "$ISSUER_ID_ISSET" == "null" ]; then
    info "OAuth2 Provider found, but issuerid is NOT set. Setting now..."
    ISSUER_ID_TOSET=$(sudo -u daemon php /opt/bitnami/moodle/admin/tool/foundrysync/cli/manage.php --list --json | jq -r '.data | .[] | .id')
    sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=theme_foundry --name=issuerid --set="$ISSUER_ID_TOSET"
    info "Done."
  else
    REQUIRECONFIRMATION=$(sudo -u daemon php /opt/bitnami/moodle/admin/tool/foundrysync/cli/manage.php --id=$ISSUER_ID_ISSET --list --json | jq -r '.data | .requireconfirmation')
    if [[ "$REQUIRECONFIRMATION" == "1" && "$IDENTITY_REQUIRECONFIRMATION" == "false" ]]; then
      info "An issuerid is set, so OAuth2 is configured properly.  However, Require Confirmation needs set again..."
      # Sometimes, this fails on the first try, so swallow error if so and try again
      sudo -u daemon php /opt/bitnami/moodle/admin/tool/foundrysync/cli/manage.php --id=$ISSUER_ID_ISSET --requireconfirmation="$IDENTITY_REQUIRECONFIRMATION" --json || true
      sudo -u daemon php /opt/bitnami/moodle/admin/tool/foundrysync/cli/manage.php --id=$ISSUER_ID_ISSET --requireconfirmation="$IDENTITY_REQUIRECONFIRMATION" --json
      info "Done."
    else
      info "An issuerid is set, so OAuth2 is configured properly.  Continuing..."
    fi
  fi
fi

# disable confirmation for user email changes
info "disabling confirmation for user email changes"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=emailchangeconfirmation --set=0

# set timezone
info "setting timezone"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=timezone --set=America/New_York

# set country
info "setting country"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=country --set=US

# force login to view site
info "setting force login"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=forcelogin --set=1

# force login to view profile images
info "setting force login profile images"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=forceloginforprofileimage --set=1

# remove guest login button
info "removing guest login button"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=guestloginbutton --set=0

# disable guest enrolment
info "disabling guest enrolment"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=enrol_plugins_enabled --set="manual,self,cohort"

# removing language menu
info "removing language menu"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=langmenu --set=0

# enrolment setting
info "updating self enrolment settings"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=enrol_self --name=sendcoursewelcomemessage --set=0

# update oauth
info "enabling oauth2"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=auth --set=oauth2

# update default user field mappings
# note that this updates the microsoft mappings as well... that may not be good down the road
if [[ -z $(grep idnumber /opt/bitnami/moodle/lib/classes/oauth2/api.php) ]]; then
    info "adding idnumber and username to default field mappings"
    sed -i "s/'locale'/'username' => 'username',\n            'sub' => 'idnumber',\n            'locale'/" /opt/bitnami/moodle/lib/classes/oauth2/api.php
fi

# create custom modedit page for 
if [[ ! -f /opt/bitnami/moodle/course/mymodedit.php ]]; then
    info "creating mymodedit.php"
    cp /opt/bitnami/moodle/course/modedit.php /opt/bitnami/moodle/course/mymodedit.php
    sed -i "s/admin/embedded/g" /opt/bitnami/moodle/course/mymodedit.php
    sed -i "s/modedit/mymodedit/g" /opt/bitnami/moodle/course/mymodedit.php
    chown daemon:daemon /opt/bitnami/moodle/course/mymodedit.php
fi

#info "update editor atto toolbar with etitle"
#sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=editor_atto --name=style1 --set="etitle,bold,italic"

if [[ ! -z $(sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=editor_atto --name=style1 | grep etitle) ]]; then
  info "removing etitle from editor_atto style1"
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=editor_atto --name=style1 --set="bold,italic"
fi

info "update system paths"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=pathtodu --set=/usr/bin/du
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=aspellpath --set=/usr/bin/aspell
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=pathtodot --set=/usr/bin/dot
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=pathtogs --set=/usr/bin/gs
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=extramemorylimit --set=1024M

if [[ ! -z $SMTP_HOSTS ]]; then
  info "updating smtp server address"
  sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=smtphosts --set="$SMTP_HOSTS"
fi

info "updating course default settings"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --component=moodlecourse --name=courseenddateenabled --set=0

info "set the PHP path"
sudo -u daemon php /opt/bitnami/moodle/admin/cli/cfg.php --name=pathtophp --set=/opt/bitnami/php/bin/php

# update permissions for moodle
info "updating ownership of moodle directory"
chown -R daemon:daemon /opt/bitnami/moodle/

info "updating crontab for root"
echo "* * * * * sudo -u daemon /opt/bitnami/php/bin/php /opt/bitnami/moodle/admin/cli/cron.php 2>/dev/null" > /var/spool/cron/crontabs/root

info "finally starting moodle"

exec tini -- "$@"
