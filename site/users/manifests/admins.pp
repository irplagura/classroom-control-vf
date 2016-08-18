class users::admin {
  users::managed_user {'joe':}
  users::managed_user {'alice' :
    group => 'staff',
  }
  group {'staff':
    ensure => present,
  }
}
