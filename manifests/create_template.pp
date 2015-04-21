sahara_node_group_template { 'test' :
  ensure => present,
  description => 'test template',
  plugin_name => 'vanilla',
  flavor_id => 'm1.medium',
  node_processes => ['datanode', 'nodemanager'],
  hadoop_version => '2.4.1',
  floating_ip_pool => 'router04',
  auto_security_group => true,

  auth_url => "http://192.168.0.4:5000/v2.0/",
  auth_username => "admin",
  auth_password => "admin",
  auth_tenant_name => "admin",
  debug => true,
}

