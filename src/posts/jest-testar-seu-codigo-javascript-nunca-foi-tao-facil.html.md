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

Trabalhar com desenvolvimento de software é algo que está longe de ser fácil, pois além da parte técnica (que evolui a passadas largas), todo profissional precisa estar minimamente antenado a ponto de perceber qual das suas posturas em relação a execução de suas atividades podem literalmente travá-lo (dentro da carreira) ou levá-lo a outro patamar. Dentre as muitas características valorizadas atualmente pelo mercado, o simple fato de ser um profissional adepto a mudanças é quase que primordial, pelo simples fato que **o mundo muda** muito rapidamente, e o jeito que trabalhavámos no passado já não serve e/ou se encaixa com o presente.

Fazendo uma breve reflexão sobre isso, eu me lembro de uma época onde a minha maior gana era produzir o máximo de código que conseguisse por dia. Para mim a efetividade do trabalho e percepção de valor do mesmo estava intrinsecamente ligada a **quantidade de código** que eu escrevia e não exatamente a **qualidade deste código**.

Então posso dizer que já "fui um desses"... um cara que rapidamente escrevia uma funcionalidade enorme, com trezentas e tantas linhas de código e no momento que julgava estar com tudo pronto abria meu navegador para então executar os meus testes **(manuais)** no software que acabara de construir. E era ai que iniciava-se um ciclo, onde eu encontrava alguns bugs, corrigia-os e testava tudo novamente! Então novos bugs eram encontrados, fazia outras tantas correções até que pá... o produto estava **finalmente pronto** (ou quase) para ir pra produção. Agora era só esperar que um outro profissional (o QA) fizesse os testes finais e aprovasse meu trabalho.

Esta breve passagem da minha história neste mercado é mais comum do que parece. Certamente ela deve acontecer até hoje com muitos desenvolvedores por ai. É importante dismistificar a questão e aceitar que a realidade atual é outra, para que todos percebam que não basta apenas escrever software. Arregaçar as mangas e implementar **os testes**, com foco total na **qualidade** do software que se está produzindo é primordial.

## Começando com testes automatizados

Ninguém (ou a maioria dos desenvolvedores que conheço) gosta de testar software pelo simples fato de que executar uma bateria de testes de forma manual é extremamente cansativo. Com isso, os desenvolvedores criaram o péssimo hábito de testar superficialmente o que produzem, delegando para um terceiro a responsabilidade de testar o que foi desenvolvido. A única maneira de tornar esse processo agradável a um desenvolver é fazer com que ele utilize as ferramentas que está acostumado. Então fazendo-se uso da programação, naturalmente o que antes era manual agora será automatizado.

Na teoria isso parece fantástico mesmo e faz todo sentido. Mais não é bem assim, pois começar a **testar software de forma automatizada** no fundo é difícil e um tanto assustador.

Dentre os primeiros desafios, o mais evidente era a minha **significativa falta de conhecimento sobre o tema**. De uma hora para outra eu estava sendo confrontando com uma nova filosofia que simplesmente guiaria todo o meu processo de trabalho. Além de aceitar essa mudança eu ainda precisava tomar algumas decisões para sair do zero absoluto e a principal pergunta que fazia a mim mesmo era: **qual caminho devo seguir?**

Após um bucado de pesquisas que fiz a respeito do assunto eu consegui mapear as **perguntas** que precisavam de **respostas** para que meu primeiro grande objetivo fosse alcançado. Minha meta era simples, dadas as perguntas, as respostas iriam nortear como eu deveria configurar corretamente uma **stack mínima para rodar meus testes**:

- Que tipo de teste eu preciso para o meu software? **Unitário**, de **Integração** ou de **Aceitação**?

- Qual mindset eu deveria utilizar para guiar os meus testes? **TDD**, **BDD** ou um **misto de ambos**?

- Qual biblioteca para **expect/should/assertion** deveria ser empregada?

- E testes que dependiam de **respostas assíncronas**? Como tratar estes casos? **Spies, stubs e mocks** seriam uma opção?

- Se sim, qual ferramenta então eu deveria utilizar?

- Será que além dos testes, seria interessante ter uma idéia sobre o **percentual de cobertura** de tudo que estava sendo testado?

Analisando as perguntas e as prováveis respostas, eu consegui encontrar muitas ferramentas que usuria para responder cada uma delas:

- **Mocha**, **Jasmine**, ... (testing frameworks)

- **Chai.js**, **Should.js**, ... (para expect/shoud/assetion)

- **Sinon.js**, **TestDouble.js**, ... (para spies, stubs e mocks)

- **Istanbul.js**, **Blanket.js**, **JsCover**, ... (para code coverage)

Bom, chegando neste ponto, eu percebi o quanto eu estava enrascado. Pois uma mudança de estratégia, depois das escolahs feitas e que todos os os testes estivessem escritos seria um tanto que desastrosa.

## Nossa que complexo, quero desistir!

É meu amigo, se você chegou até esse ponto deste post, já deve ter sacado o tamanho da dor que é simplemente configurar o seu stack de testes. Com tantas opções e decisões para serem tomadas, isso por si só já seria o suficiente para ser postergado ao infinito e tornar-se então o famoso débito técnico do seu projeto.

A parte boa, é que era exatamente isso que você precisava fazer até ontem, pois o hoje é belo e você já tem opções bem mais elegantes para executar os seus testes. Então não desista, pois daqui pra frente você vai poder focar no melhor do seu trabalho, que é escrever testes e produzir código de qualidade!

## Jest FTW!

Jest é um projeto open-source para testes Javascript mantido pelo Facebook, que nasceu com uma filosofia ímpar: prover a seus usuários  uma stack completa de testes com zero esforço de configuração.

Além desta marcante característica, ele possui algumas outras, como:

- **Feedback instantâneo** - monitora alteração nos seus arquivos, e assim que percebe uma mudança dispara os testes

- **Geração de snapshots** - em aplicações escritas em React, snapshots podem ser gerados para confrontar mudanças que quebrem a interface final do usuário

- **Ultra Rápido** - testes rodam paralelamente sem interferir um nos outros

- **Code Coverage** - no Jest, o relatório de cobertura de código é embutido e habilitado através de uma simples flag

Parece bom demais pra ser verdade né!? Mais acredite, isso vai facilitar e muito a sua vida.

## Ah não pode ser... venha Jest, que hoje quero lhe usar!!!

Começar a escrever seus testes com Jest é realmente muito fácil. A seguir vou lhe descrever os passos necessários para deixar tudo funcionando.

Vamos começar, **instalando o Jest**. Neste ponto é importante que você entenda que o Jest é distruído como um pacote da plataforma **node.js**. Portanto é vital certificar-se que este último está instalado. Você pode abrir seu terminal e digitar o seguinte comando para isso:

```bash
node -v
```

Se tudo estiver certo o número versão instalada do **node.js** no seu computador será exibida! Caso negativo, você pode dar uma olhadinha neste site (https://nodejs.org/en/download/) e proceder com o processo de instalação.

Neste ponto temos duas opções, podemos usar o bom e velho **npm** ou o novissímo **yarn**. Independente da escolha, saiba que ambas opções tem o mesmo papel, que é o gerenciamento dos módulos do **node.js**.

Neste post, nossa opção para gerenciamento será o **yarn**. Antes de continuar, você precisa garantir que ele esteja instalado no seu ambiente, processo que é muito simples, bastando rodar o seguinte comando (caso você for usuário da plataforma macOS):

```bash
brew install yarn
```

**Dica 1**: o **yarn** está disponível para todas os principais sistemas operacionais. Caso você seja usuário desses sistemas pode conferir o processo de instalação neste site (https://yarnpkg.com/pt-BR/docs/install)

**Dica 2**: caso você seja usuário macOS e mesmo assim não tenha o **Homebrew** instalado em seu ambiante, você pode executar o seguinte comando:

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

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

Feito isso, vamos alterar nosso arquivo `package.json`, adicionando a seguinte seção scripts dentro do mesmo, ele deve ficar com esta forma:

```javascript
{
  "scripts": {
    "test": "jest"
  },
  "dependencies": {
    "jest": "^20.0.4"
  }
}
```
