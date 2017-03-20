---
title: Usando a Web Share API para compartilhar conteúdo da web com app nativos
date: 2017-03-20
category: front-end
layout: post
description: Aprenda como utilizar a Web Share API para compartilhar conteúdo da Web com aplicativos nativos
author: tcelestino
tags:
  - javascript
  - google chrome
  - web
---

TL;DR Aprenda como usar a Web Share API e utilizar compartilhamento nativo sem necessidade de adicionar plugins de terceiros em seu projeto.

Hoje vivemos no mundo aonde o conteúdo é compartilhado em diversos canais, seja redes sociais, mensageiros etc… Todas as grandes redes sociais (Twitter, Facebook, Google+) disponibilizam recursos que facilitam o compartilhamento da web para dentro da sua rede. Recursos como *widgets* e urls baseados em parâmetros (query string) que facilitam a implementação dessa integração entre os sites. Aqui no Elo7, meses atrás ainda utilizar-mos o *widget* de compartilhamento do Facebook, e recentemente substituimos por urls com "query string", removendo mais uma chamada de script de terceiros. Além disso, implementamos uma nova API que consegue compartilhar informações da web para o recurso de compartilhamento dos sistemas operacionais, no caso, o Android.

## Um pouco de história

Antes de existir a Web Share API, tinhamos a API Web Intent, que tinha o mesmo intuito, porém sua implementação era complexa e por incrível que parece não era suportada para dispositivos móveis. Assim, o time do Google Chrome passou a trabalhar em uma nova API que batizaram de Web Share API.

A Web Share API é baseada em [Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) e sua implementação é muito simples.

Um detalhe é importante, por enquanto a API só funciona no Google Chrome para Android, com previsão de se tornar oficial até abril desse ano, sem nenhuma informação de que os outros browsers pensam implementar em futuras versões.

## Obtendo autorização para uso da API

Para começarmos a usar a Web Share API, precisamos habilitar o recurso em nosso navegador. O time do Google Chrome, desde do beta do Chrome 55, passou a usar o requisito de token para uso de novas API’s. Eles criaram o [Original Trials](https://github.com/jpchase/OriginTrials/blob/gh-pages/developer-guide.md), pertimindo que nós desenvolvedores utilizam algumas novas APIs (WebVR, WebUSB, etc...) em nosso projetos, mesmo que forma experimental. Por isso, para implementarmos a Web Share API, vamos precisar preencher o [formulário](https://docs.google.com/forms/d/e/1FAIpQLSfO0_ptFl8r8G0UFhT0xhV17eabG-erUWBDiKSRDTqEZ_9ULQ/viewform) com as informações necessárias e esperar pelo menos um dia para receber por email o token e a data de expiração do mesmo.

## Implementando Web Share API

A primeira coisa que vamos precisar adicionar o token obtido no [Original Trials](https://github.com/jpchase/OriginTrials/blob/gh-pages/developer-guide.md) em nosso HTML.

```html
<html>
  <head>
    <meta http-equiv="origin-trial" content="**aqui entra o token enviado por email**">
    <title>Exemplo Web Share API</title>
  </head>
  <body>
    <a href='#share' title='Clique e compartilhe'>Compartilhar</a>
    <!-- Chamada para o Doc AMD -->
    <script async src='https://raw.githubusercontent.com/elo7/async-define/master/async-define.min.js'></script>
    <script async src='https://raw.githubusercontent.com/elo7/events-amd/master/events-amd.min.js'></script>
    <script src='https://raw.githubusercontent.com/elo7/doc-amd/master/doc.js'></script>
  </body>
</html>
```

Após adicionarmos a meta tag em nosso HTML, vamos precisar fazer a chamada ao objeto `navigator.share` com javascript.

```html
<html>
  <head>
    <meta http-equiv="origin-trial" content="**aqui entra o token enviado por email**">
    <title>Exemplo Web Share API</title>
  </head>
  <body>
    <a href='#share' title='Clique e compartilhe' class='share'>Compartilhar</a>
    <script async src='https://raw.githubusercontent.com/elo7/async-define/master/async-define.min.js'></script>
    <script async src='https://raw.githubusercontent.com/elo7/events-amd/master/events-amd.min.js'></script>
    <script src='https://raw.githubusercontent.com/elo7/doc-amd/master/doc.js'></script>
    <script>
      define(['doc'], function($) {
        $('.share').on('click', function(evt) {
          if(navigator.share) {
            navigator.share({
              title: document.title,
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

A primeira coisa que precisamos

## Fontes
* https://blog.hospodarets.com/web-share-api
* https://developers.google.com/web/updates/2016/10/navigator-share
* https://developers.google.com/web/updates/2016/10/navigator-share
