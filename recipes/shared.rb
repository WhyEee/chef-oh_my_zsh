git "/usr/src/oh-my-zsh" do
  repository "https://github.com/robbyrussell/oh-my-zsh.git"
  reference "master"
  action :sync
end

node['etc']['passwd'].each do |user, data|
  if data['shell'].include? 'zsh'
    user_id = data['uid']
    home = data['dir']
  
    link "#{home}/.oh-my-zsh" do
      to "/usr/src/oh-my-zsh"
      not_if "test -d #{home}/.oh-my-zsh"
    end
  
    template "#{home}/.zshrc" do
      source "zshrc.erb"
      owner user_id
      group user_id
      variables theme: node[:ohmyzsh][:theme]
      action :create_if_missing
    end
  end
end
