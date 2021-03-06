#
# This class implements some reasonable admin defaults for keystone.
#
# It creates the following keystone objects:
#   * service tenant (tenant used by all service users)
#   * "admin" tenant (defaults to "openstack")
#   * admin user (that defaults to the "admin" tenant)
#   * admin role
#   * _member_ role
#   * adds admin role to admin user on the "admin" tenant
#
# [*Parameters*]
#
# [email] The email address for the admin. Required.
# [password] The admin password. Required.
# [admin_tenant] The name of the tenant to be used for admin privileges. Optional. Defaults to openstack.
# [admin] Admin user. Optional. Defaults to admin.
# [ignore_default_tenant] Ignore setting the default tenant value when the user is created. Optional. Defaults to false.
#
# == Dependencies
# == Examples
# == Authors
#
#   Dan Bode dan@puppetlabs.com
#
# == Copyright
#
# Copyright 2012 Puppetlabs Inc, unless otherwise noted.
#
class keystone::roles::admin(
  $email,
  $password,
  $admin                  = 'admin',
  $admin_tenant           = 'openstack',
  $service_tenant         = 'services',
  $ignore_default_tenant  = false,
) {

  keystone_tenant { $service_tenant:
    ensure      => present,
    enabled     => true,
    description => 'Tenant for the openstack services',
  }
  keystone_tenant { $admin_tenant:
    ensure      => present,
    enabled     => true,
    description => 'admin tenant',
  }
  keystone_user { $admin:
    ensure                => present,
    enabled               => true,
    tenant                => $admin_tenant,
    email                 => $email,
    password              => $password,
    ignore_default_tenant => $ignore_default_tenant,
  }
  keystone_role { ['admin', '_member_']:
    ensure => present,
  }
  keystone_user_role { "${admin}@${admin_tenant}":
    ensure => present,
    roles  => 'admin',
  }

}
