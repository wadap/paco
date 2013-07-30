#
# Cookbook Name:: paco
# Recipe:: default
#
# Copyright 2013, wadap
#
# All rights reserved - Do Not Redistribute
#

%w(gcc-c++).each do |v|
  package v do
    action :install
    not_if "yum list installed #{v}"
  end
end

download_file = "#{Chef::Config[:file_cache_path]}/#{File.basename(node.paco.source)}"
remote_file download_file do
  source node.paco.source
  owner "root"
  group "root"
  mode  "0644"

  not_if "which paco"
  not_if do
    FileTest.file? download_file
  end
end

script "install paco" do
  interpreter "bash"
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  tar xf #{node.paco.package}.tar.gz && cd #{node.paco.package}
  ./configure --disable-gpaco
  make && make install
  make logme
  EOH
  not_if "which paco"
end
