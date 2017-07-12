---
title: Usando a Web Share API para compartilhar conteúdo da web com app nativos
date: 2017-07-12
category: front-end
layout: post
description: Aprenda como utilizar a Web Share API para compartilhar conteúdo da Web com aplicativos nativos
author: tcelestino
tags:
  - javascript
  - google chrome
  - web
---

TL;DR Aprenda como usar a [Web Share API](https://developers.google.com/web/updates/2016/10/navigator-share) e utilizar compartilhamento nativo sem necessidade de adicionar plugins de terceiros em seu projeto.

Hoje vivemos no mundo aonde o conteúdo é compartilhado em diversos canais, sejam em redes sociais, programas de mensagens (What's App, Telegram, Slack, etc...) ou até mesmo via email. Você como desenvolvedor web, provavelmente já precisou adicionar em algum projeto recursos de compartilhamento desses serviços, adicionando uma quantidade bem grande de código de terceiros no qual não tinha nenhum controle. Aqui no Elo7, apostamos nessa forma de interação com os usuários, utilizando o compartilhamento via URL que é baseada em *query string*.

[Adicionar exemplo de código]

Além disso, resolvemos implementar de forma experimental a Web Share API, que por enquanto apenas está sendo implementado no Chrome para Android e deve ser lançado na versão 61 do navegador.

## Um resumo da história

Antes de surgir a ideia da Web Share API, existia uma API chamada Web Intent, que servia para a mesma ideia, porém sua implementacão era complexa. Para facilitar a implementação desse recurso sem causar uma grande estranheza, o time do Google Chrome resolveu criar uma nova abordagem, assim surgindo a ideia do Web Share API.

A Web Share API é baseada em [Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) e sua implementação é bem simples.

## Implementando Web Share API

Como já falei anteriormente, aqui no Elo7 implementamos o compartilhamento via URL como **fallback** para a Web Share API. Antes de implementarmos a Web Share API, criamos nosso próprio recurso de compartilhamento, algo que pode ser visto no vídeo abaixo.

[adicionar vídeo do antes da web share api]

Para implementar o recurso é bem simples. Vamos criar um arquivo chamado `index.html` no qual teremos o seguinte trecho de código:

<script src="https://gist.github.com/tcelestino/bdb9af773165d9484f1313f9e227af08.js"></script>

No código acima, estou usando o [doc-amd](https://github.com/elo7/doc-amd), [events-amd](https://github.com/elo7/events-amd) e o [async-define](https://github.com/elo7/async-define), projetos open-source do Elo7 e que utilizamos no desenvolvimento front-end e que você pode utilizar em seus projetos e também contribuir.

Pois bem, vamos as explicações.

```javascript
if(navigator.share) {
  navigator.share({
    title: document.title,
    url: window.location.href
  }).then(function() {
    console.log('Funcionou!!');
  }).catch(function(error) {
    console.error(error);
  })
} else {
  // fallback
}
```

O Web Share API está relacionado está disponível no `navigator.share`, no qual no nosso `if` verificamos se a API está disponível para o navegador atual, caso não tenha, chamamos nosso fallback. Pois bem. Feito isso, temos as seguinte estrutura da API:

```javascript
navigator.share({
  title: 'Usando a Web Share API',
  url: 'http://tech.elo7.com.br'
})
```

Passamos para a API qual será o titulo e a URL que será exibida quando o usuário clicar no link compartilhar. Como falei anteriormente, a Web Share API é baseada em Promise, então podemos fazer dois "comportamentos". Caso dê sucesso, o `then` será chamado e podemos implementar algo. No Elo7 por exemplo, enviamos essa informação para o Google Analytics. Mas caso tenha um erro, o `catch` será chamado e podemos implementar algo como uma mensagem de erro. Vale lembrar, que o `catch` não tem nenhuma relação com o erro de caso a API não esteja disponível no navegador do usuário.

[Adicionar vídeo web share api elo7]

No momento que escrevo esse post a Web Share API não está disponível para o Google Chrome no Android, porém já tem previsão para ser [lançada definitivamente na versão 61](https://twitter.com/malyw/status/882334161998159873).

## Para mais informações
* https://blog.hospodarets.com/web-share-api
* https://developers.google.com/web/updates/2016/10/navigator-share
