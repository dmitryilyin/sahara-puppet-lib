Sahara_node_group_template {
  ensure => present,
  auth_url => "http://192.168.0.8:5000/v2.0/",
  auth_username => "admin",
  auth_password => "admin",
  auth_tenant_name => "admin",
  debug => true,
}

Sahara_cluster_template {
  ensure => present,
  auth_url => "http://192.168.0.8:5000/v2.0/",
  auth_username => "admin",
  auth_password => "admin",
  auth_tenant_name => "admin",
  debug => true,
}

Sahara_node_group_template<||> -> Sahara_cluster_template<||>

sahara_node_group_template { 'master' :
  description => 'test template',
  plugin_name => 'vanilla',
  flavor_id => 'm1.medium',
  node_processes => ['datanode', 'nodemanager'],
  hadoop_version => '2.4.1',
  floating_ip_pool => 'router04',
  auto_security_group => true,
}

sahara_node_group_template { 'worker' :
  description => 'test template',
  plugin_name => 'vanilla',
  flavor_id => 'm1.medium',
  node_processes => ['datanode', 'nodemanager'],
  hadoop_version => '2.4.1',
  floating_ip_pool => 'router04',
  auto_security_group => true,
}

sahara_node_group_template { 'manager' :
  description => 'test template',
  plugin_name => 'vanilla',
  flavor_id => 'm1.medium',
  node_processes => ['datanode', 'nodemanager'],
  hadoop_version => '2.4.1',
  floating_ip_pool => 'router04',
  auto_security_group => true,
}

sahara_cluster_template { 'test' :
  description => 'test template',
  plugin_name => 'vanilla',
  node_groups => [
    {'name' => 'manager', 'count' => 1},
    {'name' => 'master', 'count' => 1},
    {'name' => 'worker', 'count' => 1}
  ],
  hadoop_version => '2.4.1',
  neutron_management_network => 'net04',
}
