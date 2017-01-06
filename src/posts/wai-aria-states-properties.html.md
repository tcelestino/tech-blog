---
date: 2017-01-06
category: front-end
tags:
  - HTML
  - semântica
  - acessibilidade
author: rapahaeru
layout: post
title: Os estados e propriedades das roles no WAI-ARIA
description: Os termos "estados" e "propriedades" referem-se a características semelhantes. Ambos fornecem informações específicas sobre um objeto, e ambos fazem parte da definição da natureza das roles. Mas possuem diferenças sutis...
---

Neste terceiro post da série sobre WAI-ARIA, trataremos sobre os estados e propriedades das roles.
Caso queira saber mais, fizemos um apanhado geral introdutório [sobre o WAI-ARIA](http://engenharia.elo7.com.br/html-semantico-1/) e sobre o seu [papel no html](http://engenharia.elo7.com.br/html-semantico-1/).

Os termos "estados" e "propriedades" referem-se a características semelhantes. Ambos fornecem informações específicas sobre um objeto, e ambos fazem parte da definição da natureza das roles. São aplicados como atributos de marcação de arias prefixados.
São usados de formas distintas pois possuem uma diferença sutil de significado.
Uma grande diferença é que os valores de propriedades estão menos propensos a serem alterados/atualizados durante a execução de uma aplicação do que os valores de estados.

Exemplificando :

a propriedade aria-labelledby permanece fixado como atributo, informando a descrição de um elemento, já o estado aria-checked muda o valor com frequência de acordo com a interação do usuário (pois é um estado de input checkbox).

Tentarei explicar alguns estados e propriedades com alguns exemplos:

Exemplos de propriedades

aria-labelledby / aria-describedby

Indica a descrição de um determinado elemento, através do seu ID.
Se quero descrever o que um botão faz, posso usar :

```html
<button aria-describeby="btn-desc">
  send
</button>

<p id="btn-desc">
  Descrição da ação do botão
</p>
```
ou desta forma:
```html
<button id="btn-desc">
  send
</button>

<p aria-labelledby="btn-desc">
  Descrição da ação do botão
</p>
```

Claro que você também, pode utilizar de forma correto o label, tendo o mesmo valor semântico na árvore de acessibilidade:

```html
<label>
    user name
    <input type="text">
</label>
```
ou

```html
<label for="username">user name</label>
<input type="text" id="username">
```

Isso foi explicado no primeiro post introdutório<link>.

aria-activedescendant

ele é uma opção diferente para trabalharmos com o foco dos elementos.
Ao invés do foco automaticamente ir navegando de forma descendente, o autor pode definir o elemento exato que suporte o aria-descendent.

```html
<section role="toolbar" aria-activedescendant="btn-3" aria-hidden="true">
    <button id="btn-1"></button>
    <button id="btn-2"></button>
    <button id="btn-3"></button>
</section>
```
Esta section está escondida, ao ser ativada e com foco, o foco descendente irá diretamente ao que a propriedade está pedindo, que é o elemento com id="btn-3"


aria-controls

Identifica os elementos ou elemento que são controlados pelo elemento atual. Como por exemplo uma tablist <link para o role>.

```html
<div class="tabs">
    <div role="tablist">
        <button role="tab" aria-selected="true" aria-controls="apple-panel" id="apple-tab">Apple</button>
        <button role="tab" aria-selected="false" aria-controls="orange-panel" id="orange-tab">Orange</button>
    </div>
    <div role="tabpanel" id="apple-panel" aria-labelledby="apple-tab">
        <p>Apple panel content</p>
    </div>
    <div role="tabpanel" id="orange-panel" aria-labelledby="orange-tab">
        <p>Orange panel content</p>
    </div>
</div>
```
No caso, o button que faz o papel da tab, ao ser clicado, exibe o  seu painel correspondente.


has-popup

Indica a disponibilidade de um elemento pop-up, como por exemplo um submenu ou caixa de diálogo,sendo disparado por um elemento.
Um elemento pop-up aparece como um bloco de conteúdo que está na frente de outros conteúdos, em destaque. O autor deve ter certeza que o conteiner do elemendo a ser exibido, seja um menu, caixa de listagem, árvore, grid ou caixa de diálogo e que o valor de aria-haspopup corresponde à função do contêiner pop-up.

```html
<section aria-hidden="true">
    <ul role="menu" aria-activedescendant="item-2">
        <li role="menuitem" id="item-1">Item 1</li>
        <li role="menuitem" id="item-2">Item 2</li>
        <li role="menuitem" id="item-3">Item 3</li>
    </ul>
</section>

<button aria-haspopup="true">+</button>
```
Exemplos de estados

aria-expanded
É o estado que indica se o elemento está expandido ou colapsado.

Podemos utilizar o exemplo anterior, imaginando um efeito toogle de abrir e fechar o menu através da ação de clique no botão.

```html
<section aria-expanded="false">
    <ul role="menu" aria-activedescendant="item-2">
        <li role="menuitem" id="item-1">Item 1</li>
        <li role="menuitem" id="item-2">Item 2</li>
        <li role="menuitem" id="item-3">Item 3</li>
    </ul>
</section>

<button aria-haspopup="true">+</button>
```
Ao clicar no botão, o estado aria-expanded será trocado por True, via Javascript e o inverso também se repete.

aria-hidden
Indica quando o elemento está disponível na árvore de acessibilidade, aplicando true ou false.
Por exemplo, ele oculta para leitores de tela e ferramentas semelhantes. Isso é útil para componentes que são usados puramente por formatação e não contêm conteúdo relevante.


Validando seu codigo



The easiest method is to use the HTML5 DOCTYPE<https://www.w3.org/TR/html51/syntax.html#the-doctype> with ARIA markup and validate using the W3C Nu Markup Checker<http://validator.w3.org/nu/>. ARIA works equally well with any other DOCTYPE, but validation tools will produce errors when they encounter ARIA markup as the associated DTDs have not been updated to recognise ARIA markup and it is unlikely they ever will be.

These validation errors in versions of HTML prior of HTML5 are in no way indicative of ARIA creating any real world accessibility problems nor do they mean there will be a negative user experience. They are merely the result of old automated validation tests that do not accommodate ARIA accessibility annotations.

Note: The W3C Nu Markup Checker support for ARIA checking is a work in progress, so cannot be wholly relied upon (though it is pretty darn good!)to provide the correct results. It is recommended that if you encounter a result that conflicts with the ARIA conformance requirements in the ARIA specification or the HTML specification, please raise an issue.




O WAI-ARIA é muito bom e ao mesmo tempo soa redundante em alguns momentos. Há casos em que a semântica do HTML simples atende bem com seus significados, temos que saber dosar em qual momento é interessante aplicar esse conceito. Sempre lembrando que se o valor semântico é o mesmo e ficar redundante, sempre opte pelo a semântica nativa.
