##  checks out the repo for the oxfam website and adds nginx config file
class gi-guide::repo {
  vcsrepo{ "/var/www/gi.oxfam.local":
    ensure   => present,
    require => Class["github-config"],
  }
}

class gi-guide::conf {
  File {
    owner => "501",
    group => "vagrant",
    mode => 0644,
    require => Class ["nginx::service"]
  }
    
  file { "/var/www/gi-guide.oxfam.local":
    ensure => directory,
  }
 
  file { "/etc/nginx/conf.d/gi-guide.oxfam.local.conf":
    source => "/vagrant/deployment/files/gi-guide.oxfam.local/etc/nginx/conf.d/gi-guide.oxfam.local.conf",
    owner => "root",
    group => "root",
  }

  # $mysql_password = "root"
  # 
  # exec { "create-mysql-db":
  #   unless =>  "mysql -uoxfam -poxfam gi_dist",
  #   path => ["bin", "/usr/bin"],
  #   command => "mysql -uroot -p$mysql_password -e \"CREATE DATABASE gi_dist COLLATE = 'utf8_general_ci'; grant usage on *.* to oxfam@localhost identified by 'oxfam'; grant all privileges on gi_dist.* to oxfam@localhost;\"",
  #   require => [Class["mysql::service"], Exec["set-mysql-password"]],
  # }
  
}

class gi-guide {
  include gi-guide::conf
}
