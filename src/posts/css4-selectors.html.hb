---
date: 2015-11-16
category: front-end
layout: post
title: CSS4 – Seletores nível 4
description: O CSS3 já está aí com força total, mas poucos sabem que o CSS4 já está em rascunho desde 2011 e muitas funções hoje são usadas sem você saber. Um dos focos dessa versão são os novos seletores. Neste post irei falar um pouco sobre o que vem por aí...
---

O CSS3 já está aí com força total, mas poucos sabem que o CSS4 já está em rascunho desde 2011 e muitas funções hoje são usadas sem você saber. Um dos focos dessa versão são os novos seletores. Neste post irei falar um pouco sobre o que vem por aí, este tema foi uma apresentação realizada em um TechTalk do Elo7 e os slides estão no final do post.

Range

Hoje com os novos seletores é possível tratar elementos que estão limitados por um range, com as pseudo-classes in-range e out-of-range. Esse é um dos recursos que muitos browsers já suportam.

HTML

1
2
3
&lt;form&gt;
    &lt;input type='number' id='quantidade' min='1' max='5' /&gt;
&lt;/form&gt;
CSS

1
2
3
4
5
6
7
input[type=&quot;number&quot;]:in-range {
    border-color: green;
}
 
input[type=&quot;number&quot;]:out-of-range {
    border-color: red;
}
Browsers que suportam:

Chrome 10.0
Firefox 28.0
Opera 11.0
Safari 5.2
Optionality

As pseudo-classes de “opcionalidade” servem para tratar elementos de inputs e formulários que são obrigatórios ou não.

HTML

1
2
3
4
&lt;form&gt;
    &lt;input type='email' placeholder='Seu email' required /&gt;
    &lt;input type='text' placeholder='Seu nome' optional /&gt;
&lt;/form&gt;
CSS

1
2
3
4
5
6
7
input:optional {
    border-style: dotted;
}
 
input:required {
    border-color: red;
}
Browsers que suportam optionality:

Chrome 10.0
Firefox 4.0
Opera 10.0
Safari 5.0
Internet Explorer 10.0
Mutability

As pseudo-classes de “mutabilidade” representam os elementos que permitem ou não alteração pelo usuário.

HTML

1
2
3
4
5
6
7
8
9
10
11
12
&lt;p contenteditable='false'&gt;
    Apenas de leitura
&lt;/p&gt;
 
&lt;p contenteditable='true'&gt;
    Conteúdo editável
&lt;/p&gt;
 
&lt;form&gt;
    &lt;input type='text' value='Olar amigo' readonly&gt;
    &lt;input type='text' value='Olar amigo 2'&gt;
&lt;/form&gt;
CSS

1
2
3
4
5
6
7
8
9
input:read-only,
p:read-only {
    background: red;
}
 
input:read-write,
p:read-write {
    background: green;
}
No exemplo acima, adicionamos um atributo “contenteditable” para tornar o elemento editável. No HTML5 qualquer elemento pode se tornar editável e este recurso tem suporte em diversos browsers (Firefox 3.5+, Chrome 4.0+, Internet Explorer 5.5+, Safari 3.1+).

Placeholder

A pseudo-classe placeholder-shown seleciona elementos input que estão exibindo o placeholder.

HMTL

1
2
3
&lt;form&gt;
    &lt;input type='text' placeholder='Digite seu nome aqui' /&gt;
&lt;/form&gt;
CSS

1
2
3
4
input:placeholder-shown {
    background: #000;
    color: #FFF;
}
Matches

A pseudo-classe matches ajuda a realizar seletores de agrupamento mais simples. Atualmente nenhum browser suporta esse seletor, eles utilizam any com o prefixo para  Webkit e Mozilla.

HTML

1
2
3
4
5
6
&lt;ul&gt;
    &lt;p&gt;Mensagem 1&lt;/p&gt;
    &lt;p class='fechado'&gt;Mensagem 2&lt;/p&gt;
    &lt;p class='nao-lida'&gt;Mensagem 3&lt;/p&gt;
    &lt;p class='cancelado'&gt;Mensagem 4&lt;/p&gt;
&lt;/ul&gt;
CSS

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
p:matches(.fechado, .cancelado, .nao-lida) {
    color: red;
}
 
p:-moz-any(.fechado, .cancelado, .nao-lida) {
    color: red;
}
 
p:-webkit-any(.fechado, .cancelado, .nao-lida) {
    color: red;
}
 
/* equivalente:
 
p.fechado,
p.nao-lida,
p.cancelado {
    color: red;
} */
Browsers que suportam any:

Chrome 12.0(-webkit)
Firefox 4.0(-moz)
Safari 5.0(-webkit)
Not

Presente no CSS3, agora ele possui suporte para receber mais de um argumento essa nova aplicação ainda não é suportada pelos browsers. O comportamento deste seletor é o seguinte: ele aplica a regra aos elementos que não se enquadram ao seletor como nome sugere uma negação.

HTML

1
2
3
4
5
6
&lt;ul&gt;
    &lt;li&gt;Compra 1&lt;/li&gt;
    &lt;li class='cancelado'&gt;Compra 2&lt;/li&gt;
    &lt;li&gt;Compra 3&lt;/li&gt;
    &lt;li class='nao-lido'&gt;Compra 4&lt;/li&gt;
&lt;/ul&gt;
CSS

1
2
3
4
5
6
7
8
9
/* suportado */
li:not(.cancelado) {
    color: red;
}
 
/* ainda não suportado */
li:not(.cancelado, .nao-lido) {
    color: red;
}
Case Insensitive

Um problema antigo na seleção de elementos por parâmetros, muitas vezes o sistema ou usuário adiciona os arquivos com uma variação de caixa alta e baixa não esperada. Com esse novo recurso podemos selecionar itens independente de sua capitalização. Como podemos ver no exemplo abaixo:

HTML

1
2
3
&lt;a href=&quot;test.pdf&quot;&gt;Test 1&lt;/a&gt;     
&lt;a href=&quot;test.PDF&quot;&gt;Test 2&lt;/a&gt;             
&lt;a href=&quot;test.pDF&quot;&gt;Test 3&lt;/a&gt;
CSS

1
2
3
a[href$=&quot;pdf&quot; i] {
    color: red;
} 
No exemplo acima, todos os elementos conseguem ser selecionados. Isso antes não era possível, já que teríamos que criar um seletor para cada situação. Esse recurso ainda não foi implementado pelos browsers.

Direction

Com HTML é possível especificar a direção do texto. Esse é um recurso usado para alguns idiomas que são lidos em diferentes direções. Porém, ainda não existia um seletor para estilizar um conteúdo de acordo com sua direção. Este recurso ainda não foi implementado pelos browsers.

HTML

1
2
&lt;div dir=&quot;ltr&quot;&gt; Some text Default writing direction.&lt;/div&gt;
&lt;div dir=&quot;rtl&quot;&gt; بعض النصوص من اليمين إلى اليسار الاتجاه &lt;/div&gt;
CSS

1
2
3
4
5
6
7
:dir(ltr) {
    color: red;
}
  
:dir(rtl) {
    color: blue;
} 
Além desses recursos outros estão sendo implementados, mas listei os que mais curti. Abaixo você pode conferir os slides da apresentação:


Referências:

http://css4selectors.parseapp.com/
http://www.sitepoint.com/future-generation-css-selectors-level-4/
https://davidwalsh.name/css4-preview