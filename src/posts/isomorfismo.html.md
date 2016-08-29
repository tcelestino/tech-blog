---
title: Javascript Isomórfico
date: 2016-08-29
category: front-end
layout: post
description: Novos frameworks são criados a todo momento e um novo nome está criando mais força no mundo javascript: Isomorfismo.
author: fernandabernardo
tags:
  - javascript
  - isomorfico
---

Novos frameworks são criados a todo momento e um novo nome está criando mais força no mundo javascript: Isomorfismo. Farei uma série de posts para explicar melhor esse conceito e algumas aplicações dele com o uso de frameworks. Nesse primeiro post, será abordado uma parte mais teórica sobre o que é isomorfismo.

## Voltando no tempo
Antes de falar de fato do isomorfismo, é interessante pensar em o que aconteceu na história para ter a necessidade de utilizar um código javascript isomórfico.
No final de 1990, Tim Berners-Lee publicou uma proposta mais formal para a *World Wide Web*. Em 1993, lançaram o [Mosaic](https://pt.wikipedia.org/wiki/Mosaic), o primeiro navegador WWW, que rodava tanto em windows quanto em linux. Ele abriu a web para o público em geral. Nesse mesmo ano, já é possível ver as primeiras páginas estáticas, com muitos textos e imagens. Um site que tem muitos desses sites antigos é nesse [artigo](http://gizmodo.com/5960831/23-ancient-web-sites-that-are-still-alive).

![Alt "Sites estáticos: Netscape e Space Jam"](../images/isomorfismo-1.png)

Já em maio de 1995, o javascript foi criado por Brendan Eich. Mas ele não era conhecido por esse nome e sim por Mocha. Em setembro do mesmo ano mudou para LiveScript e em dezembro, depois de receber uma licença da Sun, que o nome javascript foi finalmente adotado. Mas tudo isso foi uma jogada de marketing, já que o Java estava começando a ficar bem popular no mesmo período. Com o javascript foi possível adicionar mais interações com a página, eventos, animações...

No final dos anos 2000, as SPA’s (Single Page Applications) se tornaram populares. Elas são um modelo de desenvolvimento de aplicações web e mobile. Utilizar uma SPA significa dividir a responsabilidade com o cliente, ou seja, ter mais código rodando no cliente do que no servidor. Elas se assemelham mais a aplicativos desktop e com elas é possível interagir com uma página sem que seja necessário um reload. Como não é mais necessárioo o reload, é possível carregar dados assincronamente para que os usuários pudessem fazer algo durante o carregamento da página. Temos vários exemplos de SPA (Facebook, Google Drive, Ywitter, FourSquare), mas um deles é o gmail, onde você pode enviar diversos emails em paralelo sem ter que aguardar o primeiro processo encerrar com sucesso. Alguns problemas encontrados são com questões de SEO (Search Engine Optimization), já que por padrão não é possível rodar uma página dessas sem javascript, pois todo o seu código JS está no cliente. Porém, melhora a usabilidade do usuário, tornando uma página mais fluida.

Em 2009, foi criado o NodeJS e com isso é possível rodar um código javascript no lado do servidor. Porém, isso foi possível alguns anos antes com o [Rhino](https://developer.mozilla.org/pt-BR/docs/Mozilla/Projects/Rhino), que não deu muito certo.

Sendo possível rodar código javascript no servidor e também no cliente, podemos nos fazer uma pergunta: E se fosse possível rodar **um mesmo** código javascript no servidor e no cliente?

## Nomenclatura
A palavra isomorfismo no dicionário tem alguns significados, mas o que mais se assemelha ao que queremos é:
> 2\. *miner* fenômeno pelo qual duas ou mais substâncias de composição química diferente se apresentam com a mesma estrutura cristalina.

Outra nomenclatura conhecida é **Javascript Universal**. Essa nomenclatura surgiu com um [post](https://medium.com/@mjackson/universal-javascript-4761051b7ae9#.e5tzyhurr) em 2015 do Michael Jackson (é verdade). Ele fez um pull request para o React colocando os significados das duas nomenclaturas. No post dele, um dos argumentos que achei mais interessante, foi que quando falamos para uma pessoa sobre javascript isomórfico, ninguém entende logo o que signica, mas se falarmos javascript universal, todos entendem bem mais rápido sobre o que estamos falando. Mas isso é uma discussão mais filosófica. No post usarei isomórfico, mas é bom saber que as duas nomenclaturas são usadas hoje em dia.

## Código isomórfico
Depois da parte teórica, a pergunta que surge é: como isso funciona no código?
Basicamente, temos o mesmo código que consegue rodar no cliente e no servidor. Isso é possível, já que temos a seguinte separação entre os dois lados:

![Alt "Responsabilidades do cliente/servidor"](../images/isomorfismo-2.png)
