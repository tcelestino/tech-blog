---
title: CSS Basics - Margin x Padding
date: 2017-04-03
category: front-end
layout: post
description: 
author: fernandabernardo
tags:
  - css
  - margin
  - padding
  - espaçamento
---

Depois de falar sobre *display* no [post anterior](/css-basics-display/), vamos continuar falando sobre propriedades básicas do CSS. Nesse post iremos falar um pouco mais sobre as propriedades de espaçamento como ***margin*** e ***padding***. 

## Diferença

Para começar, qual a principal diferença entre *margin* e *padding*? Ao utilizar a propriedade *margin*, você está acrescentando um espaço externo ao elemento, ou seja, para fora. Enquanto o *padding* acrescenta um espaço interno ao elemento, para dentro.
![Representação de margin, padding e border](../images/css-basics-margin-padding-1.png)

## Box Sizing
Uma propriedade relacionada com as duas tratadas no post é a *box-sizing*. Ela é utilizada para alterar como o navegador calcula os tamanhos (altura e largura) de um elemento. Ela possui três valores:
- *content-box* (valor padrão)
- *padding-box* (não é muito suportado pelos browsers, apenas o Firefox tem suporte)
- *border-box*

<p data-height="333" data-theme-id="23784" data-slug-hash="vxPyPV" data-default-tab="css,result" data-user="FernandaBernardo" data-embed-version="2" data-pen-title="Box sizing" class="codepen">Veja o exemplo <a href="http://codepen.io/FernandaBernardo/pen/vxPyPV/">Box sizing</a> by Fernanda Bernardo (<a href="http://codepen.io/FernandaBernardo">@FernandaBernardo</a>) no <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

Para entender melhor como cada um deles funcionam, temos duas *sections* acima (rosa e azul) usando cada um dos valores de box-sizing. Além disso, colocamos um *padding* nas duas *sections*. Na *section* com *content-box*, o tamanho de altura(*height*) e largura(*width*) são contados apenas com o conteúdo; as propriedades de *margin*, *padding* e *border* são consideradas para fora do box. Ou seja, se minha `<section>` tem `100x100px` e um *padding* de `30px`, logo

![Diferenças entre content-box e border-box](../images/css-basics-margin-padding-2.png)





* margin inline
* box não acompanha a margin
* background com padding - background-origin: content-box
* border para diferenciar margin de padding
* box-sizing
* float conta o margin para o tamanho de cada elemento
* margin: auto
* margin com porcentagem