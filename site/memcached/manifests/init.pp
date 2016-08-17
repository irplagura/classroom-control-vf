class memcached {
  package {'memcached':
    ensure => present,
  }
  
  file {'/etc/sysconfig/memcached':
    ensure => file,
    owner => 'root',
    mode => '0644',
    source => 'puppet:///modules/memcached/memchached',
    require => Package['memcached'],
  }
  
  service {'memcached':
    ensure => running,
    enable => true,
    subscribe => File]'/etc/sysconfig/memcached'],
  }
}
