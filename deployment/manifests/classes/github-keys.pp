# makes sure git package and the github config are set up on the machine 
class github-config {

  package { "git": ensure => installed }

  # Install gitflow
  exec { "get_git_flow":
    command => "/usr/bin/wget --no-check-certificate -q -O - https://github.com/nvie/gitflow/raw/develop/contrib/gitflow-installer.sh | sudo bash",
    creates => "/usr/local/bin/gitflow-common",
    require => [ 
      Package['wget'], 
      Package['git'] 
    ],
  }

  file { "/root/.ssh":
    ensure => directory,
    owner => "root",
    group => "root",
    mode => 0755,
  }

  file { "/root/.ssh/config":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    require => File["/root/.ssh"],
    source => "/vagrant/deployment/files/github_keys/ssh_config"
  }
  
  file { "/root/.ssh/authorized_keys":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    require => File["/root/.ssh"],
    source => "/vagrant/deployment/files/github_keys/authorized_keys"
  }

  file { "/root/.ssh/dev-vagrant.pub":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    require => File["/root/.ssh"],
    source => "/vagrant/deployment/files/github_keys/dev-vagrant.pub"
   }

  file { "/root/.ssh/dev-vagrant":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0600,
    require => File["/root/.ssh"],
    source => "/vagrant/deployment/files/github_keys/dev-vagrant"
   }

  # file { "/home/vagrant/.ssh/config":
  #   ensure => present,
  #   owner => "vagrant",
  #   group => "vagrant",
  #   mode => 0755,
  #   require => File["/home/vagrant/.ssh"],
  #   source => "/vagrant/deployment/files/github_keys/.ssh_config"
  #  }
     

     file { "/home/vagrant/.ssh/id_rsa.pub":
         ensure => present,
         owner => "vagrant",
         group => "vagrant",
         mode => 0644,
         source => "/vagrant/deployment/files/github_keys/id_rsa.pub"
      }
     
     file { "/home/vagrant/.ssh/id_rsa":
         ensure => present,
         owner => "vagrant",
         group => "vagrant",
         mode => 0600,
         source => "/vagrant/deployment/files/github_keys/id_rsa"
      }
      
      # A user .gitconfig file
      file { "/home/vagrant/.gitconfig":
        mode => 0644,
        owner => vagrant,
        group => vagrant,
        source => "/vagrant/deployment/files/home/vagrant/.gitconfig",
        require => [
          Package["git"],
        ],
      }
      # A user .gitignore_global file
      file { "/home/vagrant/.gitignore_global":
        mode => 0644,
        owner => vagrant,
        group => vagrant,
        source => "/vagrant/deployment/files/home/vagrant/.gitignore_global",
        require => [
          Package["git"],
        ],
      }

} 
