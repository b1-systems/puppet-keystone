define keystone::db::mysql::host_access(
  $user,
  $password,
  $database
) {

  database_user { "${user}@${name}":
    password_hash => mysql_password($password),
    provider => $::dtagcloud::params::db_provider,
    require       => Database[$database],
  }
  database_grant { "${user}@${name}/${database}":
    # TODO figure out which privileges to grant.
    privileges => 'all',
    provider => $::dtagcloud::params::db_provider,
    require    => Database_user["${user}@${name}"]
  }

}
