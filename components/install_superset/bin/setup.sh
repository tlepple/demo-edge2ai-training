#!/bin/bash

#########################################################
# utility functions
#########################################################
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

log_dir=`pwd`

# logging function
log() {
    echo -e "[$(date)] [$BASH_SOURCE: $BASH_LINENO] : $*"
    echo -e "[$(date)] [$BASH_SOURCE: $BASH_LINENO] : $*" >> $log_dir/setup.log
}

#########################################################
# BEGIN
#########################################################
log "BEGIN setup.sh"

#########################################################
# Install yum tools
#########################################################
log "Install needed yum tools"

yum groupinstall -y 'development tools'
yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel xz-libs wget libffi-devel cyrus-sasl-devel

#########################################################
# Install isolated version of python v. 3.7.4
#########################################################
log "Install python3.4 from source"

# create directory
mkdir -p /usr/local/downloads

# change to dir
cd /usr/local/downloads

# download source
wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tar.xz

# unzip and untar this file:
xz -d Python-3.7.4.tar.xz
tar -xvf Python-3.7.4.tar

# change dir
cd Python-3.7.4

# build from source and install
./configure --prefix=/usr/local
make
make altinstall


#########################################################
# Update PATH and re-initialize
#########################################################
log "Update PATH"
sed -i '/^PATH=/ s/$/:\/usr\/local\/bin/' ~/.bash_profile

log "source bash_profile"
source ~/.bash_profile

#########################################################
# Create python virtual environment
#########################################################
log "create python virtual environment"

# create directory
mkdir -p ~/superset-install-oneNode

# change to dir
cd ~/superset-install-oneNode

# create the virtualenv
python3.7 -m venv supersetenv

# set the env active
log "set virtualenv active"
. supersetenv/bin/activate

# install some python tools
log "install - update python tools..."
pip install --upgrade setuptools pip


#########################################################
# Install Superset
#########################################################
log "Install Superset requirements..."

# change dir
cd ~/superset-install-oneNode/supersetenv
pip install -r $dir/../files/requirements.txt

log "Install Superset..."
pip install superset

log "Upgrade superset DB"
superset db upgrade

log "Install sample data to superset"
superset load_examples

log "Install superset Impala drivers"
pip install impyla

log "create roles and permissions"
superset init

# deactivate the virtualenv
deactivate
