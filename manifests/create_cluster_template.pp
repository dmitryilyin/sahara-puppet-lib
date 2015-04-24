sahara_cluster_template { 'test' :
  ensure => present,
  description => 'test template',
  plugin_name => 'vanilla',
  node_groups => [
    {'name' => 'manager', 'count' => 1},
    {'name' => 'master', 'count' => 1},
    {'name' => 'worker', 'count' => 1}
  ],
  hadoop_version => '2.4.1',
  neutron_management_network => 'net04',

  auth_url => "http://192.168.0.8:5000/v2.0/",
  auth_username => "admin",
  auth_password => "admin",
  auth_tenant_name => "admin",
  debug => true,
}

