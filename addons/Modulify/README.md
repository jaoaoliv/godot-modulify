# Modulify – Godot Modular Character Toolkit

![Godot 4.x](https://img.shields.io/badge/godot-4.x-blue?logo=godot-engine)
![Plugin](https://img.shields.io/badge/type-editor%20plugin-orange)
![Status](https://img.shields.io/badge/status-experimental-brightgreen)
![Licença: CC BY-ND 4.0](https://img.shields.io/badge/license-CC--BY--ND%204.0-lightgrey)


## ✨ O que é?

**Modulify** é um plugin para Godot Engine 4.x que permite criar rapidamente personagens modulares, estruturados em States e Modules, com arquitetura plug-and-play inspirada nos melhores fluxos profissionais.

Ideal para:
- Prototipagem rápida de jogos com múltiplos personagens
- Projetos que usam máquinas de estado e modularização de mecânicas
- Estudo e ensino de Godot para times e iniciantes

---

## 🚀 Principais Recursos

- **Criação instantânea** de personagens com estrutura de pastas, cena, nodes (`States`, `Modules`) e scripts base (FSM e brain) já prontos.
- **Criação rápida de novos States e Modules** diretamente na cena aberta, com scripts `.gd` gerados automaticamente e comentários didáticos.
- **Totalmente integrado ao editor Godot**: nada de fazer setup manual!
- Templates prontos para States/Modules, facilitando aprendizado e expansão.
- Estrutura e comentários pensados para equipes e projetos escaláveis.

---

## 🛠️ Como usar

1. Instale o plugin (adicione a pasta `addons/modulify` ao seu projeto ou use via Godot AssetLib).
2. Ative o plugin em `Project Settings > Plugins`.
3. Clique no botão **Modulify** na barra superior do editor para abrir o dock lateral.
4. Use a **Aba 1** para criar personagens modulares do zero.
5. Abra a cena do personagem, vá para a **Aba 2** e crie novos States/Modules com scripts prontos para uso!

---

## 📦 Instalação

### Via Godot Asset Library (em breve!)

### Via GitHub/Manual

- Baixe este repositório.
- Copie a pasta `addons/modulify` para a pasta `addons` do seu projeto Godot.
- Ative o plugin nas configurações do projeto.

---

## 📚 Exemplos de Uso

### Ativando Plugin

- Após ativar o plugin nas configuraçoes do projeto ira aparecer um botão para ativar o plugin no canto superior direito da tela

![Exemplo Ativação do Plugin](https://raw.githubusercontent.com/jaoaoliv/godot-modulify/refs/heads/main/addons/Modulify/Icons/instructions/instructions1.png)

### Criando personagem modular
- Na aba "Criar Personagem" voce poderá escolher o nome do Personagem que será criado, assim esse nome sera o nome do nó raiz da sua cena que sera gerada automaticamente.
- Passo 1 - Digite o nome do Personagem a ser criado
- passo 2 - escolha a Perspectiva do seu personagem 
- Passo 3 - Clique no botao criar personagem e veja a magica acontecer!

--- Você terá uma cena criada com o nome do personagem escolhido e nela ja pos padrao como raiz um CharactherBody2D e os Nodes States e Modules. Todos os scripts ja estarao integrados aos nós corretamente!

--- NOTA: A opçao de escolha da Perspectiva nao altera até o momento nada no uso do plugin, futuramente teremos templates de modulos prontos como por exemplo: walk, run, jump. esses estarao disponiveis na proxima aba "States e Modules" para serem anexados automaticamente ao seu personagem assim agilizando seu trabalho.


![Exemplo de uso da Aba 1](https://raw.githubusercontent.com/jaoaoliv/godot-modulify/refs/heads/main/addons/Modulify/Icons/instructions/instructions2.png)

### Criando novos states/modules

- Na aba "States e Modules" você podera adicionar states e modules diretamente ao personagem que desejar, ja com scripts integrados para agilizar seu trabalho.

- Passo 1 - Abra a cena que deseja editar e verifique se o nome da cena aparece no topo da aba
- Passo 2 - Digite o nome do State/Module no campo correspondente e clique no botao Criar

--- Você verá que o State/Module foi adicionado diretamente como um Node (com o nome escolhido) como filho de States/Modules ja com o script integrado! Basta editar o conteudo dos scripts para funcionar como desejar!

![Exemplo de uso da Aba 2](https://raw.githubusercontent.com/jaoaoliv/godot-modulify/refs/heads/main/addons/Modulify/Icons/instructions/instructions3.png)

---

## 💡 Dicas

- Todos os scripts gerados estao bem comentados com detalhes do funcionamento!
- Novos módulos/estados aparecem imediatamente na cena – salve a cena para persistir.

---

## 📝 Licença

Este plugin está licenciado sob a licença [CC BY-ND 4.0](https://creativecommons.org/licenses/by-nd/4.0/deed.pt_BR).

- Você pode usar o plugin em projetos pessoais, acadêmicos e comerciais, desde que mantenha a autoria.
- Não é permitida a modificação ou redistribuição de versões alteradas.
- Para licenças especiais (suporte, customização), entre em contato: [seu email/contato].

## ☕ Apoie

Se quiser apoiar o projeto, você pode contribuir pelo [Itch.io](https://bitsouls-studios.itch.io) ou pela chave pix: bitsoulsstudios@gmail.com

---

## 🙋‍♂️ Sobre

Feito por [Jaoaoliv / Bitsouls Studios](https://jaoaoliv.github.io/bitsouls-portfolio/).  
Entre em contato, siga no [YouTube](https://www.youtube.com/@BitsoulsStudios) e [LinkedIn](https://www.linkedin.com/in/jaoaoliv-dev).

---

