class nginx  (
  $root = undef,
  
) inherits nginx::params {
  
  case $::osfamily {
    'redhat','debian': {
      $package = 'nginx'
      $owner = 'root'
      $group = 'root'
      $default_docroot = '/var/www'
      $confdir = '/etc/nginx'
      $logdir = '/var/log/nginx'
    }
    'windows':{
      $package ='nginx-service'
      $owner = 'Administrator'
      $group = 'Administrators'
      $confdir = 'C:/ProgramData/nginx' 
      $logdir  = 'C:/ProgramData/nginx/logs'
    }
    default :{
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }

 # user the service will run as. Used in the nginx.conf.erb template 
 $user = $::osfamily ? {
   'redhat' => 'nginx',
   'debian' => 'www-data',
   'windows' => 'nobody',
 }

 # Using selector,  if root isn't set, then failback to platform default
 $docroot = $root ? {
   undef => $default_docroot,
   default => $root,
 }

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

