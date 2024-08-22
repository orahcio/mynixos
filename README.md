# mynixos

Arquivos para montar o NixOS no meu laptop Dell

Atualmente estou compilando com

```bash
nixos-rebuild switch --flake ".#goldenfeynman" --use-remote-sudo
```
para que o comando `sudo` seja executado apenas ao configurar os sistema, não na etapa de construção ou download das fontes.

O arquivo `flake.nix` fornece como entrada o repositório instável, o _home-manager_ e resolvi usar o módulo do gerenciador de pacotes _lix_ que é _fork_  do _nix_. Meu _home-manager_ não está independente do sistemas, futuramente acho que irei separar o _home-manager_ para não precisar do `rebuild` para fazer alterações nele.

Meus módulos são o do `lix`, dos configurações do sistema e do _home-manage_.

