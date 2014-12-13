
include_recipe "apt"
include_recipe "git"

software_dir = node["dylansenv"]["software_dir"]
local_user   = node["dylansenv"]["local_user"]
local_group  = node["dylansenv"]["local_group"]

directory software_dir do
  owner local_user
  group local_group
end

# common packages / config that I like
%w{ git ruby ruby-dev tree mutt vim emacs yasnippet ldapscripts }.each do |p|
  package p
end
git "#{software_dir}/emacs" do
  repository "https://github.com/dylanvaughn/emacs.git"
  revision "master"
  action :checkout
  user local_user
  group local_group
end
dotemacs_content = "(setq shared-config-dir \"#{software_dir}/emacs/\") (load-file (concat shared-config-dir \"dotemacs.el\"))"
file "/home/#{local_user}/.emacs" do
  owner local_user
  group local_group
  content dotemacs_content
end
file "/root/.emacs" do
  owner "root"
  group "root"
  content dotemacs_content
end
