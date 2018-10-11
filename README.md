sssd-ldap
=========

[![Build Status](https://travis-ci.org/hellofresh/ansible-sssd-ldap.svg?branch=master)](https://travis-ci.org/hellofresh/ansible-sssd-ldap)

Install and configure sssd, nsswitch, pam and sshd to get user accounts from LDAP

Requirements
------------

None

Role Variables
--------------

Role configuration aimed to be similar to SSSD configuration. But, not all configuration options,
supported in `sssd.conf` are available in role variables with the same names. If you setup needs some options that not presented
feel free to create pull requests. You can find available options in `defaults/main.yml` and `templates/sssd.conf.j2`

`[sssd]` section allows to configure following options options:

    sssd_defaults:
      # Debug level for:
      # Fatal failures, Critical failures, Serious failures
      # Configuration settings, Function data
      debug_level: '0x0370'
      services: nss,pam,ssh

`[nss]` section allows to configure following options options:

    sssd_nss:
      filter_users: root
      filter_groups: root

Some default values for domain specific configuration options are:

    sssd_domain_defaults:
      min_id: 1
      max_id: 0
      id_provider: ldap
      auth_provider: ldap
      enumerate: 'false'
      ldap_uri: ldap://localhost
      ldap_id_use_start_tls: 'false'
      ldap_tls_reqcert: never
      ldap_default_bind_dn: cn=manager,dc=example,dc=org
      ldap_default_authtok_type: password
      ldap_default_authtok: bind_password
      ldap_search_base: dc=example,dc=org

Role supports configuring multiple domains using following syntax:
(see sssd man pages for more information)

    sssd_domains:
      - name: domain_name
        min_id:
        max_id:
        id_provider:
        auth_provider:
        ldap_uri:
        ldap_id_use_start_tls:
        ldap_tls_reqcert:
        ldap_default_bind_dn:
        ldap_default_authtok_type:
        ldap_default_authtok:
        ldap_search_base:
        ldap_user_search_base:
        ldap_user_object_class:
        ldap_user_name:
        ldap_user_uid_number:
        ldap_user_gid_number:
        ldap_user_ssh_public_key:
        ldap_user_email:
        override_gid:
        ldap_group_search_base:
        ldap_group_object_class:
        ldap_group_name:
        ldap_group_gid_number:
        ldap_group_member:

Options that are listed in `sssd_domain_defaults` will allways be present in `sssd.conf`,
other options can be omitted.

Dependencies
------------

None

Example Playbook
----------------

An example of how to use the role:

    - hosts: servers
      roles:
         - { role: ansible-sssd-ldap }

License
-------

MIT

Author Information
------------------

Anton Ustyuzhanin
