#!/bin/bash

echo "Disabling intex repository"
ssu dr customer-intex

if [ ! -f /usr/share/ssu/features.d/customer-jolla.ini ]; then
echo "Injecting jolla repository"
cat >/usr/share/ssu/features.d/customer-jolla.ini <<EOL
[customer-jolla]
repos = customer-jolla
packages = feature-jolla
description = Jolla specific content
version = 0.0.6-10.4.10.jolla
name = Jolla
[repositories]
[repositories-release]
customer-jolla = %(releaseProtocol)://%(secureDomain)/features/%(release)/customers/jolla/%(arch)/
[repositories-rnd]
customer-jolla = %(rndProtocol)://%(rndDomain)/pj:/features:/customers:/jolla%(update-version:+:/%(update-version))%(flavourPattern)/%(release)_%(arch)/
EOL
ssu ur
fi

if which zypper > /dev/null 2>&1
then
  echo "Found installed zypper"
else
# Make sure we have up to date repos, otherwise some dependencies might not be found
  echo "Refreshing package lists to make sure zypper is installable"
  pkcon refresh
  echo "Installing zypper"
  pkcon -y install zypper || exit 1
fi

echo "Stopping pkackagekit"
killall packagekitd

echo "Refreshing repositories"
zypper ref

echo "Installing jolla packages"

echo "----- IMPORTANT -----"
echo " if you asked to choose 1/2/3 or similar:"
echo " type 1 and ENTER"
echo " if you asked to choose y/n/c or similar:"
echo " type y and ENTER"
echo "----- IMPORTANT -----"
echo ""
zypper in \
    feature-jolla \
    sailfish-content-configuration-jolla \
    sailfish-content-graphics-jolla-z1.25 \
    sailfish-content-apps-default-configs \
    sailfish-content-ambiences-default \
    sailfish-content-profiled-settings-default || exit 2

echo "Removing intex packages"

echo "----- IMPORTANT -----"
echo " if you asked to choose 1/2/3 or similar:"
echo " type 1 and ENTER"
echo " if you asked to choose y/n/c or similar:"
echo " type y and ENTER"
echo "----- IMPORTANT -----"
echo ""
rm /etc/zypp/systemCheck.d/feature-intex.check || true
zypper rm \
    feature-intex \
    sailfish-content-configuration-intex \
    sailfish-content-apps-intex-configs \
    sailfish-content-ambiences-intex \
    sailfish-content-partnerspaces-intex \
    sailfish-content-browser-intex \
    sailfish-content-profiled-settings-intex \
    all-translations-intex-pack \
    sms-activation-intex \
    sailfish-content-graphics-intex \
    sailfish-content-partnerspaces-intex-tutorial \
    sms-activation-intex-conf \
    sailfish-content-ambiences-intex-default-ambience \
    sailfish-content-tones-intex \
    sailfish-content-gallery-configuration-intex \
    sailfish-content-partnerspaces-intex-gaana \
    sailfish-content-graphics-intex-z1.25 \
    splash-img-l500d-intex

echo "Restarting ambience service"
systemctl-user restart ambienced

echo "Refreshing package lists"
pkcon refresh

echo "Telling system we're Jolla C now"
# This is indeed necessary even if the file already exists
touch /usr/share/ssu/board-mappings.d/10-l500d-jolla.ini

echo "Done!"
