##  checks out the repo for the oxfam website and adds nginx config file
class gi-theme::repo {
  vcsrepo{ "/var/www/gi-theme.oxfam.local":
    ensure   => present,
    require => Class["github-config"],
  }
}

class gi-theme::conf {
  # File {
  #   # require => Class ["gi-theme::repo"],
  #   # ensure => present,
  #   # owner => "root",
  #   # group => "root",
  #   # mode => 644,
  # }
    
  file { "/var/www/gi-theme.oxfam.local":
    ensure => directory,
    owner => "501",
    group => "vagrant",
    mode => 0755,
  }
  file { "/var/www/gi-theme.oxfam.local/sites/default":
    ensure => directory,
    owner => "501",
    group => "vagrant",
    mode => 0777,
  }
  
  file {"/var/www/gi-theme.oxfam.local/sites/default/settings.php":
    source => "/vagrant/deployment/files/gi-theme.oxfam.local/var/www/gi-theme.oxfam.local/sites/default/settings.php",
    ensure => file,
    owner => "501",
    group => "vagrant",
    require => [ File["/var/www/gi-theme.oxfam.local"], File["/var/www/gi-theme.oxfam.local/sites/default"] ]
  }
 
  file { "/etc/nginx/conf.d/gi-theme.oxfam.local.conf":
    source => "/vagrant/deployment/files/gi-theme.oxfam.local/etc/nginx/conf.d/gi-theme.oxfam.local.conf",
    owner => "root",
    group => "root",
  }
  
}

class gi-theme {
  include gi-theme::conf
}
