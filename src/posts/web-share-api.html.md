---
date: 2017-08-07
category: front-end
tags:
  - javascript
  - mobile
  - web
authors: [tcelestino]
layout: post
title: Web Share API
description: Conheça mais uma API JavaScript que pretende melhorar a experiência do usuário quando precisar compartilhar links da Web para aplicativos nativos.
---

Hoje vivemos no mundo dos compartilhamentos, seja através das redes sociais, programas de mensagens (WhatsApp, Telegram, Slack, etc...) entre outros meios. Através deles, podemos compartilharmos link para uma notícia, para um produto em uma loja, etc.... Você como desenvolvedor web, provavelmente já precisou usar algum recurso de compartilhamento de alguns desses serviços em algum projeto. Muita das vezes, a quantidade de código é tanta que é "impossível" fazer manutenção ou ter controle do funcionamento desses códigos. Aqui no Elo7, já usamos plugins (Facebook Share, por exemplo), mas hoje utilizamos o compartilhamento via URL que é baseada em *query string*.

```html
<a href="https://www.facebook.com/dialog/share?app_id=APP_ID&amp;href=https%3A%2F%2Fwww.elo7.com.br%2Fkit-decoracao-ursinho-frete-gratis&amp;display=popup" rel="noopener" target="_blank" class="btn-share" title="Clique para compartilhar no Facebook">Compartilhar</a>
```
<div style='text-align: center; font-style: italic'>Código de exemplo de como usamos o compartilhamento vira query string no Facebook</div>

E se existisse a possibilidade de compartilhar conteudo Web diretamente para aplicativos nativos? Sim, isso é possível usando uma nova API Javascript chamada de [Web Share API](https://wicg.github.io/web-share/), que no exato momento que escrevo esse post, apenas está [confirmada](https://www.chromestatus.com/features/5668769141620736) para chegar oficialmente na versão 61 do Chrome para Android. O Firefox e o Safari pretendem implementar em breve, enquanto a Microsoft ainda não se pronunciou sobre a implementação no Edge. Isso não quer dizer que você não possa implementar para o futuro próximo.

<div style='text-align: center; font-style: italic'><iframe src="https://giphy.com/embed/26zz3WzwwLTbnYXUk" width="270" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><br><br>Compartilhando um link usando URL Intent</div>

## Um pouco de história

Antes de surgir a ideia da Web Share API, era possível usar o compartilhamento utilizando recursos especificos para cada sistema operacional. Por exemplo, no Android, o Chrome 18 utilizava [Web Intents](https://www.chromium.org/developers/web-intents-in-chrome). No iOS, usando [Custom URL Schemes](https://css-tricks.com/create-url-scheme/) e no Firefox OS era possível usar [Web Activies](https://developer.mozilla.org/en-US/docs/Archive/Firefox_OS/API/Web_Activities). Como pode notar, existiam diversas formas de implementação que sem dúvidas demandava tempo e paciência do desenvolvedor. Para facilitar a implementação desse recurso, o time do Google Chrome resolveu criar uma nova abordagem, assim surgindo a ideia da Web Share API.

A Web Share API é baseada em [Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) e sua implementação é bem simples.

## Implementando Web Share API

Como falei anteriormente, aqui no Elo7 implementamos o compartilhamento via *query strings*. Na discussão do time de front-end sobre a implementação da Web Share API, concluimos que seria melhor manter a abordagem da *query string* como *fallback* para caso o navegador não tenha suporte a Web Share API. Na época da implementação, era possível utilizar a API participando do programa [Original Trials](https://github.com/GoogleChrome/OriginTrials/), mas que não está mais disponível. Se você tiver curioso, existem outras API's interessantes poderão ser lançadas em breve (WebUSB, WebVR e getInstalledRelatedApps). Vale a pena conferir!

Para usar a Web Share API é bem simples. Vamos criar um arquivo e chama-lo de `index.html` e vamos ter o seguinte código:

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
      (function() {
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
      })();
    </script>
  </body>
</html>
```

No código acima, estou usando o [doc-amd](https://github.com/elo7/doc-amd), [events-amd](https://github.com/elo7/events-amd) e o [async-define](https://github.com/elo7/async-define), projetos *open sources* do Elo7 e que utilizamos na nossa stack de desenvolvimento front-end. Fique a vontade para usar a biblioteca que você preferir, ou usar JavaScript "puro".

Ao clicar no link compartilhar, teremos a seguinte tela:

<div style='text-align: center; font-style: italic;'><iframe src="https://giphy.com/embed/26zza3FAMBhksoHFC" width="270" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><br><br>Compartilhamento usando Web Share API</div>

## Entendendo o código.

Vamos entender um pouco mais sobre como que funciona nosso código de exemplo.

A Web Share API está disponível no `navigator.share` e precisamos verificar se está disponível no navegador, por isso usamos o  `if`, caso não esteja disponível, chamamos nosso *fallback*.

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

Como falei anteriormente, a Web Share API é baseada em [Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise), então podemos ter dois "comportamentos". Caso o compartilhamento seja realizado com sucesso é chamado o trecho do bloco de código que está dentro do `then`. Aqui no Elo7 por exemplo, enviamos essa informação para o nosso GA. Mas caso aconteça um erro, o `catch` será executado e assim podemos implementar um *feedback* para o usuário. Só lembrando que o `catch` não tem nenhuma relação em relação a disponibilidade de API no navegador do usuário.

Hoje em dia, grande parte das novas APIs JavaScript estão baseadas em Promise, logo, recomendo você começar a ler sobre e até mesmo implementar em seus projetos.

Passando pela verificação, caso o navegador tenha suporte, passamos para a API um objeto com os seguintes valores:

```javascript
navigator.share({
  title: document.title,
  text: 'Usando a Web Share API',
  url: window.location.href
})
```

* title: titulo que será usado no compartilhamento do link;
* text: texto que será adicionando no campo de texto (esse valor é opcional);
* url: link para onde o usuário será redirecionado ao clicar.


## Usando canonical URL

Muitos sites utilizam um dominio especifico (http://m.site.com.br, por exemplo) para ser acessado em dispositivos móveis ou até mesmo URL's baseadas no contexto do usuário. Com isso, é preciso pensar bastante na URL que será compartilhada para entregar uma boa experiência para o usuário. Existe a possibilidade de compartilhar o link correto usando [canonical URL](https://en.wikipedia.org/wiki/Canonical_link_element). Atualizando nosso `index.html`, ficaria assim:

```html
<html>
  <head>
    <title>Usando a Web Share API</title>
    <link rel="canonical" href="https://engenharia.elo7.com.br/web-share-api">
  </head>
  <body>
    <a href='#share' title='Clique e compartilhe' class='share'>Compartilhar</a>
    <script async src='https://raw.githubusercontent.com/elo7/async-define/master/async-define.min.js'></script>
    <script async src='https://raw.githubusercontent.com/elo7/events-amd/master/events-amd.min.js'></script>
    <script async src='https://raw.githubusercontent.com/elo7/doc-amd/master/doc.min.js'></script>
    <script>

      (function() {
        define(['doc'], function($) {

          var url = document.location.href;
          var canonical = $('link[rel=canonical]');

          if(canonical !== undefined) {
              url = canonical.href;
          }

          $('.share').on('click', function(evt) {
            if (navigator.share) {
              navigator.share({
                title: document.title,
                text: 'Usando a Web Share API',
                url: url
              }).then(function() {
                console.log('Funcionou!!');
              }).catch(function(error) {
                console.error(error);
              });
            }
            evt.preventDefault();
          })
        });
      })();
    </script>
  </body>
</html>
```

Com isso, garantimos que estamos compartilhando o link real da página.

## Notas

Apesar da implementação ser simples, para usar a API é preciso ter algumas atenções:

* Seu servidor precisa ter HTTPS habilitado;
* Você precisa passar um `text` ou uma `url`. Ou pode usar os dois (como no exemplo);
* Os valores passados para API precisam ser no formato de texto.


## Conclusão

A Web Share API com certeza será usada por diversos desenvolvedores para entregar uma melhor experiência para os usuários, inclusive com o crescimento no desenvolvimento de Web Apps que utilizam o conceito de [Progressive Web Apps (PWA)](https://developers.google.com/web/progressive-web-apps/),  com certeza manterá a fluidez que um app nativo possui. Sem contar que não haverá a necessidade (se não quiser fazer um *fallback*) de usar códigos de terceiros para compartilhar conteudo.

Logo, logo, o Chrome 61 estará entre nós e acredito que os outros navegadores estarão implementando a API, mesmo que em fase beta. Esperar pra ver!

## Referências

* [Web Share API Draft - W3C](https://wicg.github.io/web-share/)
* [Introducing the Web Share API](https://developers.google.com/web/updates/2016/10/navigator-share)
* [Web Share API brings the native sharing capabilities to the browser](https://blog.hospodarets.com/web-share-api)
