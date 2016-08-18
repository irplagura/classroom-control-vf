class nginx  {
  File {
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => '0664',
  }
  
  $docroot = '/var/www'
  $confdir = '/etc/nginix'
  
  package {'nginx':
    ensure => present,
  }
  
  file { $docroot :
    ensure => directory,
    }
  
  file '${docroot}/index.html':
    source => 'puppet:///modules/nginx/index.html',
  }
  
  file {'${confdir}nginx.conf':
    source => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify => Service['nginx'],
  }
  
  file {'${confdir}/conf.d':
    ensure => directory,
    source  => 'puppet:///modules/nginx/nginx.conf',    
    require => Package['nginx'],    
    notify  => Service['nginx'], 
    }
    
  file {'${confdir}/conf.d/default.conf':
    source => 'puppet:///modules/nginx/default.conf',
    require => Package['nginx'],
    notify => Service['nginx'],
  }
  
  service { 'nginx':
    ensure => running,
    enable => true,
  }
}

