class nginx  (
  $package = $nginx::params::package,
   $owner   = $nginx::params::owner,  
   $group   = $nginx::params::group,  
   $docroot = $nginx::params::docroot,  
   $confdir = $nginx::params::confdir,  
   $logdir  = $nginx::params::logdir,  
   $user    = $nginx::params::user, 
) inherits nginx::params {
  

  File {
    ensure => file,
    owner => $owner,
    group => $group,
    mode => '0664',
  }
  
  # this is now defined in case statement
  # $docroot = '/var/www'
  # $confdir = '/etc/nginx'
  
  package { $package :
    ensure => present,
  }
  
  file { [$docroot, "${confdir}/conf.d"]:
    ensure => directory,
    }
  
  file { "$docroot/index.html":
    source => 'puppet:///modules/nginx/index.html',
  }
  
  file { "${confdir}nginx.conf":
    ensure => file,
    content => template('nginx/nginx.conf.erb'), 
    # We'll use ERB now instead of source template
    # source => 'puppet:///modules/nginx/nginx.conf',
    # require => Package['nginx'],
    notify => Service['nginx'],
  }
  
  
  file { "${confdir}/conf.d/default.conf":
    ensure => file,
    # We'll use ERB now instead of source template
    # source => 'puppet:///modules/nginx/default.conf',
    # Already defined nginx ensure present as above
    # require => Package['nginx'],
    content => template('nginx/default.conf.erb'),
    notify => Service['nginx'],
  }
  
  service { 'nginx':
    ensure => running,
    enable => true,
  }
}

