class sahara-puppet (
  $auth_user        = admin,
  $auth_password    = admin,
  $auth_tenant      = admin,
  $auth_url         = "http://192.168.0.1:5000/v2.0",
) {

  notify { "ololo":
  }

  sahara_template { 'cdh':
     network_provider => neutron,
     auth_url         => $auth_url,
     auth_username    => $auth_user,
     auth_password    => $auth_password,
     auth_tenant_name => $auth_tenant,
  }

}
