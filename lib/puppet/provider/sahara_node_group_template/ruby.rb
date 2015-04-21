require 'rubygems'
require 'openstack'
require File.join File.dirname(__FILE__), '../sahara_openstack.rb'

Puppet::Type.type(:sahara_node_group_template).provide(:ruby) do
    def connection
      return @connection if @connection
      debug "#{self} Call: connection"
      @connection = OpenStack::Connection.create({
                                      :username => @resource[:auth_username],
                                      :api_key => @resource[:auth_password],
                                      :auth_method =>"password",
                                      :auth_url => @resource[:auth_url],
                                      :authtenant_name => @resource[:auth_tenant_name],
                                      :service_type=>"data_processing",
                                      :is_debug => @resource[:debug],
                                  })
    end

    def extract
      debug "#{self} Call: extract"
      node_group_templates = connection.list_node_group_templates
      node_group_template = node_group_templates.find do |template|
        template.name == @resource[:name]
      end
      if node_group_template
        @property_hash = {
          :ensure => :present,
          :name => node_group_template.name,
          :description => node_group_template.description,
          :plugin_name => node_group_template.plugin_name,
          :flavor_id => node_group_template.flavor_id,
          :node_processes => node_group_template.node_processes,
          :floating_ip_pool => node_group_template.floating_ip_pool,
          :auto_security_group => node_group_template.auto_security_group,
        }
      else
        @property_hash = {
          :ensure => :absent,
        }
      end
      @property_hash
    end

    def exists?
      debug "#{self} Call: exists?"
      extract unless @property_hash.any?
      result = @property_hash[:ensure] == :present
      debug "Result: #{result}"
      result 
    end

    def description
      @property_hash[:description]
    end

    def plugin_name
      @property_hash[:plugin_name]
    end

    def flavor_id
      @property_hash[:flavor_id]
    end

    def node_processes
      @property_hash[:node_processes]
    end

    def floating_ip_pool
      @property_hash[:floating_ip_pool]
    end

    def auto_security_group
      @property_hash[:auto_security_group]
    end

    def description=(value)
      @property_hash[:description] = value
    end

    def plugin_name=(value)
      @property_hash[:plugin_name] = value
    end

    def flavor_id=(value)
      @property_hash[:flavor_id] = value
    end

    def node_processes=(value)
      @property_hash[:node_processes] = value
    end
    
    def floating_ip_pool=(value)
      @property_hash[:floating_ip_pool] = value
    end

    def auto_security_group=(value)
      @property_hash[:auto_security_group] = value
    end

    def destroy
      debug "#{self} Call: destroy"
      p @resource[:name]
    end

    def create
      debug "#{self} Call: create"
      @property_hash = {
        :name => @resource[:name],
        :description => @resource[:description],
        :plugin_name => @resource[:plugin_name],
        :flavor_id => @resource[:flavor_id],
        :node_processes => @resource[:node_processes],
        :floating_ip_pool => @resource[:floating_ip_pool],
        :auto_security_group => @resource[:auto_security_group],
      }
    end

    def flush
      debug "#{self} Call: flush"
       
      connection.create_cluster_template @property_hash
    end

end
