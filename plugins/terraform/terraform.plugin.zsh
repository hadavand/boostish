if (( $+commands[terraform] )); then
  alias tf='terraform'
  alias tfi='terraform init'
  alias tfir='terraform init -reconfigure'
  alias tfiu='terraform init -upgrade'
  alias tfiur='terraform init -upgrade -reconfigure'
  alias tfp='terraform plan'
  alias tfpo='terraform plan -out tfplan'
  alias tfa='terraform apply'
  alias tfapp='terraform apply tfplan'
  alias tfc='terraform console'
  alias tfd='terraform destroy'
  alias tff='terraform fmt'
  alias tffr='terraform fmt -recursive'
  alias tfv='terraform validate'
  alias tfo='terraform output'
  alias tfs='terraform state'
  alias tft='terraform test'
  alias tfsh='terraform show'
  alias tfw='terraform workspace'
  alias tfwl='terraform workspace list'
  alias tfws='terraform workspace select'

  autoload -Uz bashcompinit
  bashcompinit

  complete -o nospace -C "${commands[terraform]}" terraform
  complete -o nospace -C "${commands[terraform]}" tf
fi
