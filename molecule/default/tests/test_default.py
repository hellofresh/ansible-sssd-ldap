import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'


def test_sssd_ldap_user(host):
    user = host.user('test')
    assert user.uid == 5000
    assert user.gid == 1


def test_sssd_ldap_user_filtered(host):
    user = host.user('filtered-test')
    assert not user.exists


def test_sssd_service_state(host):
    assert host.service('sssd').is_enabled
    assert host.service('sssd').is_running


def test_sshd_service_state(host):
    ssh_service_name = {
        'centos': 'sshd',
        'ubuntu': 'ssh'
    }
    assert host.service(
        ssh_service_name[host.system_info.distribution]).is_enabled
    assert host.service(
        ssh_service_name[host.system_info.distribution]).is_running


def test_ssh_access(host):
    host.run_test(
        '/usr/bin/ssh '
        '-o StrictHostKeyChecking=no '
        '-o BatchMode=yes '
        '-T '
        '-i /root/.ssh/id_rsa '
        '-l test '
        'localhost '
        'exit'
    )


def test_homedir_created(host):
    assert host.file('/home/test').is_directory
