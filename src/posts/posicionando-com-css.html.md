---
date: 2016-10-24
category: front-end
tags:
  - css
author: AlineLee
layout: post
title: Posicionando elementos com css
description: ...
---
Posicionar elementos na tela em layout responsivo pode ser uma das partes mais chatas na construção de um site. Muitas vezes decidir qual método utilizar, considerando suas vantagens e desvantagens, é a chave para uma economia valiosa de tempo no desenvolvimento.

Vamos considerar que queremos exibir uma simples galeria de imagens. E para isso utilizar as três técnicas.

Ah! A galeria deve exibir cinco imagens posicionadas em uma linha, não permitindo que as imagens fiquem esticadas, caso a tela seja pequena demais elas devem diminuir de tamanho proporcionalmente.

## float: left

O float possui o poder de fazer um elemento flutuar para direita ou esquerda ocupando o espaço livre, e fazendo com que o resto do conteúdo se encaixe ao seu redor. Desta maneira conseguimos deixar as imagens posicionadas uma ao lado da outra.

Um dos problemas desta abordagem é que como a `<ul>` possui filhos flutuantes, ela deixa de conhecer o próprio tamanho e acaba, por exemplo, não pintando o background-color, uma vez que a `<ul>` tem tamanho 0. Uma maneira simples de se corrigir isso é utilizando a propriedade overflow, que irá forçar a `<ul>` a calcular o tamanho de seus filhos.

Outro problema é que o float não possui meios para a distribuição do espaço entre as `<li>` s e por isso é necessário incluir um padding-right fixo para não deixar as imagens coladas. Ou seja, caso algo mude no layout esse valor deverá ser alterado.

Outro ponto de atenção é que caso sobre espaço após as imagens os elementos seguintes poderão se encaixar nele, e pra impedir isso podemos dispor de um pouco mais de código e utilizar o clear-fix, técnica muito utilizada nesses casos, algo como clear:left ou clear:both nos elementos que não devem mais flutuar.

O codigo ficará assim:

```css
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
- Não é possível centralizar verticalmente, ou horizontalmente.
- Pode alterar a ordem dos elementos html na tela, estragando por exemplo a ordem dos indexes.
- Caso você adicione outra imagem, terá que alterar o css.

## display: inline-block

O inline-block consegue dispor os elementos um ao lado do outro, quebrando a linha sempre que o elemento for grande demais. É muito bem aceito pelos browsers, não precisa de clear-fix e diferente do inline respeita o width e height ;)
Porém um problema é que quando combinamos ele com porcentagens dificilmente conseguiremos chegar aos 100% isso porque a própria quebra de linha do html inclui um “pixel fantasma” no layout e se você não gosta de números mágicos surgindo no css, não vai curtir isso. Existem maneiras de resolver isso (infelizmente nem todas muito polidas).
Uma delas deixar o último `<li>` menor mesmo. Assim a soma de todos os elementos será menor que %, e seu layout não quebrará. O que também funciona é comentar a quebra de linha do html, algo assim:

```html
<ul class="galeria">
    <li><img src="img/beatriz.png"></li><!--
    --><li><img src="img/david.png"></li><!--
    --><li><img src="img/camila.png"></li><!--
    --><li><img src="img/guto.png"></li>
</ul>
```
Você também pode utilizar o font-size: 0. O problema é que o `em` deixará de funcionar e caso você precise utilizar, terá que setar novamente o font-size.
E, acredito que a mais polida delas (mas nem tanto), é deixar de fechar as tags `<li>`, se você utiliza Doctype html5, na teoria não é necessário fechá-las e isso irá remover o bug.

O código ficará assim:

```css
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
- Quando utilizado com porcentagens, a somatória do tamanho ocupado pelos elementos nunca chega em 100%, isso porque infelizmente as quebras de linhas existentes no html serão levadas em consideração no cálculo, diminuindo a área disponivel.
- Caso você adicione outra imagem, terá que alterar o css.

## display: flex

O flex é uma abordagem mais recente, por isso, nem pense em IE do 9 para trás. Mas se esse não é o seu caso você está com sorte.
Desta maneira combinando o display: flex com o space-between teremos todas as imagens alinhadas e com o espaço que sobrar alinhado entre elas.

```css
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
### Prós e Contras
Prós
- Alinhamento vertical.
- Alinhamento horizontal.
- É possível facilmente alterar a ordem dos elementos, dizendo qual a posição que cada elemento deve aparecer.
- Com o flex você consegue até determinar se os itens devem estar dispostos em linha ou coluna e até mesmo inverter elas.
- Você consegue fazer o mesmo de várias formas utilizando o flexbox.
- As propriedades Grow e Shrink, abrem várias possibilidades pois com elas você pode escolher itens que ficarão proporcionalmente maiores que os outros e determinar o quanto ele pode encolher.

Contras
- Não é bem suportado. ='(
- Diversas versões, não só alterando os prefixos mas também com nomes totalmente diferentes.
- Por ter várias versões, que irão funcionar de maneiras diferentes em diferentes cenários, acaba ficando difícil de aplicar.
- Como possui diversas propriedades, que nem sempre são tão intuitivas, você precisa estudar e por vezes relembrar o que elas fazem.

Você pode conferir um exemplo destas abordagens aqui [Galeria](https://alinelee.github.io/galeria-exemplo/)
