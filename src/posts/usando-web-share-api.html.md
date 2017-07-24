---
date: 2017-07-24
category: front-end
tags:
  - javascript
  - google chrome
  - web
  - share api
authors: [tcelestino]
layout: post
title: Usando a Web Share API para compartilhar conteúdo da web com app nativos
description: Aprenda como usar a Web Share API e utilizar compartilhamento nativo do sistema operacional sem necessidade de utilizar plugins de terceiros em seu projeto.
---

Hoje vivemos no mundo aonde o conteúdo é compartilhado em diversos canais, sejam em redes sociais, programas de mensagens (What's App, Telegram, Slack, etc...) ou até mesmo via email. Você como desenvolvedor web, provavelmente já precisou adicionar em algum projeto recursos de compartilhamento desses serviços adicionando uma quantidade bem grande de código de terceiros no qual não tem nenhum controle. Aqui no Elo7, apostamos nessa forma de interação com os usuários, utilizando o compartilhamento via URL que é baseada em *query string*.

```html
<section class="share-modal" id="share-modal-no-icons" data-match-webcode="no-icons">
  <ul>
    <li>
      <a class="link facebook" href="https://www.facebook.com/dialog/share?app_id=APP_ID&amp;href=https%3A%2F%2Fwww.elo7.com.br%2Fcaminha-monitor-pet-gato%2Fdp%2F68D99B%3Futm_source%3Dfacebook%26utm_medium%3Dproduct_details&amp;display=popup&amp;redirect_uri=https%3A%2F%2Fwww.elo7.com.br%2Fcaminha-monitor-pet-gato%2Fdp%2F68D99B" rel="nofollow" title="Facebook" data-share-type="facebook">Facebook</a>
    </li>
    <li>
      <a class="link whatsapp" href="whatsapp://send?text=Gostei+deste+produto+do+Elo7%3A+https%3A%2F%2Fwww.elo7.com.br%2Fcaminha-monitor-pet-gato%2Fdp%2F68D99B%3Futm_source%3Dwhatsapp%26utm_medium%3Dproduct_details" data-action="share/whatsapp/share" rel="nofollow" title="Whatsapp" data-share-type="whatsapp">Whatsapp</a>
    </li>
    <li>
      <a class="link twitter" href="https://twitter.com/intent/tweet?url=https%3A%2F%2Fwww.elo7.com.br%2Fcaminha-monitor-pet-gato%2Fdp%2F68D99B%3Futm_source%3Dtwitter%26utm_medium%3Dproduct_details&amp;via=Elo7&amp;related=Elo7&amp;hashtags=produtosforades%C3%A9rie&amp;text=Gostei+deste+produto+do+Elo7%3A" title="Twitter" target="_blank" rel="external nofollow" data-share-type="twitter">Twitter</a>
    </li>
    <li>
      <a href="#_" class="link copy-link" title="Copiar link" rel="nofollow" data-share-type="copy">Copiar link</a>
      <input class="link-url" value="https://www.elo7.com.br/caminha-monitor-pet-gato/dp/68D99B?utm_source=copy&amp;utm_medium=product_details" readonly="">
    </li>
  </ul>
  <a class="cancel" href="#_" title="Cancelar">Cancelar</a>
</section>
```

E se existisse a possibilidade de compartilhar conteudo via Web para aplicativos instalados no seu sistema operacional? Sim, isso é possível usando uma nova API Javascript chamada de [Web Share API](https://developers.google.com/web/updates/2016/10/navigator-share), que no momento apenas na versão 61 do Chrome para Android já está confirmada a implementação, mas isso não quer dizer que você não possa implementar para o futuro próximo.

## Um resumo da história

Antes de surgir a ideia da Web Share API, era possível fazer a mesma implementação usando uma API chamada Web Intent, porém sua implementacão era complexa. Para facilitar a implementação desse recurso sem causar uma grande estranheza, o time do Google Chrome resolveu criar uma nova abordagem, assim surgindo a ideia da Web Share API.

A Web Share API é baseada em [Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) e sua implementação é bem simples.

## Implementando Web Share API

Como falei anteriormente, aqui no Elo7 implementamos o compartilhamento via *query strings* e usamos como **fallback** para a Web Share API, que na época da implementação estava disponível fazendo parte do programa [Original Trials](https://github.com/GoogleChrome/OriginTrials/). Antes de implementarmos a Web Share API, criamos nosso próprio recurso de compartilhamento. Como você pode ver o funcionamento na GIF abaixo:

<div style='text-align: center'><iframe src="https://giphy.com/embed/26zz3WzwwLTbnYXUk" width="270" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div>

Para usar a Web Share API é bem simples. Vamos criar um arquivo chamado `index.html` com o seguinte código:

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

No código acima, estou usando o [doc-amd](https://github.com/elo7/doc-amd), [events-amd](https://github.com/elo7/events-amd) e o [async-define](https://github.com/elo7/async-define), projetos *open sources* do Elo7 e que utilizamos na nossa stack de desenvolvimento front-end e que você pode utilizar em seus projetos e contribuir. Fique a vontade para usar a biblioteca que você preferir, inclusive javascript nativo.

Ao clicar no campo compartilhar, irá abrir o compartilhamento nativo do sistema operacional, como você pode ver na GIF abaixo:

<div style='text-align: center'><iframe src="https://giphy.com/embed/26zza3FAMBhksoHFC" width="270" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div>

## Explicando o nosso código.

```javascript
if(navigator.share) {
  navigator.share({
    title: 'Usando a Web Share API',
    url: 'http://tech.elo7.com.br'
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
  title: 'Usando a Web Share API',
  url: 'http://tech.elo7.com.br'
})
```

Passamos para a API qual será o titulo e a URL que será exibida quando o usuário compartilhar entre os aplicativos instalados no Android. Como já falei anteriormente, a Web Share API é baseada em [Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise), então podemos ter dois "comportamentos". Caso o compartilhamento seja feito com sucesso é chamado o `then`. No Elo7 por exemplo, enviamos essa informação para o Google Analytics. Mas caso aconteça um erro, o `catch` será chamado e podemos implementar algo como uma mensagem de erro. Vale lembrar, que o `catch` não tem nenhuma relação com o erro para caso a API não esteja disponível no navegador do usuário. Se você ainda não entendeu muito sobre Promise, recomendo ler o [documento](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) no Mozilla Developer Network (MDN)

## Notas

Apesar da implementação ser simples, para usar a API é preciso ter algumas atenções:

- Seu servidor precisa ter HTTPS habilitado;
- You need to supply at least one of text or url but may supply both if you like; (ver traduzir)
- Os valores passados para API precisam ser no formato de texto.

## Em fase de implementação

No momento que escrevo esse post a Web Share API não está mais disponível para o Google Chrome no Android, porém já tem previsão para ser [lançada definitivamente na versão 61](https://twitter.com/malyw/status/882334161998159873).

## Para mais informações

* [Introducing the Web Share API](https://developers.google.com/web/updates/2016/10/navigator-share)
* [Web Share API brings the native sharing capabilities to the browser](https://blog.hospodarets.com/web-share-api)
