NetData
=========
  
[![Build Status](https://travis-ci.org/isca0/netdata.svg?branch=master)](https://travis-ci.org/isca0/netdata)
  
Install, update and bind netdata to a specific address.
This role use the netdata static64 script to install netdata, so it can be used in any kind of  
GNU/Linux distribution.

Requirements
------------

The target host will need python, bash and curl.

Role Variables
--------------

This are the variables you can adjust in your playbook

  **netdataupdate** : can be setted to True are False. If True netdata will be installed and updated.  
  
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
    bind to = 127.0.0.1:19999 ::1:19999 10.0.1.1:199999
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
  vars:
    netdataupdate: False
    bind: False
  roles:
    - isca0.netdata
```
  
This sample will install and update the netdata if it already is installed. And then bind netdata  
only to private subnets that matchs with 10.0 and 192.168.

```
- name: "Deploy Netdata"
  hosts: somehost
  remote_user: myuser
  vars:
    netdataupdate: True
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

This role was create in 2017 by [isca](https://isca.space)

