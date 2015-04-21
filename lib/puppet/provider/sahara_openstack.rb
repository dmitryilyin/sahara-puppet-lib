module OpenStack
  module Sahara
    class Cluster_Template

    attr_reader :id
    attr_reader :name
    attr_reader :hadoop_version
    attr_reader :neutron_management_network
    attr_reader :description
    attr_reader :node_groups

    def initialize(ct_info)
      @id  = ct_info['id']
      @name  = ct_info['name']
      @hadoop_version = ct_info['hadoop_version']
      @neutron_management_network = ct_info['neutron_management_network']
      @description = ct_info['description']
      @node_groups = ct_info['node_groups']
    end

    end
  end
end

module OpenStack
  module Sahara
    class Node_Group_Template

      attr_reader :id
      attr_reader :name
      attr_reader :description
      attr_reader :plugin_name
      attr_reader :flavor_id
      attr_reader :node_processes
      attr_reader :floating_ip_pool
      attr_reader :auto_security_group

      def initialize(ngt_info)
        @id = ngt_info['id']
        @name = ngt_info['name']
        @description = ngt_info['description']
        @plugin_name = ngt_info['plugin_name']
        @flavor_id = ngt_info['flavor_id']
        @node_processes  = ngt_info['node_processes']
        @floating_ip_pool = ngt_info['floating_ip_pool']
        @auto_security_group = ngt_info['auto_security_group']
      end

    end
  end
end

module OpenStack
  module Sahara

    class Connection

      attr_accessor   :connection

      def initialize(connection)
        @connection = connection
        OpenStack::Authentication.init(@connection)
      end

      def authok?
        connection.authok
      end

      def node_group_template_url(node_group_template_id = nil)
        url = '/node-group-templates'
        url += "/#{node_group_template_id}" if node_group_template_id
        url
      end

      def list_node_group_templates
        response = connection.req('GET', node_group_template_url)
        volumes_hash = JSON.parse(response.body)['node_group_templates']
        volumes_hash.inject([]) { |res, current| res << OpenStack::Sahara::Node_Group_Template.new(current); res}
      end

      def get_node_group_template(node_group_template_id)
        response = connection.req('GET', node_group_template_url(node_group_template_id))
        volume_hash = JSON.parse(response.body)['node_group_template']
        return unless volume_hash
        OpenStack::Sahara::Node_Group_Template.new volume_hash
      end

      def create_node_group_template(options)
        # check input data
        data = JSON.generate(options)
        response = connection.csreq('POST',
                                     connection.service_host,
                                     "#{connection.service_path}#{node_group_template_url}",
                                     connection.service_port,
                                     connection.service_scheme,
                                     {
                                         'content-type' => 'application/json',
                                     },
                                     data
        )
        OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
        node_group_template_info = JSON.parse(response.body)['node_group_template']
        OpenStack::Volume::Volume.new node_group_template_info
      end

      def delete_node_group_template(node_group_template_id)
        connection.req('DELETE', node_group_template_url(node_group_template_id))
        true
      end

############################################################################

      def cluster_template_url(cluster_template_id = nil)
        url = '/cluster-templates'
        url += "/#{cluster_template_id}" if cluster_template_id
        url
      end

      def list_cluster_templates
        response = connection.req('GET', cluster_template_url)
        cluster_templates_hash = JSON.parse(response.body)['cluster_templates']
        cluster_templates_hash.inject([]) { |res, current| res << OpenStack::Sahara::Cluster_Template.new(current); res}
      end

      def get_cluster_template(cluster_template_id)
        response = connection.req('GET', cluster_template_url(cluster_template_id))
        cluster_template_hash = JSON.parse(response.body)['cluster_template']
        return unless cluster_template_hash
        OpenStack::Sahara::Cluster_Template.new cluster_template_hash
      end

      def create_cluster_template(options)
        # check input data
        data = JSON.generate(options)
        response = connection.csreq('POST',
                                     connection.service_host,
                                     "#{connection.service_path}#{cluster_template_url}",
                                     connection.service_port,
                                     connection.service_scheme,
                                     {
                                         'content-type' => 'application/json',
                                     },
                                     data
        )
        OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
        cluster_template_info = JSON.parse(response.body)['cluster_template']
        OpenStack::Volume::Volume.new cluster_template_info
      end

      def delete_cluster_template(cluster_template_id)
        connection.req('DELETE', cluster_template_url(cluster_template_id))
        true
      end

    end

  end
end

module OpenStack
  class << Connection
    def create(options = {:retry_auth => true})
      #call private constructor and grab instance vars
      connection = new(options)
      case connection.service_type
        when 'compute'
          OpenStack::Compute::Connection.new(connection)
        when 'object-store'
          OpenStack::Swift::Connection.new(connection)
        when 'volume'
          OpenStack::Volume::Connection.new(connection)
        when 'image'
          OpenStack::Image::Connection.new(connection)
        when 'network'
          OpenStack::Network::Connection.new(connection)
        when 'data_processing'
          OpenStack::Sahara::Connection.new(connection)
       else
          raise Exception::InvalidArgument, "Invalid :service_type parameter: #{@service_type}"
      end
    end
  end
end
