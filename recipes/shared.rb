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
      variables theme: node.oh_my_zsh.theme,
                case_sensitive: node.oh_my_zsh.case_sensitive,
                auto_update: node.oh_my_zsh.auto_update,
                ls_colors: node.oh_my_zsh.ls_colors,
                auto_title: node.oh_my_zsh.auto_title,
                plugins: node.oh_my_zsh.plugins
      owner user_id
      group user_id
      action :create_if_missing
    end
  end
end
