# == Class: memcached::params
#
class memcached::params {
  case $::osfamily {
    'Debian': {
      $package_name      = 'memcached'
      $service_hasstatus = false
      $dev_package_name  = 'libmemcached-dev'
      $config_tmpl       = "${module_name}/memcached.conf.erb"
      $user              = 'nobody'
    }
    /RedHat|Suse/: {
      $package_name      = 'memcached'
      $service_hasstatus = true
      $dev_package_name  = 'libmemcached-devel'
      $config_tmpl       = "${module_name}/memcached_sysconfig.erb"
      $init_tmpl         = "${module_name}/memcached.init.erb"
      $user              = 'memcached'
    }
    default: {
      case $::operatingsystem {
        'Amazon': {
          $package_name      = 'memcached'
          $service_hasstatus = true
          $dev_package_name  = 'libmemcached-devel'
          $config_tmpl       = "${module_name}/memcached_sysconfig.erb"
          $init_tmpl         = "${module_name}/memcached.init.erb"
          $user              = 'memcached'
        }
        default: {
          fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
  }
}
