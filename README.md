# demo-edge2ai-training

###  Testing
* In a new Centos Linux version 7.6+ host run the following:
```
sudo -i
yum install -y git
git clone https://github.com/tlepple/demo-edge2ai-training.git
cd demo-edge2ai-training

```

### Preparing files for configuration of local DNS Server

* Run the follow from command prompt:
```
cd components/install_named/

# prepare the needed conf files from templates:
bin/prepare_named_setup.sh

```
