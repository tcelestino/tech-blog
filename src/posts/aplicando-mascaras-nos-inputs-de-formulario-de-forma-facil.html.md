---
date: 2017-03-28
category: front-end
layout: post
title: Aplicando máscaras nos inputs de formulário com mask-amd
description: Que tal otimizar seu tempo e seu HTML com uma biblioteca focada diretamente no que é preciso? Direto ao ponto, a mask-amd tem em seu único objetivo, formatar os campos de seu formulário.
author: rapahaeru
tags:
  - html
  - JavaScript
  - front-end
  - libs
---

Sempre procuramos uma biblioteca que seja bem focada no problema em que queremos resolver e normalmente encontramos aqueles pacotes com várias funcionalidades.
Quando vamos ver, utilizamos apenas uma função de toda aquela biblioteca. Não seria necessário dizer o peso inútil no final, agora imagine quando você utiliza várias bibliotecas em seu site?
Esse tipo de situação é muito comum e pensando nesse problema, nós aqui do Elo7, resolvemos escrever nossas próprias bibliotecas, diretas no que necessitamos na casa, e isso vem sendo bem bacana pois além de otimizar nossas aplicações, ainda as disponibilizamos para comunidade.

Iniciando esse trabalho, começarei aqui apresentando a nossa biblioteca [mask-amd](https://github.com/elo7/mask-amd), onde encontrar e como implementá-la.

## Quando a biblioteca mask-amd é útil?

Sabe quando o formulário possui aqueles inputs de medida? peso? data?

O **mask-amd** permite que você formate esses inputs da maneira que achar necessário, apenas adicionando um novo atributo com o pattern desejado, Vamos exemplificar mais a frente.

## Onde encontrar
Você pode baixar diretamente do nosso [repositório](https://github.com/elo7/mask-amd) ou através do gerenciador de pacotes [NPM](https://www.npmjs.com/package/mask-amd).

Para instalar através do NPM:

``` $ npm install mask-amd ```

Agora chame o arquivo “mask-amd.js” no HTML de sua aplicação.

```html
<script src='mask-amd.js'></script>
```

## Compreendendo as dependências

Como informado na introdução, gostamos de desenvolver o que é realmente necessário para nós, por tanto, optamos em desenvolver o nosso próprio framework, chamado [doc-amd](https://github.com/elo7/doc-amd/).

O [doc-amd](https://github.com/elo7/doc-amd/) é o framework desenvolvido e inspirado em outros do mercado, para manipular o DOM em qualquer navegador.

### Mas por que o AMD?

o [AMD](https://en.wikipedia.org/wiki/Asynchronous_module_definition) define uma API em módulos de códigos com dependências, e os carrega de forma assíncrona se quiser. Ou seja, o desenvolvedor pode definir as dependências que são necessárias para serem carregadas antes de seu módulo ser executado.

No caso da `mask-amd` Estamos definindo que nosso código só roda caso haja o `doc-amd` implementado na aplicação.

```javaScript
define('mask', ['doc'], function($) {
```
Aqui estamos definindo que o nome do nosso módulo `mask` e ele depende de `doc`.

## Implementação no código

Básicamente o biblioteca utiliza hoje dois tipos de atributos nos inputs do HTML, o `mask-number` e o `mask`.

* O atributo mask-number

Como pode parecer óbvio, este é focado nos inputs que desejam receber apenas formatação dos números, como medidas, moeda e etc.

A biblioteca tem um pattern dinâmico pensando em todas as situações que sejam necessárias.
Imagine seu input assim:

```html
<label for="peso">
	Peso (00.0):
	<input type="text" id='peso'>
</label>
```
Pensando exatamente como a label supõe, precisamos que:
* Sejam apenas números;
* possuam no máximo 3 números;
* e que o caracter separador seja um ponto.


```html
<label for="peso">
	Peso (00.0):
	<input type="text" id='peso' mask-number='00.0'>
</label>
```
Apenas adicionamos o atributo `mask-number` com o pattern desejado.

Mas e se caso eu queira inserir no mínimo 2 caracteres, porém também possa ter no máximo 3?
Deixando claro:

* Obrigatoriedade de 2 caracteres no mínimo;
* Máximo de 3 caracteres;
* Que sejam apenas números.

```html
<label for="peso">
	Peso (00.0):
	<input type="text" id='peso' mask-number='#0.0'>
</label>
```
Adicionando uma "#" ao conteúdo do atributo, o input fica aguardando um terceiro caracter porém sem a obrigatoriedade. Se inserir apenas os 2, ok, mas caso seja inserido 3, tudo bem também.

* O atributo mask

Este atributo é mais focado nas formatações de formulário, como telefones, datas e até mesmo cpf.

Vamos pensar em uma data agora?
Veja como é simples:

```html
<label for="data">
	Peso (00.0):
	<input type="text" id='data' mask='99/99/9999'>
</label>
```
Repare que o atributo mudou, agora é apenas `mask`.

E no caso de nós brasileiros, um CPF?
```html
<label for='cpf-1'>
	cpf (999.999.999-99):
	<input type='text' id='cpf-1' mask='999.999.999-99'>
</label>
```

E caso precise inventar algo?

```html
Inventado (88.99-00): <input type='text' mask='99.999-99'>
```
Também funciona. Fique livre para mascarar da forma que bem entender.

Caso queira um teste *live*, basta acessar o nosso gh-pages [aqui](https://elo7.github.io/mask-amd/).

Espero que seja útil de alguma forma e fiquem livres para sugerir melhorias.

Obrigado =]
