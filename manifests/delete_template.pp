sahara_node_group_template { 'test' :
  ensure => absent,
  description => 'test template',
  plugin_name => 'vanilla',
  flavor_id => '3',
  node_processes => ['datanode', 'nodemanager'],
  hadoop_version => '2.4.1',
  floating_ip_pool => '5710572c-cb2e-48e2-b0a0-dfa56daf1653',
  auto_security_group => true,

  auth_url => "http://192.168.0.4:5000/v2.0/",
  auth_username => "admin",
  auth_password => "admin",
  auth_tenant_name => "admin",
  debug => true,
}

