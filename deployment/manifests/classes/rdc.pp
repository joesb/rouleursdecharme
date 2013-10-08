##  checks out the repo for the oxfam website and adds nginx config file
# class gi-dist::repo {
#   vcsrepo{ "/var/www/gi.oxfam.local":
#     ensure   => present,
#     require => Class["github-config"],
#   }
# }

class rdc::conf {
  File {
    require => [
      # Class ["gi-dist::repo"],
      Class ["nginx::service"]
    ],
    ensure => present,
    owner => "501",
    group => "vagrant",
    mode => 0644,
  }
    
  file { "/var/www/webapp":
    ensure => directory,
    # owner => "501",
    # group => "vagrant",
    # mode => 0644,
    # require => Class ["nginx::service"]
  }
  file { "/var/www/webapp/sites":
    ensure => directory,
    # owner => "501",
    # group => "vagrant",
    # mode => 0644,
    # require => Class ["nginx::service"]
  }
  file { "/var/www/webapp/sites/default":
    ensure => directory,
    # owner => "501",
    # group => "vagrant",
    # mode => 0644,
    # require => Class ["nginx::service"]
  }
  
  file {"/var/www/webapp/sites/default/settings.php":
    source => "/vagrant/deployment/files/rdc/var/www/webapp/sites/default/settings.php",
    ensure => file,
    # owner => "501",
    # group => "vagrant",
    require => [ File["/var/www/webapp"], File["/var/www/webapp/sites/default"], Class ["nginx::service"] ]
  }
 
  file { "/etc/nginx/conf.d/www.rouleursdecharme.local.conf":
    source => "/vagrant/deployment/files/rdc/etc/nginx/conf.d/www.rouleursdecharme.local.conf",
    owner => "root",
    group => "root",
    # require => Class ["nginx::service"]
  }

  $mysql_password = "root"
  
  exec { "create-mysql-db":
    unless =>  "mysql -urdc -prdc rdc",
    path => ["bin", "/usr/bin"],
    command => "mysql -uroot -p$mysql_password -e \"CREATE DATABASE rdc COLLATE = 'utf8_general_ci'; grant usage on *.* to rdc@localhost identified by 'rdc'; grant all privileges on rdc.* to rdc@localhost;\"",
    require => [Class["mysql::service"], Exec["set-mysql-password"]],
  }
  
}

class rdc {
  include rdc::conf
}
