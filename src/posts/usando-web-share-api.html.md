---
date: 2017-07-24
category: front-end
tags:
  - javascript
  - mobile
  - web
authors: [tcelestino]
layout: post
title: Utilizando Web Share API
description: Aprenda como usar a Web Share API e utilizar compartilhamento nativo do sistema operacional sem necessidade de utilizar plugins de terceiros em seu projeto.
---

Hoje vivemos no mundo aonde o conteúdo é compartilhado em diversos canais, sejam em redes sociais, programas de mensagens (WhatsApp, Telegram, Slack, etc...) ou até mesmo via email. Você como desenvolvedor web, provavelmente já precisou adicionar em algum projeto recursos de compartilhamento desses serviços adicionando uma quantidade bem grande de código de terceiros no qual não tem nenhum controle. Aqui no Elo7, apostamos nessa forma de interação com os usuários, utilizando o compartilhamento via URL que é baseada em *query string*.

<div style='text-align: center'><iframe src="https://giphy.com/embed/26zz3WzwwLTbnYXUk" width="270" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><br><br>Compartilhando de forma tradicional a partir de links de terceiros</div>

E se existisse a possibilidade de compartilhar conteudo Web diretamente para aplicativos nativos? Sim, isso é possível usando uma nova API Javascript chamada de [Web Share API](https://wicg.github.io/web-share/), que no exato momento que escrevo esse post, apenas está [confirmada](https://www.chromestatus.com/features/5668769141620736) para chegar oficialmente na versão 61 do Chrome para Android. O Firefox e o Safari pretendem implementar em breve, enquanto a Microsoft ainda não se pronunciou sobre a implementação no Edge. Isso não quer dizer que você não possa implementar para o futuro próximo.

## Um pouco de história

Antes de surgir a ideia da Web Share API, era possível usar o compartilhamento utilizando recursos especificos para cada SO. Por exemplo, no Android o Chrome 18 utilizava o Web Intent, que foi removido na versão 24 do navegador. No iOS, usando [Custom URL Schemes](https://css-tricks.com/create-url-scheme/) e no Firefox OS existia o [Web Activies](https://developer.mozilla.org/en-US/docs/Archive/Firefox_OS/API/Web_Activities), que já está morto! Como pode notar, existia diversas formas de implementação que sem dúvidas demandava tempo e paciência do desenvolvedor. Para facilitar a implementação desse recurso sem precisar deixar muitos desenvolvedores irritados, o time do Google Chrome resolveu criar uma nova abordagem, assim surgindo a ideia da Web Share API.

A Web Share API é baseada em [Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) e sua implementação é bem simples.

## Implementando Web Share API

Como falei anteriormente, aqui no Elo7 implementamos o compartilhamento via *query strings*. Na discussão do time sobre a implementação da Web Share API, concluimos que seria melhor deixar essa abordagem como *fallback* para caso o navegador não tenha suporte a Web Share API. Na época, era possível utilizar a API participando do programa [Original Trials](https://github.com/GoogleChrome/OriginTrials/), que no momento possuem outras API's interessantes por lá. Vale a pena conferir!

Para usar a Web Share API é bem simples. Crie um arquivo chamado `index.html` com o seguinte código:

```html
<html>
  <head>
    <title>Usando a Web Share API</title>
  </head>
  <body>
    <a href='#share' title='Clique e compartilhe' class='share'>Compartilhar</a>
    <script async src='https://raw.githubusercontent.com/elo7/async-define/master/async-define.min.js'></script>
    <script async src='https://raw.githubusercontent.com/elo7/events-amd/master/events-amd.min.js'></script>
    <script async src='https://raw.githubusercontent.com/elo7/doc-amd/master/doc.min.js'></script>
    <script>
      define(['doc'], function($) {
        $('.share').on('click', function(evt) {
          if (navigator.share) {
            navigator.share({
              title: document.title,
              text: 'Usando a Web Share API'
              url: window.location.href
            }).then(function() {
              console.log('Funcionou!!');
            }).catch(function(error) {
              console.error(error);
            })
          }
          evt.preventDefault();
        })
      });
    </script>
  </body>
</html>
```

No código acima, estou usando o [doc-amd](https://github.com/elo7/doc-amd), [events-amd](https://github.com/elo7/events-amd) e o [async-define](https://github.com/elo7/async-define), projetos *open sources* do Elo7 e que utilizamos na nossa stack de desenvolvimento front-end. Fique a vontade para usar a biblioteca que você preferir, inclusive javascript nativo.

Ao clicar no campo compartilhar, irá abrir o compartilhamento nativo do sistema operacional, como você pode ver na GIF abaixo:

<div style='text-align: center'><iframe src="https://giphy.com/embed/26zza3FAMBhksoHFC" width="270" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><br><br>Compartilhamento usando Web Share API</div>

## Explicando o nosso código.

```javascript
if(navigator.share) {
  navigator.share({
    title: document.title,
    text: 'Usando a Web Share API',
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

A Web Share API está disponível no `navigator.share` e precisamos verificar se está disponível no navegador, por isso usamos o  `if`, caso não tenha chamamos nosso fallback.

```javascript
navigator.share({
  title: document.title,
  text: 'Usando a Web Share API',
  url: window.location.href
})
```

Passamos para a API o objeto com três valores:

* title: titulo que será usado no compartilhamento do link;
* text: texto que será adicionando no campo de texto (esse valor é opcional);
* url: link para onde o usuário será redirecionado ao clicar.

Como falei anteriormente, a Web Share API é baseada em [Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise), então podemos ter dois "comportamentos". Caso o compartilhamento seja feito com sucesso é chamado o `then`. No Elo7 por exemplo, enviamos essa informação para o Google Analytics. Mas caso aconteça um erro, o `catch` será chamado e podemos implementar algo como uma mensagem de erro. Vale lembrar, que o `catch` não tem nenhuma relação com o erro para caso a API não esteja disponível no navegador do usuário. Se você ainda não entendeu muito sobre Promise, recomendo ler esse [documento](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) no Mozilla Developer Network (MDN)

## Notas

Apesar da implementação ser simples, para usar a API é preciso ter algumas atenções:

* Seu servidor precisa ter HTTPS habilitado;
* Você precisa passar um `text` ou uma `url`. Ou pode usar os dois (como no exemplo);
* Os valores passados para API precisam ser no formato de texto.

## Para maiores informações

* [Web Share API Draft - W3C](https://wicg.github.io/web-share/)
* [Introducing the Web Share API](https://developers.google.com/web/updates/2016/10/navigator-share)
* [Web Share API brings the native sharing capabilities to the browser](https://blog.hospodarets.com/web-share-api)
