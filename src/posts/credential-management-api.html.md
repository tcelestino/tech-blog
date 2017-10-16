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

Existem três pilares para o uso da Credtial Management API:

- Simplifique o fluxo de acesso
- Permite acesso em um toque com o seletor de contas
- Armazena credenciais

Como falei anteriormente, a ideia por trás da API é realmente facilitar o fluxo de acesso do usuário com o website.

## Caso Elo7

Aqui no Elo7, já utilizamos a Credential Management API no sistema de login na versão para dispositivos móveis do marketplace (conto logo, logo o problema com a implementação na versão desktop) há algum tempo e segundo dados que obtemos através do Google Analytics, observamos que muitos usuários estão usando o recurso, que facilita bastante o processo de autenticação em nosso sistema.

Vamos ao que interessa

## Implementando

Antes de iniciar nosso código é bom salientar que para usar a API em produção, seu servidor vai precisar ter implementando algum certificado SSL, já que a Credential Management API (assim como novas API's) só irá funcionar se seu servidor garantir a segurança de navegação.

Para começar, precisamos garantir que a API esteja disponível no navegador

```javascript
	if ('credentials' in navigator) {
		// lógica
	}
```

Na API, existem  metódos que podemos pegar a informação já salva do usuário, ou salvar essas informações, assim como um metódo para controlar o logout do usuário no seu sistema. Vou falar delas com detalhes nos próximos tópicos.

### Obtendo informações do usuário

Para obter


## Nem tudo são flores
