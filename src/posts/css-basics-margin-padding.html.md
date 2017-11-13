---
title: CSS Basics - Margin x Padding
date: 2017-11-13
category: front-end
layout: post
description: 
authors: [fernandabernardo]
tags:
  - css
  - margin
  - padding
---

Depois de falar sobre *display* no [post anterior](/css-basics-display/), vamos continuar falando sobre propriedades básicas do CSS. Nesse post iremos falar um pouco mais sobre as propriedades de espaçamento como ***margin*** e ***padding***. 

## Diferença

Para começar, qual a principal diferença entre *margin* e *padding*? Ao utilizar a propriedade *margin*, você está acrescentando um espaço externo ao elemento, ou seja, para fora, a distância entre um elemento e outro. Enquanto o *padding* acrescenta um espaço interno ao elemento, para dentro, a distância entre o conteúdo e a borda.
![Representação de margin, padding e border](../images/css-basics-margin-padding-1.png)

## Box Sizing
Uma propriedade relacionada com as duas tratadas no post é a *box-sizing*. Ela é utilizada para alterar como o navegador calcula os tamanhos (altura e largura) de um elemento. Ela possui três valores:
- *content-box* (valor padrão)
- *padding-box* (não é muito suportado pelos browsers, apenas o Firefox tem suporte)
- *border-box*

<p data-height="333" data-theme-id="23784" data-slug-hash="vxPyPV" data-default-tab="css,result" data-user="FernandaBernardo" data-embed-version="2" data-pen-title="Box sizing" class="codepen">Veja o exemplo <a href="http://codepen.io/FernandaBernardo/pen/vxPyPV/">Box sizing</a> by Fernanda Bernardo (<a href="http://codepen.io/FernandaBernardo">@FernandaBernardo</a>) no <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

Para entender melhor como cada um deles funcionam, temos duas *sections* acima (rosa e azul) usando cada um dos valores de box-sizing. Além disso, colocamos um *padding* nas duas *sections*. Começando pela *section* com *content-box* para calcular as dimensões dela (altura e largura) é contado apenas o conteúdo. Tanto *margin*, *padding* e *border* são considerados para fora do *box*. Ou seja, se minha `<section>` tem `100x100px` e um *padding* de `30px`, logo o tamanho total será `160x160px` (100 + 30 - right + 30 - left). Já a `<section>` com *border-box* o tamanho final seria `100x100px`, porque essa propriedade para calcular o tamanho final da *section* utiliza a soma do conteudo + *padding* + *border*. Um pouco confuso? Veja a imagem abaixo que o conceito ficará mais claro:

![Diferenças entre content-box e border-box](../images/css-basics-margin-padding-2.png)

## Centralização horizontal
Um dos valores da propriedade *margin* é *auto*. Para usá-la, precisamos que o elemento seja um bloco, ou seja, tenha a propriedade `display: block`, e tenha um largura (`width`) definido. Dessa forma, o elemento ficará centralizado horizontalmente.

<p data-height="300" data-theme-id="23784" data-slug-hash="XzgJBz" data-default-tab="css,result" data-user="FernandaBernardo" data-embed-version="2" data-pen-title="Margin: auto" class="codepen">Veja o exemplo <a href="https://codepen.io/FernandaBernardo/pen/XzgJBz/">Margin: auto</a> by Fernanda Bernardo (<a href="https://codepen.io/FernandaBernardo">@FernandaBernardo</a>) no <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>




* margin inline
* box não acompanha a margin
* background com padding - background-origin: content-box
* border para diferenciar margin de padding
* float conta o margin para o tamanho de cada elemento
* margin com porcentagem