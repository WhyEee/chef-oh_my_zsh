git "/usr/src/oh-my-zsh" do
  repository "https://github.com/robbyrussell/oh-my-zsh.git"
  reference "master"
  action :sync
end

Etc.passwd do |user|
  if user.shell.include? 'zsh'
    user_id = user.uid
    home = user.dir
  
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
