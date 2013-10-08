##  checks out the repo for the oxfam website and adds nginx config file
class blogs-oxfam::repo {
  vcsrepo{ "/var/www/blogs.oxfam.local":
    provider => git,
    source   => 'git@github.com:OxfamInternational/blogs_oxfam_org_d7.git',
    ensure   => present,
    identity => '/home/vagrant/.ssh/github-key',
    require => File["/home/vagrant/.ssh/github-key"],
  }
}

class blogs-oxfam::conf {
  File {
    # require => Class ["blogs-oxfam::repo"],
    ensure => present,
    # owner => "root",
    # group => "root",
    mode => 644,
  }
  
  file { "/var/www/blogs.oxfam.local":
    ensure => directory,
    owner => "501",
    group => "vagrant",
    mode => 0755,
  }
  file { "/var/www/blogs.oxfam.local/sites/default":
    ensure => directory,
    owner => "501",
    group => "vagrant",
    mode => 0777,
  }
  
  file {"/var/www/blogs.oxfam.local/sites/default/settings.php":
    source => "/vagrant/deployment/files/blogs.oxfam.local/var/www/blogs.oxfam.local/sites/default/settings.php",
    ensure => file,
    owner => "501",
    group => "vagrant",
    require => [ File["/var/www/blogs.oxfam.local"], File["/var/www/blogs.oxfam.local/sites/default"] ]
  }
 
  file { "/etc/nginx/conf.d/blogs.oxfam.local.conf":
    source => "/vagrant/deployment/files/etc/nginx/conf.d/blogs.oxfam.local.conf",
    owner => "root",
    group => "root",
  }
   
  file { "/etc/nginx/conf.d/d6blogs.oxfam.local.conf":
    source => "/vagrant/deployment/files/etc/nginx/conf.d/d6blogs.oxfam.local.conf",
    owner => "root",
    group => "root",
  }
  
  exec { "update_d6_blogs_db":
    unless => "find . -mtime -1 -name 'oxfam_blogs.sql'",
    path => ["/bin", "/usr/bin"],
    command => "sh /var/www/blogs.oxfam.local/sites/all/scripts/db_setup.sh",
    require => [ Class["mysql"]],
  }
  
}

class blogs-oxfam {
  include blogs-oxfam::conf
}
