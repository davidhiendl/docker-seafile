FROM		phusion/baseimage:0.9.22
MAINTAINER	David Hiendl <david.hiendl@dhswt.de>

ENV		INSTALL_DIR				/opt/seafile
ENV		SEAFILE_VERSION			6.1.1
ENV		SEAFILE_DOWNLOAD_URL	"https://download.seafile.com/d/6e5297246c/files/?p=/pro/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz&dl=1"
ENV		SEAFILE_UID				1000
ENV		SEAFILE_GID				1000

EXPOSE	80
VOLUME	/data
WORKDIR	/opt/seafile
CMD		/sbin/my_init

# install packaged dependencies
RUN		DEBIAN_FRONTEND=noninteractive \
		apt-get update && \
		apt-get install -y \
			openjdk-8-jre-headless \
			poppler-utils \
			libpython2.7 \
			python-pip \
			python-setuptools \
			python-imaging \
			python-mysqldb \
			python-memcache \
			python-ldap \
			python-urllib3 \
			nginx \
			gettext-base \
			sqlite3 \
			wget \

# install python dependencies
&&		pip install \
			boto \
			requests \

# clean up pip as it is no longer required
&&		apt-get remove -y \
			python-pip \
&&		apt-get autoremove -y \

# clean up cache
&&		apt-get clean \
&&		rm -rf \
			/var/lib/apt/lists/* \
			/tmp/* \
			/var/tmp/* \

# remove default nginx site
&&		rm /etc/nginx/sites-enabled/*

# download seafile
RUN		mkdir -p $INSTALL_DIR \
&&		cd $INSTALL_DIR \
&&		wget -O seafile.tar.gz $SEAFILE_DOWNLOAD_URL \
&&		tar xfz seafile.tar.gz \
&&		rm seafile.tar.gz \

# add user with consistent uid and gid
&&		groupadd seafile \
			-r \
			-g $SEAFILE_GID \
&&		useradd seafile \
			-r \
			-s /bin/bash \
			-M \
			-u $SEAFILE_UID \
			-g $SEAFILE_GID \
			-d $INSTALL_DIR \
&&		chown -R seafile:seafile $INSTALL_DIR

# install services, scripts, config
ADD		services	/etc/service
ADD		init.d		/etc/my_init.d
ADD		config		/config
ADD		cron		/etc/cron.d
ADD		bin			/usr/local/sbin

# update permissions
RUN		chmod 555 \
			/etc/my_init.d/* \
			/usr/local/sbin/* \
			/etc/service/seafile/* \
			/etc/service/seahub/* \
			/etc/service/nginx/* \
&&		chmod 0644 \
			/etc/cron.d/*
