---
date: 2017-10-12
category: front-end
tags:
  - javascript
  - web
authors: [tcelestino]
layout: post
title: Credential Managament API
description:
---
Nos dias atuais, passamos bastante tempo navegando em nossos navegadores seja através dos nossos smartphones ou no computador de mesa. Na grande maioria dos serviços que usamos, de certa forma existem o "controle de acesso" para utiliza-los. Geralmente, precisamos digitar um login (nome de usuário ou email) e uma senha. Isso a gente já sabe. Mas também sabemos o quanto é "chato" ter que ficar sempre digitando essas informações. Existem diversos serviços/aplicativos que auxiliam no gerenciamento de nossos dados, posso citar alguns como o LastPass, 1Password, bitwarden e principalmente os navegadores. Sim, os navegadores já oferecem gerenciamento de dados. Claro, acredito que você já sabia disso!

Pois bem!

Sabemos que os navegadores possuem o recurso de gerenciamento de dados de autenticação, mas e como que fazemos para informar esses dados para os navegadores? Como que consigo integrar meu sistema de login com o navegador? Para facilitar essa interação entre website > navegador, que surgiu a proposta da [Credential Management API](https://www.w3.org/TR/credential-management-1/). No momento, apenas o Google Chrome (para Android e desktop) tem a API implementada. Isso não quer dizer você não possao implementar em seu projeto.

## Caso Elo7

Aqui no Elo7, já utilizamos a Credential Management API no sistema de login na versão mobile do marketplace (conto logo, logo o problema com a implementação na versão desktop) há algum tempo e segundo dados que obtemos através do Google Analytics, observamos que muitos usuários estão usando o recurso, que facilita bastante o processo de autenticação em nosso sistema.


## Nem tudo são flores
