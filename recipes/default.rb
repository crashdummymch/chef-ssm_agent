# deploy ssm agent on Linux or windows. Cosmin 07.2017

if node['platform'] == 'windows'
  include_recipe 'windows'
  include_recipe 'chef_handler'
  script_path = win_friendly_path(File.join(Chef::Config[:file_cache_path],'install_win_ssm.ps1'))
  install_ssm = 'install_win_ssm.ps1'
  execute install_ssm do
    command "powershell  -ExecutionPolicy ByPass -File \"#{script_path}\""
    action :nothing
  end
  cookbook_file script_path do
    source 'install_win_ssm.ps1'
    action :create
    notifies :run, "execute[#{install_ssm}]", :immediately
  end
else
    include_recipe "#{cookbook_name}::logrotate"
    remote_file 'amazon-ssm-agent' do
      path node['ssm_agent']['package']['path']
      source node['ssm_agent']['package']['url']
      checksum node['ssm_agent']['package']['checksum']
      mode 0644
    end
    package 'amazon-ssm-agent' do
      source node['ssm_agent']['package']['path']
      provider value_for_platform_family(
        'rhel' => Chef::Provider::Package::Yum,
        'amazon' => Chef::Provider::Package::Yum,
        'debian' => Chef::Provider::Package::Dpkg)
    end
    service node['ssm_agent']['service']['name'] do
      action node['ssm_agent']['service']['actions']
    end
end
