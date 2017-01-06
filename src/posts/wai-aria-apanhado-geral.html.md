---
date: 2017-01-06
category: front-end
tags:
  - HTML
  - semântica
  - Acessibilidade
author: rapahaeru
layout: post
title: Um apanhado geral sobre o WAI-ARIA
description: O que o desenvolvedor atual está fazendo para tornar seu conteúdo mais acessível para pessoas com algum tipo de deficiência? Com a evolução da web a usabilidade melhorou muito, porém usuários de tecnologias assistivas correm risco de serem excluídos por conta das lacunas de acessibilidade. Como leitores de tela normalmente sofrem com JavaScript, surge uma nova maneira de criar interfaces dinâmicas que são acessiveis a mais usuários.
---

Com a evolução da web, os sites estão ficando cada vez mais dinâmicos, utilizando muitos recursos de AJAX, Javascript e CSS. Essas mudanças melhoram muito a usabilidade na web, porém usuários de tecnologias assistivas correm risco de serem excluídos por conta das lacunas de acessibilidade. Como leitores de tela normalmente sofrem com JavaScript, surge uma nova maneira de criar interfaces dinâmicas que são acessiveis a mais usuários.

A maioria dos frameworks de JavaScript oferecem ferramentas do lado do cliente que simulam o comportamento de interfaces desktop e mobile para se tornarem mais familiares, como drag and drop, menu hamburguer deslizante... Todos eles são criados nessa combinação de javascript, css e html. Só que para criar tais elementos, as vezes é necessário recorrer a marcações mais genéricas do HTML, como `span`, `div`, que não representam corretamente seu significado (em determinados casos), e são nesses momentos em que é utilizado o ARIA.

Falamos anteriormente sobre o [significado da semântica no html](http://engenharia.elo7.com.br/html-semantico-1/), aqui no blog, caso queira se aprofundar mais no tema.

## Ampliando os significados

A vinda do HTML5 ja deixou as marcações de layout mais ricas, marcando os artigos, navegações, dentre outros. o ARIA serviria para estender ainda mais o significado dessas tags, não como os [microdados](http://engenharia.elo7.com.br/html-semantico-2/) que são bem úteis nessa função, mas com foco nas interações, como clique, *show/hide* de conteúdos colapsados para que não comprometa a acessibilidade dessas informações.

## WAI-ARIA, o que é ?

*Accessible Rich Internet Applications* (ARIA) uma iniciativa de acessibilidade(WAI) da [W3C](https://www.w3.org/) que fornece uma maneira de adicionar a semântica em falta em determinado elemento para tecnologias assistivas, como leitores de tela. Define formas de tornar o conteúdo da web (especialmente aqueles desenvolvidos com AJAX e JavaScript) mais acessível para pessoas que possuem algum tipo de deficiência. É um conjunto de atributos de acessibilidade especiais que podem ser adicionados a qualquer marcação, mas é especialmente adequado para HTML. O atributo role define o que o tipo geral de objeto é (como um artigo, alerta ou controle deslizante). Outros atributos ARIA fornecem outras propriedades úteis, como uma descrição para um formulário ou o valor atual de uma barra de progresso.

## Regras do WAI-ARIA

Existem cinco regras (por enquanto) para que seu código seja implementado de forma, conceitualmente correta.

### Primeira
Se você pode usar um elemento HTML nativo (HTML5) ou atributo com a semântica e o comportamento que você precisa já construídos, em vez de re-propôr um elemento e adicionar uma *role*, *state* ou *property* ARIA para torná-lo acessível, mantenha o nativo.

Exemplo:
```html
<ul role="list">
    <li role="listitem">Item da lista</li>
    <li role="listitem">Item da lista</li>
    <li role="listitem">Item da lista</li>
</ul>
```

As tags nativas do HTML já nos dizem semanticamente que é uma lista, essas roles estão fazendo um papel redundante.

### Segunda
Não mude a semântica nativa, a menos que você realmente precise.
Essa segunda regra complementa a anterior.

Exemplo ruim:
```html
<span role="button">ok</span>
```
Não precisa mudar semânticamente o `span`, já que eu possuo uma tag nativa que já faz esse papel

Exemplo bom:

Em um caso de [checkbox hack](https://css-tricks.com/the-checkbox-hack/), utilizamos a label como trigger de um checkbox, certo?
```html
<label for="chk_btn">Botão</label>
<input type="checkbox" id="chk_btn">
```

Neste caso, o papel do label seria de um botão, para disparar a ação, então podemos modificar semanticamente este elemento para um botão.
```html
<label for="chk_btn" role="button">Botão</label>
<input type="checkbox" id="chk_btn">
```

### Terceira
Todos os controles interativos do ARIA devem ser utilizáveis via teclado.

Se você criar um *widget* que um usuário pode clicar, tocar, arrastar, soltar, deslizar ou deslocar, um usuário também deve ser capaz de navegar até o widget e executar uma ação equivalente usando o teclado.

Todos os widgets interativos devem ser preparados via script para responder as ações via teclado, quando possível.

Por exemplo, se estiver usando o role="button", o elemento deve ser capaz de receber o foco e o usuário deve ser capaz de ativar a ação associada ao elemento usando a tecla enter (no WIN OS) ou o retorno (MAC OS) e a tecla de espaço.

### Quarta

Não use `aria-hidden="true"` se o elemento estiver visível, exemplo:
```html
<button aria-hidden="true">Ok</button>
```
Fazendo isso, o elemento não resultará seu valor semântico correto.

Ao invés disso, utilize `aria-hidden="false"` se estiver visível ou `aria-hidden="true"` quando não estiver visível.
Nota: Prefira utilizar nesse caso a propriedade `visibility: hidden`, pois se utilizar o `display: none`, o elemento some da árvore de acessibilidade, o que torna o aria-hidden desnecessário.

### Quinta

Todos os elementos que possuem interação, devem possuir nomes acessíveis.

Exemplificando, em um formulário de contato, precisa-se preencher o e-mail do usuário. Veja o código abaixo:
```html
E-mail <input type="text">
```
Ele possui uma informação visível `E-mail`, porém não acessível.
Há também outra forma erronea de se aplicar:
```html
<label>E-mail</label>
<input type="text">
```
A informação ainda não está acessível, já que a <label> precisa "abraçar" o elemento input para que a informação "E-mail" seja correspondente ao input.
```html
<label>
    E-mail <input type="text">
</label>
```
Podemos também adicionar um atributo que vincule o `input` a informação que queremos.
```html
<label for="email">E-mail</label>
<input id="email" type="text">
```
Obedecendo esses conceitos, já é uma boa porta de entrada para preparar o seu código de forma mais acessível, acessando esse [diagrama](https://www.w3.org/TR/wai-aria/rdf_model.png), você consegue ter uma ideia das roles e suas propriedades e estados, que falaremos mais pra frente.

É muito importante compreendermos as regras do WAI-ARIA para não nos perdermos no seu real conceito. Esta foi uma introdução de uma série de três posts sobre o tema. O próximo será focado nas roles do WAI-ARIA e suas categorias, exemplificando cada atributo.

Até.
