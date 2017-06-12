---
title: 'Jest - Testar seu código Javascript nunca foi tão fácil!'
date: 2017-30-05
category: front-end
layout: post
description:
author: leonardosouza
tags:
  - javascript
  - front-end
  - tests
  - tdd
---

Trabalhar com desenvolvimento de software é algo que está longe de ser fácil, pois além da parte técnica (que evolui a passadas largas), todo profissional precisa estar minimamente antenado a ponto de perceber qual das suas posturas em relação a execução de suas atividades podem literalmente travá-lo (dentro da carreira) ou levá-lo a outro patamar. Dentre as muitas características valorizadas atualmente pelo mercado, uma importantissíma é ser um profissional adepto a mudanças, pelo simples fato que **o mundo muda** muito rapidamente, e o jeito que trabalhavámos no passado já não serve e/ou se encaixa com o presente.

Fazendo uma breve reflexão sobre isso, eu me lembro de uma época onde a minha maior gana era produzir o máximo de código que conseguisse por dia. Para mim a efetividade do trabalho e percepção de valor do mesmo estava intrinsecamente ligada a **quantidade de código** que eu escrevia e não exatamente a **qualidade deste código**.

Então posso dizer que já "fui um desses"... um cara que rapidamente escrevia uma funcionalidade enorme, com trezentas e tantas linhas de código e no momento que julgava estar com tudo pronto abria meu navegador para então executar os meus testes **(manuais)** no software que acabara de construir. E era ai que iniciava-se um ciclo, onde eu encontrava alguns bugs, corrigia-os e testava tudo novamente! Então novos bugs eram encontrados, fazia outras tantas correções até que pá... o produto estava **finalmente pronto** (pelo menos no meu ponto de vista) para ir pra produção. Agora o caminho natural era apenas esperar a validação final do meu trabalho, que seria feita por outro profissional, o famigerado Analista de Qualidade (ou QA).

Esta passagem da minha história neste mercado é mais comum do que parece, então não ache estranho se isso lhe soou familiar, pois certamente ela deve acontecer até hoje com muitos desenvolvedores por ai (e isso pode até incluir você). Desta forma, acho que vale ressaltar aqui que estamos em um outro momento, onde o desenvolvimento de software amadureceu e a realidade é que atualmente não basta apenas escrever software. Arregaçar as mangas e implementar **os testes**, com foco total na **qualidade** do que se está produzindo é primordial.

## Começando com testes automatizados

Ninguém (ou a maioria dos desenvolvedores que conheço) gosta de testar software pelo simples fato de que executar uma bateria de testes de forma manual é extremamente cansativo. Com isso, nós desenvolvedores criamos o péssimo hábito de testar superficialmente tudo que produzimos, e pela força dos processos inseridos nas empresas acabamos delegando para um terceiro a responsabilidade de testar o que acabamos de desenvolver. Mudar essa realidade é complicado, mais não impossível, e certamente a melhor maneira de resolver isto é torná-la um processo natural e agradável ao desenvolvedor. Agora meu caro eu te pergunto: que tal utilizar o seu melhor skill (que é programar) para tornar os processos de teste manuais em rotinas automatizadas? Parece uma boa não? Pois bem, esse será nosso desafio daqui para frente.

Para quem está iniciando nesta jornada, a curva de aprendizado pode parecer um tanto que assutadora e o maior desafio sem dúvida neste ponto é equalizar a sua aparente **falta de conhecimento sobre o tema** a uma nova **filosofia que guiará todo o seu processo de trabalho**. Somado a isso, surgirão uma série de decisões que você precisará tomar para a saída do que eu costumo chamar de "zero absoluto". As perguntas que certamente vem a tona neste momento são: **por onde devemos começar e qual caminho deve-se seguir???**

Bom eu acredito que o principal objetivo inicialmente seja conseguir configurar corretamente uma **stack mínima para rodar seus testes**. Para isso, existe uma quantidade razoável de **perguntas** que precisam **respostas** afim de nortear o que deve ser feito. Veja se elas fazem sentido para você:

- Que tipo de teste eu preciso para o meu software? **Unitário**, de **Integração** ou de **Aceitação**?

- Qual mindset eu deveria utilizar para guiar os meus testes? **TDD**, **BDD** ou um **misto de ambos**?

- Qual biblioteca para de asserção (**expect/should/assertion**) deveria ser empregada?

- E testes que dependem de **respostas assíncronas**? Como tratar estes casos? **Spies, stubs e mocks** seriam uma opção?

- Será que além dos testes, seria interessante ter uma idéia sobre o **percentual de cobertura** de tudo que estava sendo testado?

Analisando as perguntas e as prováveis respostas, eu consegui encontrar muitas ferramentas que usuria para responder cada uma delas:

- **Mocha**, **Jasmine**, ... (testing frameworks)

- **Chai.js**, **Should.js**, ... (para expect/shoud/assetion)

- **Sinon.js**, **TestDouble.js**, ... (para spies, stubs e mocks)

- **Istanbul.js**, **Blanket.js**, **JsCover**, ... (para code coverage)

Hummm... bom chegando neste ponto, deu para perceber que existe um certo nível de complexidade para configurar este stack. O simples fato de decidir quais ferramentas utilizar (caso alguma escolha não seja a mais acertada) pode trazer consequências futuras para a manutenabilidade dessa stack, umav ez que trocar uma peça que não funcione tão bem pode impactar em uma quantidade significativa de testes já escritos.


## Nossa que complexo, quero desistir!

É meu amigo, se você chegou até esse ponto deste post, já deve ter sacado o tamanho da dor que é simplemente configurar um stack para testes. Com tantas opções e decisões para serem tomadas, isso por si só já seria o suficiente para ser postergado ao infinito e tornar-se então o famoso débito técnico do seu projeto.

A parte boa, é que era exatamente isso que você precisava fazer até ontem, pois o hoje é um belo dia e você já tem opções bem mais elegantes para execução dos seus testes. Então não desista, pois daqui pra frente você vai poder focar no melhor do seu trabalho, que é escrever testes e produzir código de qualidade, sem se preocupar com essa barrreira de entrada!

## Jest FTW!

Jest é um projeto open-source para testes Javascript mantido pelo Facebook, que nasceu com uma filosofia ímpar: prover a seus usuários uma stack completa de testes com zero esforço de configuração.

Além desta marcante característica, ele possui algumas outras, como:

- **Feedback instantâneo** - monitora alteração nos seus arquivos, e assim que percebe uma mudança dispara os testes

- **Geração de snapshots** - em aplicações escritas em React, snapshots podem ser gerados para confrontar mudanças que quebrem a interface final do usuário

- **Ultra Rápido** - testes rodam paralelamente sem interferir um nos outros

- **Code Coverage** - no Jest, o relatório de cobertura de código é embutido e habilitado através de uma simples flag

Parece bom demais pra ser verdade né!? Mais acredite, isso vai facilitar e muito a sua vida.

## Ah não pode ser... venha Jest, que hoje quero lhe usar!!!

Começar a escrever seus testes com Jest é realmente muito fácil. A seguir vou lhe descrever os passos necessários para deixar tudo funcionando.

Vamos começar, **instalando o Jest**. Neste ponto é importante que você entenda que o Jest é distruído como um módulo da plataforma **node.js**. Portanto é vital certificar-se que este último está instalado. Você pode abrir seu terminal e digitar o seguinte comando para isso:

```bash
node -v
```

Se tudo estiver certo o número versão instalada do **node.js** no seu computador será exibida! Caso negativo, você pode dar uma olhadinha neste site (https://nodejs.org/en/download/) e proceder com o processo de instalação de acordo com o seu sistema operacional preferido.

Além da plataforma instalada, precisamos de outra ferramenta para gerenciamento dos módulos. Aqui temos 2 opções, o bom e velho **npm** ou o novissímo **yarn**.

Neste post, nossa opção para gerenciamento dos módulos será feita pelo **yarn**. Então antes de continuarmos, você precisa garantir que ele esteja instalado no seu ambiente, processo que é muito simples, bastando rodar o seguinte comando (caso você for usuário da plataforma macOS):

```bash
brew install yarn
```

**Dica 1**: caso você seja usuário macOS e não tenha o **Homebrew** instalado em seu ambiente a intrução anterior falhará. Caso isto ocorra, rode o seguinte comando e tente novamente:

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

**Dica 2**: caso você não seja um usuário macOS, sabia que o **yarn** está disponível para todas os principais sistemas operacionais. Caso você seja usuário de outras plataformas confira o processo de instalação neste site (https://yarnpkg.com/pt-BR/docs/install)

Ufa! Agora sim, vamos finalmente instalar o Jest!

## O processo de instalação

Com os pré-requisitos acertados, a instalação é mole, se liga:

Abra seu terminal e crie uma pasta, acessando-a em seguida:

```bash
mkdir elo7-jest-demo && cd elo7-jest-demo
```

Agora instale o Jest usando o **yarn**:

```bash
yarn add jest
```

Após rodar este comando, você pode conferir o conteúdo deste diretório e encontrará a seguinte estrutura:

```bash
├── package.json
├── yarn.lock
└── node_modules
```

Feito isso, vamos alterar nosso arquivo `package.json`, adicionando a chave `test` com o valor `jest` dentro do objeto `scripts`. Desta forma:

```json
{
  "scripts": {
    "test": "jest"
  },
  "dependencies": {
    "jest": "^20.0.4"
  }
}
```

Essa alteração importante no `package.json` serve para registrar uma espécie de atalho para execução dos seus testes. Ele será bastante útil logo abaixo!
