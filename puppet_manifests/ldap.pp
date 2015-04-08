exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>
Class['ldap::server::master'] -> Ldapdn <| |>
Ldapdn['base'] -> Ldapdn <| title != 'base'|>

class { 'ldap::server::master':
  suffix      => 'dc=geeksoc,dc=org',
  rootpw      => '{SHA}UnqbKxQCQ789G0yinbR+jCapffE=',
}


class { 'phpldapadmin':
  ldap_host      => 'localhost',
  ldap_suffix    => 'dc=geeksoc,dc=org',
}

ldapdn{ "base":
    dn => "dc=geeksoc,dc=org",
    attributes => [ "dc: geeksoc",
                    "objectClass: organization",
                    "objectClass: dcObject",
                    "o: geeksoc.org" ],
    unique_attributes => ["dc"],
    ensure => present,
     auth_opts => ["-xD", "cn=admin,dc=geeksoc,dc=org", "-w", "geeksoc"],
  }

$organizational_units = ["groups", "users"]
ldap::add_organizational_unit{ $organizational_units: }

define ldap::add_organizational_unit () {

  ldapdn{ "ou ${name}":
    dn => "ou=${name},dc=geeksoc,dc=org",
    attributes => [ "ou: ${name}",
                    "objectClass: organizationalUnit" ],
    unique_attributes => ["ou"],
    ensure => present,
     auth_opts => ["-xD", "cn=admin,dc=geeksoc,dc=org", "-w", "geeksoc"],
  }

}

$user_groups = ["members:500", "sysadmin:501"]
ldap::add_user_group{ $user_groups: }

define ldap::add_user_group () {
  $groupinfo = split($name, ':')
  $groupname = $groupinfo[0]
  $groupid = $groupinfo[1]
  ldapdn{ "group ${name}":
    dn => "cn=${groupname},ou=groups,dc=geeksoc,dc=org",
    attributes => [ "cn: ${groupname}",
                    "objectClass: posixGroup",
                    "gidNumber: ${groupid}" ],
    unique_attributes => ["cn","gidnumber"],
    ensure => present,
     auth_opts => ["-xD", "cn=admin,dc=geeksoc,dc=org", "-w", "geeksoc"],
  }

}
