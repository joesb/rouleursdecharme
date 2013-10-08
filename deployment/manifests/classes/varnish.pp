class varnish::repo {
  package { "varnish-libs":
    provider => rpm,
    # source => "http://repo.varnish-cache.org/redhat/varnish-3.0/el5/noarch/varnish-release-3.0-1.noarch.rpm"
    source => "http://repo.varnish-cache.org/redhat/varnish-3.0/el5/x86_64/varnish/varnish-libs-3.0.4-1.el5.centos.x86_64.rpm",
    ensure => installed
  }
  package { "varnish-release":
    provider => rpm,
    source => "http://repo.varnish-cache.org/redhat/varnish-3.0/el5/x86_64/varnish/varnish-3.0.4-1.el5.centos.x86_64.rpm",
    ensure => installed,
    require => Package ["varnish-libs"]
  }
}

class varnish::install {
  $packagelist = ["varnish"]
  
  package { $packagelist:
    require => Class ["varnish::repo"],
    ensure => installed
  }
}

class varnish::service {
  service { "varnish":
    ensure => true,
    enable => true,
    hasrestart => true,
    hasstatus => true,
    require => [
      Class ["varnish::install"],
      Class ["nginx::service"]
    ]
  }
}

class varnish::conf {
  File {
    require => Class ["varnish::install"],
    owner => "root",
    group => "root",
    mode => 644,
    notify => Class ["varnish::service"]
  }
  
  file { "/etc/varnish/default.vcl":
    source => "/vagrant/deployment/files/etc/varnish/default.vcl"
  }

  file { "/etc/varnish/backends.vcl":
    source => "/vagrant/deployment/files/etc/varnish/backends.vcl"
  }
  
  file { "/etc/varnish/acl.vcl":
    source => "/vagrant/deployment/files/etc/varnish/acl.vcl"
  }
  
  file { "/etc/varnish/esi.vcl":
    source => "/vagrant/deployment/files/etc/varnish/esi.vcl"
  }
  
  file { "/etc/sysconfig/varnish":
    source => "/vagrant/deployment/files/etc/sysconfig/varnish"
  }
  
  file { "/etc/varnish/secret":
    source => "/vagrant/deployment/files/etc/varnish/secret",
    mode => 600
  }
  
  file { "/var/www/html/check.html":
    source => "/vagrant/deployment/files/var/www/html/check.html",
    mode => 755,
    require => Class ["nginx::service"]
  }
}

class varnish {
  include varnish::repo, varnish::install, varnish::service, varnish::conf
}
