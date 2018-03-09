sssd-ldap
=========

[![Build Status](https://travis-ci.org/hellofresh/ansible-sssd-ldap.svg?branch=master)](https://travis-ci.org/hellofresh/ansible-sssd-ldap)

Install and configure sssd, nsswitch, pam and sshd to get user accounts from LDAP

Requirements
------------

None

Role Variables
--------------

You can override variables in your group_vars

- `sssd_ldap_search_base: dc=example,dc=org`
- `sssd_ldap_user_search_base: see sssd-ldap man page`
- `sssd_ldap_group_search_base: see sssd-ldap man page`
- `sssd_ldap_uri: ldap://example.org`
- `sssd_ldap_default_bind_dn: cn=manager,dc=example,dc=org`
- `sssd_ldap_default_authtok: bind_password`
- `sssd_ldap_user_ssh_public_key: sshPublicKey`
- `sssd_ldap_override_gid: 500`

Dependencies
------------

None

Example Playbook
----------------

An example of how to use the role:

    - hosts: servers
      roles:
         - { role: sssd-ldap }

License
-------

MIT

Author Information
------------------

Anton Ustyuzhanin
