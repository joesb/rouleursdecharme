##  checks out the repo for the oxfam website and adds nginx config file
class www-oxfam::repo {
  vcsrepo{ "/var/www/www.oxfam.local":
    provider => "git",
    source   => "git@github.com:OxfamInternational/www_oxfam_org_d7.git",
    ensure   => present,
    revision => "develop",
    require => Class["github-config"],
  }
}

class www-oxfam::conf {
  File {
    # require => Class ["www-oxfam::repo"],
    ensure => present,
    # owner => "root",
    # group => "root",
    mode => 644,
  }
    
  file { "/var/www/www.oxfam.local":
    ensure => directory,
    owner => "501",
    group => "vagrant",
    mode => 0755,
  }
  file { "/var/www/www.oxfam.local/sites/default":
    ensure => directory,
    owner => "501",
    group => "vagrant",
    mode => 0777,
  }
  
  file {"/var/www/www.oxfam.local/sites/default/settings.php":
    source => "/vagrant/deployment/files/www.oxfam.local/var/www/www.oxfam.local/sites/default/settings.php",
    ensure => file,
    owner => "501",
    group => "vagrant",
    require => [ File["/var/www/www.oxfam.local"], File["/var/www/www.oxfam.local/sites/default"] ]
  }
 
  file { "/etc/nginx/conf.d/www.oxfam.local.conf":
    source => "/vagrant/deployment/files/etc/nginx/conf.d/www.oxfam.local.conf",
    owner => "root",
    group => "root",
  }
   
  file { "/etc/nginx/conf.d/d6www.oxfam.local.conf":
    source => "/vagrant/deployment/files/etc/nginx/conf.d/d6www.oxfam.local.conf",
    owner => "root",
    group => "root",
  }
  
  exec { "update_d6_www_db":
    unless => "find . -mtime -1 -name 'oxfam_org_d6.sql'",
    path => ["/bin", "/usr/bin"],
    command => "sh /var/www/www.oxfam.local/sites/all/scripts/db_setup.sh",
    require => [ Class["mysql"]],
  }
  
}

class www-oxfam {
  include www-oxfam::conf
}
