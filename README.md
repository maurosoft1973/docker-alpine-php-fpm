# PHP FPM Docker image running on Alpine Linux

[![Docker Automated build](https://img.shields.io/docker/automated/maurosoft1973/alpine-php-fpm.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-php-fpm/)
[![Docker Pulls](https://img.shields.io/docker/pulls/maurosoft1973/alpine-php-fpm.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-php-fpm/)
[![Docker Stars](https://img.shields.io/docker/stars/maurosoft1973/alpine-php-fpm.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-php-fpm/)

[![Alpine Version](https://img.shields.io/badge/Alpine%20version-v3.15.4-green.svg?style=for-the-badge)](https://alpinelinux.org/)
[![PHP FPM Version](https://img.shields.io/docker/v/maurosoft1973/alpine-php-fpm?sort=semver&style=for-the-badge)](https://www.php.net)

This Docker image [(maurosoft1973/alpine-php-fpm)](https://hub.docker.com/r/maurosoft1973/alpine-php-fpm/) is based on the minimal [Alpine Linux](https://alpinelinux.org/) with [PHP Version v7.4.29-r0](https://www.php.net).

##### Alpine Version 3.15.4 (Released Apr 04 2022)
##### PHP FPM Version 7.4.29-r0 (Released 2022-04-23 07:09:26)

----

## What is FPM?
FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation with some additional features (mostly) useful for heavy-loaded sites.

These features include:
* advanced process management with graceful stop/start;
* ability to start workers with different uid/gid/chroot/environment, listening on different ports and using different php.ini (replaces safe_mode);
* stdout and stderr logging;
* emergency restart in case of accidental opcode cache destruction;
* accelerated upload support;
* "slowlog" - logging scripts (not just their names, but their PHP backtraces too, using ptrace and similar things to read remote process' execute_data) that are executed unusually slow;
* fastcgi_finish_request() - special function to finish request and flush all data while continuing to do something time-consuming (video converting, stats processing etc.);
* dynamic/static child spawning;
* basic SAPI status info (similar to Apache mod_status);
* php.ini-based config file.

## PHP Modules

* apcu
* Core
* ctype
* curl
* date
* dom
* fileinfo
* filter
* gd
* hash
* iconv
* imagick
* imap
* intl
* json
* libxml
* mbstring
* mcrypt
* mysqli
* mysqlnd
* openssl
* pcre
* PDO
* pdo_mysql
* Phar
* posix
* readline
* Reflection
* session
* SimpleXML
* SPL
* ssh2
* standard
* tokenizer
* xdebug
* xml
* xmlwriter
* Zend OPcache
* zip
* zlib

## Zend Modules
* Xdebug
* Zend OPcache


## Architectures

* ```:aarch64``` - 64 bit ARM
* ```:armhf```   - 32 bit ARM v6
* ```:armv7```   - 32 bit ARM v7
* ```:ppc64le``` - 64 bit PowerPC
* ```:x86```     - 32 bit Intel/AMD
* ```:x86_64```  - 64 bit Intel/AMD (x86_64/amd64)

## Tags

* ```:latest```         latest branch based (Automatic Architecture Selection)
* ```:aarch64```        latest 64 bit ARM
* ```:armhf```          latest 32 bit ARM v6
* ```:armv7```          latest 32 bit ARM v7
* ```:ppc64le```        latest 64 bit PowerPC
* ```:x86```            latest 32 bit Intel/AMD
* ```:x86_64```         latest 64 bit Intel/AMD
* ```:test```           test branch based (Automatic Architecture Selection)
* ```:test-aarch64```   test 64 bit ARM
* ```:test-armhf```     test 32 bit ARM v6
* ```:test-armv7```     test 32 bit ARM v7
* ```:test-ppc64le```   test 64 bit PowerPC
* ```:test-x86```       test 32 bit Intel/AMD
* ```:test-x86_64```    test 64 bit Intel/AMD
* ```:3.15.4``` 3.15.4 branch based (Automatic Architecture Selection)
* ```:3.15.4-aarch64```   3.15.4 64 bit ARM
* ```:3.15.4-armhf```     3.15.4 32 bit ARM v6
* ```:3.15.4-armv7```     3.15.4 32 bit ARM v7
* ```:3.15.4-ppc64le```   3.15.4 64 bit PowerPC
* ```:3.15.4-x86```       3.15.4 32 bit Intel/AMD
* ```:3.15.4-x86_64```    3.15.4 64 bit Intel/AMD
* ```:3.15.4-7.4.29-r0``` 3.15.4-7.4.29-r0 branch based (Automatic Architecture Selection)
* ```:3.15.4-7.4.29-r0-aarch64```   3.15.4 64 bit ARM
* ```:3.15.4-7.4.29-r0-armhf```     3.15.4 32 bit ARM v6
* ```:3.15.4-7.4.29-r0-armv7```     3.15.4 32 bit ARM v7
* ```:3.15.4-7.4.29-r0-ppc64le```   3.15.4 64 bit PowerPC
* ```:3.15.4-7.4.29-r0-x86```       3.15.4 32 bit Intel/AMD
* ```:3.15.4-7.4.29-r0-x86_64```    3.15.4 64 bit Intel/AMD

## Layers & Sizes

| Version                                                                               | Size                                                                                                                 |
|---------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| ![Version](https://img.shields.io/badge/version-amd64-blue.svg?style=for-the-badge)   | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-php-fpm/latest?style=for-the-badge)  |
| ![Version](https://img.shields.io/badge/version-armv6-blue.svg?style=for-the-badge)   | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-php-fpm/armhf?style=for-the-badge)   |
| ![Version](https://img.shields.io/badge/version-armv7-blue.svg?style=for-the-badge)   | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-php-fpm/armv7?style=for-the-badge)   |
| ![Version](https://img.shields.io/badge/version-ppc64le-blue.svg?style=for-the-badge) | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-php-fpm/ppc64le?style=for-the-badge) |
| ![Version](https://img.shields.io/badge/version-x86-blue.svg?style=for-the-badge)     | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-php-fpm/x86?style=for-the-badge)     |

## Environment Variables:

### Main Php FPM parameters:
* `LC_ALL`: default locale (en_GB.UTF-8)
* `TIMEZONE`: default timezone (Europe/Brussels)
* `IP`: address ip listen (default 0.0.0.0)
* `PORT`: listen port (default 7000)
* `WWW_DATA`: specify the path of the website
* `WWW_USER`: specify the user ownership (default www)
* `WWW_USER_ID`: specify the user identifier (uid) associate at WWW_USER (default 5001)
* `WWW_GROUP`: specify the group ownership (default www-data)
* `WWW_GROUP_ID`: specify the user group identifier (gid) associate as WWW_GROUP (default 33)
* `PHP_POOL_PM_MODE`: Choose how the process manager will control the number of child processes. Possible values: static, ondemand, dynamic (default dynamic)
* `PHP_POOL_MAX_CHILDREN`: The number of child processes to be created when pm is set to static and the maximum number of child processes to be created when pm is set to dynamic. (default 5)
* `PHP_POOL_START_SERVERS`: The number of child processes created on startup. Used only when pm is set to dynamic (default 2)
* `PHP_POOL_MIN_SPARE_SERVERS`: The desired minimum number of idle server processes. Used only when pm is set to dynamic (default 1)
* `PHP_POOL_MAX_SPARE_SERVERS`: The desired maximum number of idle server processes. Used only when pm is set to dynamic (default 3)
* `PHP_POOL_REQUEST_TERMINATE_TIMEOUT`: The timeout for serving a single request after which the worker process will be killed. This option should be used when the 'max_execution_time' ini option does not stop script execution for some reason. A value of '0' means 'Off'. Available units: s(econds)(default), m(inutes), h(ours), or d(ays). (default 300).
* `PHP_XDEBUG_ENABLED`: Enabled (1) or disabled (0) xdebug extension (default 1)
* `PHP_XDEBUG_CLIENT_PORT`: (default 9000)
* `PHP_XDEBUG_DISCOVER_CLIENT_HOST`: (default 1)
* `PHP_XDEBUG_START_WITH_REQUEST`: (default yes)
* `PHP_XDEBUG_LOG`: (default /tmp/xdebug.log)
* `PHP_XDEBUG_MODE`: (default debug,develop)

***
###### Last Update 30.04.2022 14:23:00
