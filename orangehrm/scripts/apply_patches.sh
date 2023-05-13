#!/bin/bash
set -ex

cd /var/www/orangehrm
sed -i 's/public const PRODUCT_MODE = self::MODE_PROD/public const PRODUCT_MODE = self::MODE_DEV/g' src/lib/config/Config.php

mv ${home_dir}/ConfigHelper.php src/lib/config/ConfigHelper.php
mv ${home_dir}/no_header.html.twig src/plugins/orangehrmCorePlugin/templates/no_header.html.twig
mv ${home_dir}/vue.html.twig src/plugins/orangehrmCorePlugin/templates/vue.html.twig

mkdir -p var/session var/log var/cache var/cryptoKey var/config
rm -rf src/cache lib