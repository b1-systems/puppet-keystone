#
define keystone::db::mysql::host_access(
  $user,
  $password,
  $database,
  $mysql_module = '0.9'
) {
  if ($mysql_module >= 2.2) {
    mysql_user { "${user}@${name}":
      password_hash => mysql_password($password),
      require       => Mysql_database[$database],
    }

    mysql_grant { "${user}@${name}/${database}.*":
      privileges => ['ALL'],
      options    => ['GRANT'],
      table      => "${database}.*",
      require    => Mysql_user["${user}@${name}"],
      user       => "${user}@${name}"
    }
  } else {
    database_user { "${user}@${name}":
      password_hash => mysql_password($password),
      provider      => $::dtagcloud::params::db_provider,
      require       => Database[$database],
    }
    database_grant { "${user}@${name}/${database}":
      # TODO figure out which privileges to grant.
      privileges => 'all',
      provider   => $::dtagcloud::params::db_provider,
      require    => Database_user["${user}@${name}"]
    }
  }
}
