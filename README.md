I Training

---
---

* This repository contains code that will automate the install of some CDH services and detail out some training steps you can complete on your own.


---
---
## Acknowledgments:

*  The bulk of the materials in this training were developed by Fabio Ghirardello and his original repository is here:  IoT [IoT-Predictive Maintenance](https://github.com/fabiog1901/IoT-predictive-maintenance)


---

## Notes:
---

* This repository was created to add some addition training and automate the install of some additional tools.  Specifically (DNS server & Superset).
* This has currently only been tested to run in AWS

---
---

###  Install / Setup
---
---
 
##### Recommended Virtual Machines
* This will run on a AWS (m4.2xlarge) instance with 100 GB for OS and 100 GB for CDSW volume.
* It will also run on a AWS (m4.4xlarge) instance with 100 GB for OS and 200 GB for CDSW volume.

---
---

#### Pre-Reqs:
* Build new VM with instance type (m4.2xlarge, m4.4xlarge)
* Choose a Centos Linux 7.6+ 
* `SSH` into your new instance
* Make note of the 2nd volume you mounted for CDSW.  ie. `/dev/xvdc`.  This volume is mounted at `xvdc` in linux.

---

### Install

```
sudo -i
yum install -y git
git clone https://github.com/tlepple/demo-edge2ai-training.git
cd ~/demo-edge2ai-training

# sample call:
. bin/setup.sh <cloud provider: aws|azure|gcp> <cluster template> <cdsw block device>

# Here is my actual code example:
. bin/setup.sh aws cdsw_template.json /dev/xvdc


```


---

###  Estimated install time of Components:

| Service       | Aprox Run Time    | 
| ------------- |:-----------------:| 
| DNS           | < 1 Min           |
| forkedOneNode | 40 Min            | 
| Superset      | 15 Min            | 
I Training

---
---

* This repository contains code that will automate the install of some CDH services and detail out some training steps you can complete on your own.


---
---
## Acknowledgments:

*  The bulk of the materials in this training were developed by Fabio Ghirardello and his original repository is here:  IoT [IoT-Predictive Maintenance](https://github.com/fabiog1901/IoT-predictive-maintenance)


---

## Notes:
---

* This repository was created to add some addition training and automate the install of some additional tools.  Specifically (DNS server & Superset).
* This has currently only been tested to run in AWS

---
---

###  Install / Setup
---
---
 
##### Recommended Virtual Machines
* This will run on a AWS (m4.2xlarge) instance with 100 GB for OS and 100 GB for CDSW volume.
* It will also run on a AWS (m4.4xlarge) instance with 100 GB for OS and 200 GB for CDSW volume.

---
---

#### Pre-Reqs:
* Build new VM with instance type (m4.2xlarge, m4.4xlarge)
* Choose a Centos Linux 7.6+ 
* `SSH` into your new instance
* Make note of the 2nd volume you mounted for CDSW.  ie. `/dev/xvdc`.  This volume is mounted at `xvdc` in linux.

---

### Install

```
sudo -i
yum install -y git
git clone https://github.com/tlepple/demo-edge2ai-training.git
cd ~/demo-edge2ai-training

# sample call:
. bin/setup.sh <cloud provider: aws|azure|gcp> <cluster template> <cdsw block device>

# Here is my actual code example:
. bin/setup.sh aws cdsw_template.json /dev/xvdc


```


---

###  Estimated install time of Components:

| Service       | Aprox Run Time    | 
| ------------- |:-----------------:| 
| DNS           | < 1 Min           |
| forkedOneNode | 40 Min            | 
| Superset      | 15 Min            | 

