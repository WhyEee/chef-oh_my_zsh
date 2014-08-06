#
# Cookbook Name:: oh-my-zsh
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "git"
include_recipe "zsh"

git "/usr/src/oh-my-zsh" do
  repository "https://github.com/robbyrussell/oh-my-zsh.git"
  reference "master"
  action :sync
end

Etc.passwd do |user|
  if user.shell.include? 'zsh'
    user_name = user.name
    home = user.dir
  
    link "#{home}/.oh-my-zsh" do
      to "/usr/src/oh-my-zsh"
      not_if "test -d #{home}/.oh-my-zsh"
    end
  
    template "#{home}/.zshrc" do
      source "zshrc.erb"
      variables theme: node.oh_my_zsh.theme,
                case_sensitive: node.oh_my_zsh.case_sensitive,
                auto_update: node.oh_my_zsh.auto_update,
                update_prompt: node.oh_my_zsh.update_prompt,
                ls_colors: node.oh_my_zsh.ls_colors,
                auto_title: node.oh_my_zsh.auto_title,
                plugins: node.oh_my_zsh.plugins
      owner user_name
      group user_name
      action :create_if_missing
    end
  end
end
