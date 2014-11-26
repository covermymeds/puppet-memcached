# == Class: memcached
#
# Manage memcached
#
class memcached (
  $package_ensure   = 'present',
  $logfile          = '/var/log/memcached.log',
  $pidfile          = '/var/run/memcached.pid',
  $manage_firewall  = false,
  $max_memory       = false,
  $item_size        = false,
  $lock_memory      = false,
  $listen_ip        = '0.0.0.0',
  $tcp_port         = 11211,
  $udp_port         = 11211,
  $user             = $::memcached::params::user,
  $max_connections  = '8192',
  $verbosity        = undef,
  $unix_socket      = undef,
  $install_dev      = false,
  $processorcount   = $::processorcount,
  $service_restart  = true,
  $auto_removal     = false,
  $use_sasl         = false,
  $large_mem_pages  = false,
  $default_instance = true,
  $instance_configs = hiera_hash('memcached::instance_configs', undef),
) inherits memcached::params {

  if $package_ensure == 'absent' {
    $service_ensure = 'stopped'
    $service_enable = false
  } else {
    $service_ensure = 'running'
    $service_enable = true
  }

  package { $memcached::params::package_name:
    ensure => $package_ensure,
  }

  if $install_dev {
    package { $memcached::params::dev_package_name:
      ensure  => $package_ensure,
      require => Package[$memcached::params::package_name]
    }
  }


  $default_configs = { 
    "memcached" => {
      manage_firewall => $manage_firewall,
      max_memory      => $max_memory,
      item_size       => $item_size,
      lock_memory     => $lock_memory,
      listen_ip       => $listen_ip,
      tcp_port        => $tcp_port,
      udp_port        => $udp_port,
      user            => $user,
      max_connections => $max_connections,
      verbosity       => $verbosity,
      unix_socket     => $unix_socket,
      processorcount  => $processorcount,
    }, 
  }

  if $default_instance and is_hash($instance_configs) {
    validate_hash($instance_configs)
    $final_configs = merge($default_configs, $instance_configs)
  }
  elsif $default_instance {
    $final_configs = $default_configs
  }
  elsif is_hash($instance_configs) {
    validate_hash($instance_configs)
    $final_configs = $instance_configs
  }

  if ! is_hash($final_configs) {
    fail('No configuration provided to the Memcached class')
  }

  create_resources(memcached::instance, $final_configs)

}
