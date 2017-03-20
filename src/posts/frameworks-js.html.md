---
title: 'Frameworks JS'
date: 2016-11-08
category: front-end
layout: post
description: quando devemos utilizar um framework js e como escolher
author: williammizuta
tags:
  - JavaScript
  - Frameworks JS
  - Vanilla
  - jQuery
  - Zepto
  - AngularJS
  - Ember
  - Backbone
  - React
  - Vue.js
---

Recenetemente, temos ouvido cada vez mais sobre frameworks js, tanto os que já existem há algum tempo como os que acabaram de surgir: [jQuery](https://jquery.com/), [Zepto](http://zeptojs.com/), [Ember](http://emberjs.com/), [Backbone](http://backbonejs.org/), [AngularJS](https://angular.io/), [React](https://facebook.github.io/react/), [Vue.js](https://vuejs.org/)... Mas será que precisamos usar algum deles? Se sim, qual devemos escolher para nossa aplicação? Neste post, vou apresentar porque no Elo7 decidimos por não adotar nenhum desses frameworks e quais as suas consequências.

## O que são Frameworks js e para que servem?

Com o desenvolvimento de diversos sites, os desenvolvedores front-end se depararam com diversos problemas em comum que precisavam ser resolvidos a cada novo projeto que se iniciava. Um exemplo disso é a necessidade de dar suporte a navegadores que possuem APIs JavaScript distintas.

Para resolver este problema, um dos Frameworks mais famosos e mais utilizados no mercado surgiu: o jQuery. Além de permitir que o desenvolvedor escreva um código que funcione numa gama enorme de navegadores, ele também trouxe uma API mais amigável.

Com o passar do tempo, o mercado altera junto com as necessidades do usuário. E dessa maneira, surgem novas necessidades para os desenvolvedores implementarem e, logo, novos problemas vão surgindo. Com isso, novos frameworks são criados para resolver determinados problemas. É por isso que tem aparecido novos frameworks a cada dia.

## Quais as desvantagens dos Frameworks js?

Como toda decisão técnica que tomamos, a escolha de um framework traz suas vantagens e desvantagens. As vantagens já falamos que está relacionado com a não necessidade de resolver problemas comuns, ou seja, não precisamos reinventar a roda para cada projeto. Mas, os frameworks também tem suas desvantagens.

Uma das principais desvantagens que todo framework front-end traz é em relação à carga inicial que o framework traz no carregamento inicial do site. Para visualizar um site, o usuário precisa baixar todos os assets necessários: html, css, js, fontes e imagens. Quanto maior for o framework, mais banda consumimos do usuário. E muitas vezes, o site fica inoperante e até em branco enquanto o framework não é baixado e executado.

Por exemplo, a versão minificada com compressão gzip do [jQuery 3.1.1](https://code.jquery.com/jquery-3.1.1.min.js) tem 34.6kb; do [AngularJS 1.6.1](https://ajax.googleapis.com/ajax/libs/angularjs/1.6.1/angular.min.js), 56.9kb e do [React](https://unpkg.com/react@15.4.0/dist/react.min.js) junto com o [React DOM](https://unpkg.com/react-dom@15.4.0/dist/react-dom.min.js) 15.4.0, 44,3kb. Isso se não adicionarmos nenhum plugin e sem contar o código JS que precisamos adicionar para executar a nossa lógica.

Como cada vez mais os usuários têm acessado os sites utilizando os celulares, dependemos das redes móveis dos usuários para baixar os frameworks. Simulando uma conexão 3G normal com 100ms de latência e 750kb/s de velocidade de Download no devtools do Chrome fazendo o download da versão minificada na CDN de cada um dos projetos obtivemos o seguinte resultado:

| Framework        | Tamanho | Tempo   |
|------------------|--------:|--------:|
| jQuery 3.1.1     | 34,6 kb |  536 ms |
| Zepto 1.2.0      | 10,8 kb |  263 ms |
| Ember 2.10.2     |  514 kb | 5660 ms |
| Backbone 1.3.3   |  8,7 kb |  245 ms |
| Angular 1.6.1    | 56,9 kb |  736 ms |
| React 15.4.0     |  7,3 kb |  179 ms |
| React DOM 15.4.0 | 37,0 kb |  504 ms |
| Vue.js 2.1.8     | 28,7 kb |  405 ms |

Além disso, precisamos pensar na execução do código: todo código vai ocupar memória e utilizar o processador para executar. Quanto maior e mais complexo for, mais recurso ele utilizará do dispositivo do celular. Se não for muito bem pensando, o site pode passar a sensação de "travado", pois o processamento é pesado para o dispositivo que o usuário está usando.

E se você deseja que o conteúdo do seu site seja indexado pelos sites de busca (SEO), o conteúdo precisa estar disponível mesmo que o JavaScript da página não rode. Assim, você não depende dos "bots" conseguirem rodar JavaScript para ser possível ler o conteúdo do seu site. Lembrando que o tempo de carregamento é um critério de SEO. Ou seja, quanto mais tempo demorar para carregar a página, menor a chance do seu site aparecer na busca.

## Quando devemos utilizar um Framework js e qual escolher?

Ao iniciar um projeto, todo desenvolvedor pensa em qual a arquitetura deverá utilizar junto com os frameworks. Essa escolha geralmente é feita seguindo alguma das seguintes formas: utilizar a mesma arquitetura do projeto anterior, escolher a arquitetura que é mais utilizada no momento ou a última arquitetura comentada na comunidade. Mas será que essas são as melhores formas de escolher a base do projeto?

Como mencionado anteriormente, os Frameworks js foram desenvolvidos para resolver alguns problemas que vários sites se depararam. Mas não significa que todo o projeto vai ter os mesmos problemas. Então, eu acho que o mais justo é ver se o projeto vai ter algum problema antes de adotar qualquer framework, pois todo framework vai trazer uma queda de performance que nem sempre trará algum benefício em troca.

## A arquitetura no Elo7
Um dos principais valores da empresa é o foco na satisfação e fidelização do cliente. E isso foi importante para a decisão da arquitetura front-end: desejamos criar um site robusto que todos os usuários possam utilizar e que a resposta do site seja o mais rápido possível.

Para não depender do poder de processamento do device que nosso usuário está usando, decidimos que todo o conteúdo da página deve ser renderizado do lado do servidor. Além disso, o JavaScript da página só agrega a usabilidade do site, mas o usuário pode iteragir com os conteúdos da página antes mesmo do JavaScript carregar ou executar.

E uma outra vantagem que ganhamos ao adotar a renderização no lado do servidor foi o SEO: apesar de alguns bots executarem JS simple, não dá para saber o quanto eles conseguem ler do conteúdo se o conteúdo é renderizado dinamicamente no lado do cliente.

Como adotamos uma arquitetura baseada na renderização do lado do servidor, nós temos pouca lógica no JS da página. Assim, vários dos problemas que os projetos enfrentam, não apareceram no Elo7. E os problemas que surgiram foram tão pontuais que era mais vantajoso utilizar os conceitos de microframeworks do que um framework completo. No início, pesquisamos no site [microjs](http://microjs.com/) os microframeworks que resolvessem os pequenos problemas que encontramos, mas com o tempo fomos migrando para os nossos próprios frameworks para resolver os pequenos problemas que encontramos:

- [async-define](https://github.com/elo7/async-define): Controle da execução dos JS assíncronos utilizando a arquitetura [AMD](https://en.wikipedia.org/wiki/Asynchronous_module_definition)
- [doc-amd](https://github.com/elo7/doc-amd/): Manipulação do DOM
- [tag-amd](https://github.com/elo7/tag-amd): Criação de tags dentro de um input
- [format-amd](https://github.com/elo7/format-amd): Formatação de números
- [events-amd](https://github.com/elo7/events-amd): Controle de eventos do navegador
- [cookie-amd](https://github.com/elo7/cookie-amd): Controle de cookies do navegador
- [ajax-amd](https://github.com/elo7/ajax-amd): Evento de ajax
- [i18n-amd](https://github.com/elo7/i18n-amd): Internacionalização no lado do cliente
- [form-amd](https://github.com/elo7/form-amd): Manipulação e validação de formulários

Não vou descrever o que cada lib faz aqui para não ficar gigante o post, mas haverá posts futuros explicando com detalhes como cada lib funciona e você saberá se ela se encaixa no seu problema.

## Conclusão
