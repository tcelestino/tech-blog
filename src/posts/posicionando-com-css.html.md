---
date: 2016-10-24
category: front-end
tags: float, inline-block, flex, alinhamento vertical
author: AlineLee
layout: post
title: Posicionando elementos com CSS
description: Posicionando elementos na tela com css utilizando diferentes técnicas e ponderando pontos positivos e negativos de cada uma.
---
Posicionar elementos na tela em layout responsivo pode ser uma das partes mais chatas na construção de um site.
Muitas vezes decidir qual método utilizar, considerando suas vantagens e desvantagens, é a chave para uma economia valiosa de tempo no desenvolvimento.
Vamos considerar que queremos exibir uma simples galeria de imagens, essa galeria deve exibir cinco imagens posicionadas em uma linha, não permitindo que as imagens fiquem esticadas. Caso a tela seja pequena demais elas devem diminuir de tamanho proporcionalmente.

![Alt "Exemplo de layout"](../images/posicionando-com-css-1.png)

Para isso, aplicaremos três diferentes técnicas.

O HTML estilizado será assim, uma lista de imagens:

```HTML
<ul class="galeria-inline">
    <li><img src="img/beatriz.png"></li>
    <li><img src="img/david.png"></li>
    <li><img src="img/camila.png"></li>
    <li><img src="img/guto.png"></li>
</ul>
```

## float: left

O float possui o poder de fazer um elemento flutuar para direita ou esquerda, ocupando o espaço livre e fazendo com que o resto do conteúdo se encaixe ao seu redor. Desta maneira conseguimos deixar as imagens posicionadas uma ao lado da outra.

O CSS ficará assim:

```CSS
.galeria-float li {
    box-sizing: border-box;
    float: left;
    max-width: 20%;
}
```
Porem o resultado seria algo desse tipo:

![Alt "Exemplo de layout quebrado utilizando float"](../images/posicionando-com-css-2.png)

Um dos problemas desta abordagem é que como a `<ul>` possui filhos flutuantes, ela deixa de conhecer o próprio tamanho e acaba, por exemplo, não pintando o background-color, uma vez que a `<ul>` tem tamanho 0. Uma maneira simples de se corrigir isso é utilizando a propriedade overflow, que irá forçar a `<ul>` a calcular o tamanho de seus filhos.

```CSS
.galeria-float {
    overflow: auto;
}
```
Um ponto de atenção que pode ser observado na imagem é que caso sobre espaço após as imagens os elementos seguintes poderão se encaixar nele. Considerando que não precisamos do `overflow` uma outra opção é utilizar o `clear-fix`, que é muito utilizado nesses casos, algo como `clear:left` ou `clear:both` no primeiro elemento que não deve mais flutuar para quebrar a regra.

```CSS
.proximo-elemento-nao-flutuante {
    clear-fix: both;
}
```
![Alt "Exemplo de com clear-fix"](../images/posicionando-com-css-3.png)

Outro problema é que o float não possui meios para a distribuição do espaço entre as `<li>`s automáticamente e por isso é necessário incluir um valor manualmente, utilizando por exemplo um padding-right ou um margin-right para não deixar as imagens coladas. Ou seja, caso algo mude no layout esse valor deverá ser alterado.

Assim incluimos mais uma regra de CSS, e mantemos apenas o overflow, neste caso o clear-fix não é necessário:

```CSS
.galeria-float {
    overflow: auto;
}

.galeria-float li {
    box-sizing: border-box;
    float: left;
    max-width: 20%;
    padding-right: 1.3em;
}
```
### Prós e Contras
Prós
- Muito bem suportado pelos navegadores.
- Muito utilizado e documentado.

Contras
- Trabalhoso!
- É necessário fazer clear-fix, quando o float começa a influenciar indesejavelmente no layout dos outros elementos.
- Não é possível centralizar verticalmente ou horizontalmente.
- Pode alterar a ordem dos elementos HTML na tela, estragando por exemplo a ordem dos indexes.
- Caso você adicione outra imagem, terá que alterar o CSS.

## display: inline-block

O inline-block consegue dispor os elementos um ao lado do outro, quebrando a linha sempre que o elemento for grande demais. É muito bem aceito pelos browsers, não precisa de clear-fix e diferente do inline respeita o width e height.
Porém um problema é que quando combinamos ele com porcentagens dificilmente conseguiremos chegar aos 100%, isso porque a própria quebra de linha do HTML inclui um pixel fantasma no layout e se você não gosta de números mágicos surgindo no CSS, não vai curtir isso. Existem maneiras de resolver isso (infelizmente nem todas muito polidas).
Uma delas é deixar o último `<li>` menor mesmo. Assim a soma de todos os elementos será menor que 100%, e seu layout não quebrará.

O que também funciona é comentar a quebra de linha do HTML, algo assim:

```HTML
<ul class="galeria-inline">
    <li><img src="img/beatriz.png"></li><!--
    --><li><img src="img/david.png"></li><!--
    --><li><img src="img/camila.png"></li><!--
    --><li><img src="img/guto.png"></li>
</ul>
```
Você também pode utilizar o font-size: 0, com isso todo o texto ficará tão pequeno que não irá aparecer na tela. É possivel usar quando não se tem texto no ponto aplicado, o problema é que as medidas em `em` deixarão de funcionar pois você zerou o valor que ele se baseia, caso você precise utilizar, terá que definir novamente o font-size utilizando `px` mesmo.

```HTML
<ul class="galeria-inline">
    <li><img src="img/beatriz.png"></li>
    <li><img src="img/david.png"></li>
    <li><img src="img/camila.png"></li>
    <li><img src="img/guto.png"></li>
</ul>
```

```CSS
.galeria-inline {
    padding-right: 1em;
    text-align: center;
    font-size: 0;
}
.define-novamente-o-font-size {
    font-size: 16px;
}
```

Acredito que a opção mais polida delas (mas nem tanto), é deixar de fechar as tags `<li>`. Se você utiliza `Doctype HTML5`, na teoria não é necessário fechá-las e isso irá remover o bug.

O código ficará assim:

```HTML
<ul class="galeria-inline">
    <li><img src="img/beatriz.png">
    <li><img src="img/david.png">
    <li><img src="img/camila.png">
    <li><img src="img/guto.png">
</ul>
```

Infelizmente semelhante ao `float`, o `display-inline` não distribui o espaço automáticamente entre os elementos. Porem diferente do float é possivel centralizar verticalmente utilizando o `text-align: center`, possibilitando contornar melhor o problema, entretando definimos paddings na `<li>` para definir o espaço minimo entre as imagens.

```CSS
.galeria-inline {
    padding-right: 1em;
    text-align: center;
}

.galeria-inline li {
    padding-left: 0.1em;
    padding-right: 0.1em;
    box-sizing: border-box;
    display: inline-block;
    width: 20%;
}
```

### Prós e Contras
Prós
- Bem suportado pelos navegadores.
- Muito utilizado e documentado.
- Fácil de utilizar.
- É possível centralizar verticalmente.

Contras
- Quando utilizado com porcentagens, a somatória do tamanho ocupado pelos elementos nunca chega em 100%, isso porque infelizmente as quebras de linhas existentes no HTML serão levadas em consideração no cálculo, diminuindo a área disponível.
- Caso você adicione outra imagem, terá que alterar o CSS.

## display: flex

O flex é uma abordagem mais recente, por isso, nem pense em Internet Explorer (IE) do 9 para trás. Mas se esse não é o seu caso você está com sorte.
Desta maneira combinando o `display: flex` com o a propriedade `space-between` teremos todas as imagens alinhadas e com o espaço que sobrar alinhado entre elas.

```CSS
.galeria-flex {
    padding-right: 1em;
    display: flex;
    flex-direction: row-reverse;
    justify-content: space-between;
}

.galeria-flex li {
    padding-left: 0.1em;
    padding-right: 0.1em;
    box-sizing: border-box;
}
```
O alinhamento vertical e horizontal que é bem dificil nas outras técnicas acaba sendo mais viável com o flex e com mais opções. Por exemplo, considerando que a galeria é mais alta, poderiamos alinhar todos os items no centro utilizando:

```CSS
.galeria-flex {
  align-items: center; //Poderia ser flex-start | flex-end | center | baseline | stretch
}
```
![Alt "Exemplo de align-items center com flex"](../images/posicionando-com-css-4.png)

Ou então poderiamos criar regras mais especificas e alinhas os itens pares em baixo:
```CSS
.galeria-flex li:nth-child(2n) {
  align-self: flex-end; //Poderia ser flex-start | flex-end | center | baseline | stretch
}
```
E os itens impares no meio:

```CSS
.galeria-flex li:nth-child(2n+1) {
  align-self: flex-center; //Poderia ser flex-start | flex-end | center | baseline | stretch
}
```
![Alt "Exemplo de align-self center e flex-end"](../images/posicionando-com-css-5.png)

O interessante do flex é que com ele além de conseguir resolver os problemas que nós temos com as outras técnicas, ainda temos muitas possibilidades disponíveis, como por exemplo inverter a ordem das imagens apenas com propriedade a `flex-direction: row-reverse`.

### Prós e Contras
Prós
- Alinhamento vertical.
- Alinhamento horizontal.
- É possível facilmente alterar a ordem dos elementos, dizendo qual a posição que cada elemento deve aparecer.
- Com o flex você consegue até determinar se os itens devem estar dispostos em linha ou coluna e até mesmo inverter elas.
- Você consegue fazer o mesmo de várias formas utilizando o flexbox.
- As propriedades Grow e Shrink, abrem várias possibilidades pois com elas você pode escolher itens que ficarão proporcionalmente maiores que os outros e determinar o quanto ele pode encolher.

Contras
- Não é bem suportado, o que traz a necessidade de se utilizar fallbacks, prefixos ...
- Diversas versões diferentes, que trocam não só os prefixos mas com os nomes das propriedades e maneiras de se aplicar totalmente distintas.
- Por possuir várias versões, que irão funcionar de maneiras diferentes em diferentes cenários, acaba ficando difícil de aplicar.
- Como possui muitas propriedades, que nem sempre são tão intuitivas, você precisa estudar e por vezes relembrar o que elas fazem.

Você pode conferir um exemplo destas abordagens aqui [Galeria](https://alinelee.github.io/galeria-exemplo/)
