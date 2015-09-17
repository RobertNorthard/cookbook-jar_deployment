=begin
#<
 Implements jar_deployment resource.
#>
=end 

# Support whyrun
def whyrun_supported?
  true
end

def jar_name
  @new_resource.name
end

def jar_location
  @new_resource.jar_location
end

def deploy_directory
  @new_resource.deploy_directory
end

def log_directory
  @new_resource.log_directory
end

def jar_checksum
  @new_resource.jar_checksum
end

def java_version
  @new_resource.java_version
end

def jar_user
  @new_resource.jar_user
end

def jar_args
	@new_resource.jar_args
end 

# Deploy jar
action :deploy do

  # Create deploy directory
  directory deploy_directory do
    owner jar_user
    group jar_user
	 mode '0755'
	 recursive true
	 action :create
  end

  # Create deploy directory
  directory log_directory do
    owner jar_user
    group jar_user
	 mode '0755'
	 recursive true
	 action :create
  end

  remote_file "#{deploy_directory}/#{jar_name}.jar" do
    source jar_location
    owner jar_user
    group jar_user
    checksum checksum
    mode '0755'
    action :create
  end

  # Template service script
  template "/etc/init.d/#{jar_name}" do
    source 'service.init.d.erb.rb'
    owner user
    group user
    variables ({
    	name: jar_name,
    	user: jar_user,
    	deploy_directory: deploy_directory,
    	log_directory: log_directory
    })
    mode '0755'
    notifies :restart, "service[#{jar_name}]", :delayed
  end

  # Start service
  service jar_name do
  	action [:enable, :start]
  end

  new_resource.updated_by_last_action(false)
end

# Delete deployed jar
action :delete do

  # Stop service first
  service jar_name do
  	action :stop
  end

  [
  	"#{deploy_directory}/#{jar_name}.jar",
  	"/etc/init.d/#{jar_name}"
  ].each do |res|
    file res do
      action :delete
    end
  end

end
