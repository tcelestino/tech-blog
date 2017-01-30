---
date: 2017-01-02
category: front-end
tags:
  - css
  - display
  - posicionamento
author: FernandaBernardo
layout: post
title: CSS Basics - Display
description: Esse será o primeiro de uma série de posts sobre CSS Básico. A ideia desses posts é explicar como funciona cada uma das propriedades do CSS que na teoria "todo mundo conhece". Vamos entender como usar cada uma das propriedades sem ficar apenas "chutando" até descobrir o que funciona e nunca mais mexer. Nesse primeiro post falaremos sobre a propriedade display.
---

Esse será o primeiro de uma série de posts sobre **CSS Básico**. A ideia desses posts é explicar como funciona cada uma das propriedades do CSS que na teoria "todo mundo conhece". Vamos entender como usar cada uma das propriedades sem ficar apenas "chutando" até descobrir o que funciona e nunca mais mexer. Nesse primeiro post falaremos sobre a propriedade **display**.

A propriedade *display* é bastante importante para o controle do layout, ela indica a caixa de renderização para cada elemento. Cada um dos elementos do HTML possui um valor padrão de *display*, sendo a maioria delas *block* ou *inline*.

## Block 

Os elementos que possuem essa propriedade são considerados elementos de bloco. Esses elementos possuem uma quebra de linha (espaço em branco) antes e depois deles e não permitem que outros elementos HTML sejam posicionados ao lado deles. 

Os elementos mais comuns que possuem *display: block* como padrão são: `<div>`, `<p>`, `<form>` e as novas tags do HTML5: `<header>`, `<section>`, `<footer>`, entre outros.

<p data-height="300" data-theme-id="23784" data-slug-hash="egmXBo" data-default-tab="css,result" data-user="FernandaBernardo" data-embed-version="2" data-pen-title="Display Block" class="codepen">Veja o exemplo <a href="http://codepen.io/FernandaBernardo/pen/egmXBo/">Display Block</a> by Fernanda Bernardo (<a href="http://codepen.io/FernandaBernardo">@FernandaBernardo</a>) no <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

Uma forma de conseguir posicionar elementos ao lado de um elemento com *display: block* é usando propriedades que tiram o elemento do fluxo normal da página. Como por exemplo, `float` e `position: absolute`. Mas essas propriedades ficam como assunto para futuros posts.

## Inline

Os que possuem essa propriedade são considerados elementos de linha. Eles são renderizados dentro do bloco na mesma linha, ou seja, não tem quebra. `<span>` é o mais conhecido deles junto com `<a>`, `<b>` e `<i>`. Esses elementos podem ser colocados dentro de um parágrafo (que é um bloco), sem quebrar seu fluxo.

<p data-height="300" data-theme-id="23784" data-slug-hash="WRbmOK" data-default-tab="html,result" data-user="FernandaBernardo" data-embed-version="2" data-pen-title="Display Inline" class="codepen">Veja o exemplo <a href="http://codepen.io/FernandaBernardo/pen/WRbmOK/">Display Inline</a> by Fernanda Bernardo (<a href="http://codepen.io/FernandaBernardo">@FernandaBernardo</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## None

Este valor é usado para esconder algum elemento. Mas existem elementos que possuem esse valor de *display* por padrão, como por exemplo, o `<script>`.

<p data-height="300" data-theme-id="23784" data-slug-hash="ygywPw" data-default-tab="html,result" data-user="FernandaBernardo" data-embed-version="2" data-pen-title="Display None" class="codepen">Veja o exemplo <a href="http://codepen.io/FernandaBernardo/pen/ygywPw/">Display None</a> by Fernanda Bernardo (<a href="http://codepen.io/FernandaBernardo">@FernandaBernardo</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

Uma diferença que causa bastante dúvida quando temos o `display: none`, é quando esse é comparado com o `visibility: hidden`. A diferença entre eles, é que o *display* realmente retira todo o elemento da tela, como se ele não existisse, já com visibility o elemento não aparece mas continua ocupando o espaço como se estivesse visível.

## Inline-block

Esses elementos possuem uma mistura de propriedades. Como o próprio nome diz, tem a característica de ser em linha como um elemento *inline* e de ser um elemento em bloco como o *block*. A diferença entre um elemento *inline* e um *inline-block* está em elementos *inline-block* respeitarem os tamanhos personalizáveis, como *width*, *height*… Enquanto os que são *inline* não respeitam, apenas levam em consideração o *line-height*. 

<p data-height="300" data-theme-id="23784" data-slug-hash="GrgeQM" data-default-tab="css,result" data-user="FernandaBernardo" data-embed-version="2" data-pen-title="Display Inline-Block" class="codepen">Veja o exemplo <a href="http://codepen.io/FernandaBernardo/pen/GrgeQM/">Display Inline-Block</a> by Fernanda Bernardo (<a href="http://codepen.io/FernandaBernardo">@FernandaBernardo</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

# Table

Como o próprio nome já diz, é possível renderizar elementos como se fossem tabelas. É preciso tomar cuidado com essa propriedade, com o quesito acessibilidade. Se queremos estilizar um elemento como uma tabela, ela não deveria ser uma tabela na sua essência, ou seja, no HTMl? Por isso, cada caso deve ser analisado e pensado com cuidado. Existem alguns tipos de `display` capazes de estilizar elementos como tabelas, entre eles `table`, `table-row` e `table-cell` que se assemelham às tags `<table>`, `<tr>` e `<td>` do HTML.

<p data-height="300" data-theme-id="23784" data-slug-hash="JEdxXv" data-default-tab="css,result" data-user="FernandaBernardo" data-embed-version="2" data-pen-title="Display table" class="codepen">Veja o exemplo <a href="http://codepen.io/FernandaBernardo/pen/JEdxXv/">Display table</a> by Fernanda Bernardo (<a href="http://codepen.io/FernandaBernardo">@FernandaBernardo</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>


Nesse post, falamos um pouco de como funciona alguns atributos da propriedade `display` e sobre como usá-los. Nos próximos posts abordarei sobre outras propriedades comuns e também sobre novas especificações. 