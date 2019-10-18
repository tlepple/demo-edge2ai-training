# Edge2AI Environment Setup

---
---

* This repository contains code that will automate the install of some CDH services and detail out some training steps you can complete on your own.

---
---
## Acknowledgments:

*  The bulk of the materials in this training were developed by Fabio Ghirardello and his original repository is here: [IoT-Predictive Maintenance](https://github.com/fabiog1901/IoT-predictive-maintenance)


---

## Notes:
---

* This repository was created to add some new training and automate the install of some additional tools.  Specifically (DNS server & Superset).
* This has currently only been tested to run in AWS and Azure

---
---

###  Install / Setup
---
---
 
##### Recommended Virtual Machines
* This will run on a AWS (m4.2xlarge) instance with 100 GB for OS and 100 GB for CDSW volume.
* It will also run on a AWS (m4.4xlarge) instance with 100 GB for OS and 200 GB for CDSW volume.
* In Azure it requires a Standard_D8s_v3 or a larger Standard_D16s_v3

---
---

#### Pre-Reqs:
* Build new VM with instance type (m4.2xlarge, m4.4xlarge)
* Choose a Centos Linux 7.6+ 
* `SSH` into your new instance
* Make note of the 2nd volume you mounted for CDSW.  ie. `/dev/xvdc`.  This volume is mounted at `xvdc` in linux.  

### Check your mount point with `lsblk`

#####  Example
```
lsblk

# Sample Output:
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
fd0      2:0    1    4K  0 disk 
sda      8:0    0   30G  0 disk 
├─sda1   8:1    0  500M  0 part /boot
└─sda2   8:2    0 29.5G  0 part /
sdb      8:16   0   64G  0 disk 
└─sdb1   8:17   0   64G  0 part /mnt/resource
sdc      8:32   0  100G  0 disk 
sr0     11:0    1  628K  0 rom  

```

---

### Install Repository

```
sudo -i
yum install -y git
git clone https://github.com/tlepple/demo-edge2ai-training.git
cd ~/demo-edge2ai-training

```

### AWS Install commands:
```
# sample call:
. bin/setup.sh <cloud provider: aws|azure|gcp> <cluster template> <cdsw block device>

# Here is my actual AWS code example:
. bin/setup.sh aws cdsw_template.json /dev/xvdc
```

### Azure Install commands:
```
. bin/setup.sh azure cdsw_template.json /dev/sdc
```



---

###  Estimated install time of Components:

| Service       | Aprox Run Time    | 
| ------------- |:-----------------:| 
| forkedOneNode |  20 Min           | 
| Superset      |  12 Min           | 
| DNS		| < 1 min	    |
| CDSW Restart  |  15 min	    |


---

*  The following commands are only used when starting or stopping services. All services are running upon completion of initial setup...

---
### Start / Stop services running in Cloudera Manager with these commands:

```
# Start all services:
cd ~/demo-edge2ai-training
. bin/start_cluster.sh

# Stop all services:
cd ~/demo-edge2ai-training
. bin/stop_cluster.sh

```
