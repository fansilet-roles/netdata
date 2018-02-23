NetData
=========
  
[![Build Status](https://travis-ci.org/isca0/netdata.svg?branch=master)](https://travis-ci.org/isca0/netdata)
  
Install, update netdata and adjsut a few more util things on netdata.conf.  

This role can bind to a specific address, setup a registry, configure retention time,  
adjust KSM(Kernel Same-page Merging) and a few more things. Keep reading. :wink:  
The installation process of this role use the netdata static64 script to install, so it can be  
used in any kind of GNU/Linux distribution. But i tested it on Centos6,7 and CoreOS.  

Requirements
------------

The target host will need python and bash.

Role Variables
--------------

This is the variables you can adjust in your playbook:

  **netdataupdate** : can be setted to True or False. If True netdata will be installed and updated.  
  
  **historytime** : How much time you want to retention of data. Default is 3600 == 1Hour
  
  **updatetime** : Adjust data collection frequency, Default 1 == 1s. On weak devices set this to 3 or more.
  
  **ksmset** : Manage KSM Settings, this can increase 50~60% of netdata performance. Default is True  
  
  **bind** : if setted to True, netdata will bind to the private address matched on **ipaddrs** variable.  
  
  **ipaddrs** : This array must contain the subnets who netdata will bind to.  

  If you have a server that has a public ip address and you want netdata to only listen on private  
  subnet of this server. So you will need to configure netdata.conf bind to = myprivate_address  
  This role can discover the private ipaddress by the initial of your subnet, so  
  all you must do is set on this array the initial octet of your subnet.
  eg.:
    If your subnet is: 192.168.23.0/26
    the array must be:
      
   ```
   ipaddrs:
     - 192.168.23
   ```
  
 It will also work with multiple subnets:

   ```
   ipaddrs:
     - 192.168
     - 10.0
     - 10.1
     ...
   ```
   
 If the private address of the host match with the subnet 10.0, this will define ```netdata.conf```to somenthing like:  

  ```
  [global]
  bind to = 127.0.0.1:19999 [::1]:19999 10.0.1.1:199999
  ...
  ```
    
 This way you can prevent netdata to listen on public address.

Dependencies
------------

None

Example Playbook
----------------

Here is a playbook sample. 

This is the most basic use of this role, it will only install netdata and if it already exist  
it will not be upgraded. This will also disable private binding address so netdata will listen on  
0.0.0.0:19999.  
  
  
```
- name: "Deploy Netdata"
  hosts: somehost
  remote_user: myuser
  become: true
  vars:
    netdataupdate: False
  roles:
    - isca0.netdata
```
  
This sample will install and update the netdata if it already is installed. And then bind netdata  
only to private subnets that matchs with 10.0 and 192.168.

```
- name: "Deploy Netdata"
  hosts: somehost
  remote_user: myuser
  become: true
  vars:
    netdataupdate: True
    bind: True
    ipaddrs:
      - 10.0
      - 192.168
  roles:
    - isca0.netdata
```

This is the most complete sample os this rule it uses almost all variables. Using this way you  
netdata will update even if it already is installed, set the retention time of data to 4 hours  
and data collection will be every 2 seconds and it will bind to macthed ip address finded  
on the match subnets.

```
- name: "Deploy Netdata"
  hosts: somehost
  remote_user: myuser
  become: true
  vars:
    netdataupdate: True
    historytime: 14400
    updatetime: 2
    bind: True
    ipaddrs:
      - 10.0
      - 192.168
  roles:
    - isca0.netdata
```

License
-------

LGPL-3.0

Author Information
------------------

This role was create in 2018 by [isca](https://isca.space)

