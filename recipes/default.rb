include_recipe "#{cookbook_name}::install"
if node['os'] == 'linux'
  include_recipe "#{cookbook_name}::logrotate"
end
