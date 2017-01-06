---
date: 2017-01-06
category: front-end
tags:
  - HTML
  - semântica
  - acessibilidade
author: rapahaeru
layout: post
title: Os papéis do WAI-ARIA no HTML
description: O ARIA se divide semanticamente em três partes, as roles, seus estados e suas propriedades. Nesse post vamos focar nas roles e entender o seu real papel no HTML.
---

O ARIA se divide semanticamente em três partes, as roles, seus estados e suas propriedades.
As roles descrevem widgets que não estão disponíveis no HTML 4, como sliders, barras de menus, guias e diálogos. As propriedades descrevem características desses widgets, como se eles são arrastáveis, têm um elemento necessário ou têm um popup associado a eles. Os estados descrevem o estado de interação atual de um elemento, informando a tecnologia de assistência se ela estiver ocupada, desativada, selecionada ou ocultada.

No [post anterior](http://engenharia.elo7.com.br/html-semantico-1/), demos uma introdução conceitual do uso do WAI-ARIA. Nesse segundo trataremos das roles com alguns estados e propriedades que são necessárias para o uso correto, porém o próximo e último post será dedicado exclusivamente aos estados e propriedades.

## As roles

ARIA permite que os desenvolvedores declarem uma função semântica para um elemento que não ofereça semântica ou uma incorreta. Por exemplo, quando uma lista desordenada é usada para criar um menu, o `<ul>` deve ser dado um papel(role) de menu e cada `<li>` deve ser dado um papel de menuitem.
```html
<ul role="menu">
    <li aria-role="menuitem">home</li>
    <li aria-role="menuitem">posts</li>
    <li aria-role="menuitem">contato</li>
</ul>
```
As roles são categorizadas em 4 tipos:

1 - Abstract
2 - Widgets
3 - Document Structures
4 - Landmarks

Vamos falar mais dos Widgets, Document Structure e Landmarks, mas para não passar em branco, o que seriam as Abstract roles? Podemos dizer que eles fazem o papel trás das cenas, e as roles (widget, document structure e Landmarks) herdam propriedades dos papéis abstratos, confuso né? Para facilitar, veja esse [diagrama de taxonomia](https://www.w3.org/TR/wai-aria/rdf_model.png).

## Widgets

São widgets normais de interface, como caixas de alerta, botões, progress bar e etc.

Exemplo:

- tooltips
    É um popup que exibe informações relacionadas a um elemento quando recebe foco do teclado ou no mouse hover.

1 - O elemento que serve de container para o tooltip, deve possuir a role tooltip.
2 - O elemento que aciona a Tooltip é referenciado com o atributo aria-describedby

```html
<div class="tooltip-info" aria-describedby="tooltip_text">Info
  <span class="tooltip-text" id="tooltip_text" role="tooltip">Informação deste item</span>
</div>
```

Interação via teclado
`ESC`: Fecha o Tooltip

- Tabs
    São um conjunto de seções que exibem um painel com conteúdos diferentes, por vez. Cada tab possui um elemento associado, que quando ativado, exibe o conteúdo correspondente.

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

 Roles, estados e propriedades do widget `Tab`

`Tablist`: Serve de container para o conjunto dos tabs.
`Tab`: É o titulo da tab e exibe o painel (tabpanel) quando ativado.
`Tabpanel`: Contém o conteúdo associado a tab
`Aria-labelledby`: Serve para rotular o elemento associado (através do id)

Suporte por teclado

`Tab`: move o foco da aba ativa
`Seta para esquerda`: move o foco para a aba anterior
`Seta para direita`: move o foco para a aba seguinte
`Home`: move o foco para a primeira aba
`End`: move o foco para a última aba

- Menu
É  um tipo de widget(ferramenta) que oferece uma lista de opções para o usuário.
A role menu, é apropriada quando uma lista de *menuitems* é exibido de forma semelhante a uma aplicação de desktop, ou seja, é o simples menu que conhecemos.

```html
<div role="menubar">
    <ul role="menu">
        <li role="menuitem">Item 1</li>
        <li role="menuitem">Item 2</li>
        <li role="menuitem">Item 3</li>
    </ul>
</div>
```

Para ser acessível via teclado, o desenvolvedor terá que gerenciar o foco dos elementos.

## Document Structures

Como o nome diz, são estruturas que organizam o conteúdo em uma página

- article
É uma simples seção de uma página que forma uma parte independente de um documento.

```html
<div class="post" role="article">
   <p>Texto</p>
</div>
```
Todos sabemos que já possuímos a tag "article", porém com esta role, podemos ampliar para qualquer elemento fazer parte de forma independente, sem que a tag article seja implementada de forma errônea.


- Toolbar
    um toolbar pode agrupar botões, links e caixas de seleção em uma única tabulação.
    Neste caso, um toolbar bem simples com 3 botões para ilustrar a idéia:

```html
<div role="toolbar">
    <div role="button" tabindex="0" aria-selected="true">Tool 1</div>
    <div role="button" tabindex="1">Tool 2</div>
    <div role="button" tabindex="2">Tool 3</div>
</div>
```

Suporte por teclado

O botões do menu podem ser acionados através de `enter`, caso em algum deles tenha um popup (submenu), o mesmo pode ser acionado via `enter` ou `seta para baixo(down arrow)`
`Tab`: Move o foco para dentro e para fora do toolbar. Quando foco move para o toolbar, o primeiro controle habilitado recebe foco.
`Seta para esquerda`: Movo o foco para o controle anterior.
`Seta para direita`: Move o foco para o controle seguinte.
`Home`: Move o foco para o primeiro controle.
`End`: Move o foco para o último controle.

- Presentation

Sabemos que o ARIA é usado principalmente para expressar semântica dos elementos, porém há casos que ocultar a semântica de um elemento é importante e também ajuda algumas tecnologias assistivas.

Exemplo de uma imagem

Quando a role=presentation é aplicada a uma imagem, a imagem é completamente escondida das tecnologias assistivas. como se estivesse aplicado o estado de aria-hidden=true. Por outro lado, se o mesmo for aplicado a um cabeçalho, o valor semântico do elemento será removido mas o texto continua sendo exibido normalmente.

```html
<h3>Exemplo de presentation</h3>
<p>
    <a href="//link.to.com">primeiro link</a>
    <img alt="descrição da imagem" src="//images.cdn.com"'>
    <a href="//link.to.com">segundo link</a>
    <img alt="descrição da imagem" src="//images.cdn.com"'>
</p>
```

Veja como ficou a árvore de acessibilidade:

h3
    .[text] Exemplo de presentation
p
a
    .[text] primeiro link
a
    .[text] segundo link

A `role=presentation` remove o `<img>` da árvore de acessibilidade e com ele o atributo `alt`.


## Landmarks

Serve para marcar regiões importantes da página, como forms, banners e etc.

- Complementary

Uma seção de suporte do documento, complementa o conteúdo principal em um nível similar na hierarquia DOM. Pode ser usado como artigos relacionados, arquivo de blogs por exemplo.

```html
<aside role="complementary">
...
</aside>
```
- Banner

O nome ja diz, é uma secão onde é incluído itens como o logotipo ou a identidade do patrocinador de um site.
por exemplo, podemos aplicar em um footer com a lista de patrocinadores de um evento.

```html
<footer>
    <div role="banner">
        <img src="//logo.patrocinador.com/image.jpg" alt="Logo do patrocinador">
    </div>
    <div role="banner">
        <img src="//logo.patrocinador.com/image.jpg" alt="Logo do patrocinador">
    </div>
</footer>
```

- Navigation
    Agrupa elementos de navegação, que normalmente são links para navegar por um documento, ou um documento relacionado. Seria mais ou menos um mix do papel das tags `<aside>` e `<nav>`. Como podemos aplicar a qualquer elemento, genericamente poderia ficar assim.

```html
<div role="navigation">
    ...
</div>
```
- Main
Onde fica o conteúdo principal do elemento.

```html
<section role="main">
    ...
</section>
```

No próximo post focaremos nos estados e propriedades dessas roles.
Espero que tenha ficado claro o papel das roles no WAI-ARIA e conceitualmente o real propósito do seu uso.


