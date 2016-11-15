#!/bin/bash

if [ ! -f /usr/share/ssu/features.d/customer-jolla.ini ]; then
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

ssu dr customer-intex
pkcon -y install zypper
killall packagekitd
zypper ref

echo "----- IMPORTANT -----"
echo "- type 1 and ENTER --"
echo "- then y and ENTER --"
echo "- to next questions -"
echo "----- IMPORTANT -----"
echo ""
zypper in feature-jolla sailfish-content-configuration-jolla sailfish-content-graphics-jolla-z1.25 sailfish-content-apps-default-configs sailfish-content-ambiences-default

echo "----- IMPORTANT -----"
echo "- type y and ENTER --"
echo "- to next questions -"
echo "----- IMPORTANT -----"
echo ""
zypper rm feature-intex sailfish-content-configuration-intex sailfish-content-apps-intex-configs sailfish-content-ambiences-intex sailfish-content-partnerspaces-intex sailfish-content-browser-intex sailfish-content-profiled-settings-intex all-translations-intex-pack sms-activation-intex sailfish-content-graphics-intex sailfish-content-partnerspaces-intex-tutorial sms-activation-intex-conf sailfish-content-ambiences-intex-default-ambience sailfish-content-tones-intex sailfish-content-gallery-configuration-intex sailfish-content-partnerspaces-intex-gaana sailfish-content-graphics-intex-z1.25 splash-img-l500d-intex

systemctl-user restart ambienced

touch /usr/share/ssu/board-mappings.d/10-l500d-jolla.ini
