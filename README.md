sssd_ldap
=========

Install and configure sssd, nsswitch, pam and sshd to get user accounts from LDAP

Requirements
------------

None

Role Variables
--------------

You can override variables in your group_vars

- `sssd_ldap_search_base: dc=example,dc=org`
- `sssd_ldap_uri: ldap://example.org`
- `sssd_ldap_default_bind_dn: cn=manager,dc=example,dc=org`
- `sssd_ldap_default_authtok: bind_password`
- `sssd_ldap_user_ssh_public_key: sshPublicKey`


Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: sssd_ldap }

License
-------

MIT

Author Information
------------------

Anton Ustyuzhanin
