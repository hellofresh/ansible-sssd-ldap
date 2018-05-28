#!/bin/sh

set -e

echo "Create LDAP users"
CUSTOM_LDIF_DIR=$(mktemp --directory)

cat <<EOF >${CUSTOM_LDIF_DIR}/test.ldif
dn: uid=test,dc=example,dc=org
uid: test
cn: test
sn: Test
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: ldapPublicKey
loginShell: /bin/bash
homeDirectory: /home/test
uidNumber: 5000
gidNumber: 5000
mail: test@example.org
gecos: Test User
sshPublicKey: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYaGyXcqdQUIxjPr3eqXro9X/2LrLH2o+OrFeGRB2u3WxigroynxD8vLjtG6qyYYtgnvR9+2usVhbNNS3QdF3G5wenCR4Zpk6VIYofQrBYmrzJG9Bsig3G4SgnGF2x4KimupjCdD4+1S9OMF/4GzQZdaLl2HkSTYE+6430FbSD8i3IdpbRI526X8q4njrTHgIYUtAVFTPSudZ/3fIzFpfNlWq5wy1CXCGc7aqmHECQzareeoAM5NfgrUkw7TFrKP/zelDkqpJ6pwYTWg2VZYmoXmh2o+ttWFatGzJPUoeU/r+SjMn4YvMunT+L6NIrbJQkXwB9i3upMx2bQcuPl0cl test-key
EOF

cat <<EOF >${CUSTOM_LDIF_DIR}/filtered.ldif
dn: uid=filtered,dc=example,dc=org
uid: filtered
cn: filtered
sn: Filtered
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
loginShell: /bin/bash
homeDirectory: /home/filtered
uidNumber: 5001
gidNumber: 5001
mail: filtered@example.org
gecos: Filtered User
EOF

echo "Starting docker container running OpenLDAP server"
LDAP_CONTAINER_NAME="openldap"
LDAP_ADMIN_PASSWORD="s3cr3t"
docker run --detach --name ${LDAP_CONTAINER_NAME} \
    --env LDAP_ADMIN_PASSWORD=${LDAP_ADMIN_PASSWORD} \
    --volume ${CUSTOM_LDIF_DIR}:/container/service/slapd/assets/config/bootstrap/ldif/custom \
    osixia/openldap:1.2.0 --copy-service

echo -n "Waiting for ldap server to be ready"
until docker logs openldap 2>&1 | grep "slapd starting" >/dev/null 2>&1
do echo -n "."; sleep 1; done
echo

echo "Prepare python virtual env for running tests"
virtualenv --version >/dev/null
if [ $? != 0 ]
then
  echo -e "Please install python virtualenv package to perform the tests"
  exit 1
fi
virtualenv venv
. ./venv/bin/activate
pip install -r requirements.txt

echo "Run molecule tests"
molecule test

echo "Cleanup"
deactivate
rm -rf ./venv/
docker rm -f ${LDAP_CONTAINER_NAME}
rm -rf ${CUSTOM_LDIF_DIR}
