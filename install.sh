#!/bin/bash
locale-gen en_US.UTF-8 && update-locale && apt-get update -y && apt-get install -y bzip2 make build-essential curl libhdf5-dev

curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh >conda_install.sh && chmod +x conda_install.sh && ./conda_install.sh -b -p /usr/miniconda3 && rm conda_install.sh

conda install -y numpy

conda env create --name py3_env --file conda_py3_env.yml
source activate py3_env
pip install --upgrade https://github.com/Theano/Theano/archive/master.zip
pip install --upgrade https://github.com/Lasagne/Lasagne/archive/master.zip

conda env create --name py2_env --file conda_py2_env.yml
source activate py2_env
pip install --upgrade https://github.com/Theano/Theano/archive/master.zip
pip install --upgrade https://github.com/Lasagne/Lasagne/archive/master.zip

conda env create --name r_env --file conda_r_env.yml && source activate r_env
Rscript install_modules.R

rm -rf /tmp/* install_modules.R *.yml *.sh && apt-get clean

chmod -R 0755 /usr/miniconda3 || true
