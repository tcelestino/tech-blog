---
title: Conheça o Dust.js - parte 1
date: 2018-05-07
category: front-end
layout: post
description: Conheça a engine de template...
authors: [tcelestino]
tags:
  - front-end
  - js templates
  - dust.js
---

O time de front-end do Elo7, sempre está buscando novas tecnologias para compor o nosso fluxo de trabalho, mesmo quando algumas dessas tecnologias não estão sendo faladas nas redes sociais, meetups etc...Mas acreditamos que o principal interesse nessas ferramentas é o valor que irá entregar no desenvolvimento de novos serviços. Esse é o caso do [Dust.js](http://www.dustjs.com/), um *engine* de template javascript desenvolvido pelo o Linkedin e muita gente não conhece.

## Por que escolhemos o Dust.js?

Antes como utilizar o Dust.js, preciso dizer o porque que escolhemos a *engine* invés de escolher as diversas soluções existentes no mercad. Uma palavra resume tudo isso: PERFORMANCE! Sim, fizemos alguns estudos com outras *engine* e chegamos a conclusão que o Dust.js seria a escolha para utilizarmos em nosso serviço de componentes. Sem contar que estavamos buscando uma solução em seria possível trabalhar tanto do lado cliente (Client Side Render) quanto do servidor (Server Side Render), o famoso isomorfismo. Caso queria saber mais sobre Javascript isomórfico, recomendo ler o [post](https://engenharia.elo7.com.br/isomorfismo/) da [Fernanda Bernardo](https://twitter.com/Feh_Bernardo) sobre o assunto.

A permissa do Dust.js é não ter lógica na camada de visualização (view), mantendo a lógica na camada modelo (model), com isso, conseguimos manter nossas *views* sem regras de negócios. Enxergamos isso como uma boa prática, até porque não é a *view* que tem que cuidar se um conteudo vai aparecer ou não na tela, por exemplo.

Na prática, seria como o exemplo abaixo:

```javascript
{@eq key="userExists" value="true"}
  {@eq key="passwordOK" value="true"}
    {@gt key="userLevel" value=3}
      {@eq key="accountActive" value="true"}
        Welcome!
      {/eq}
    {/gt}
  {/eq}
{/eq}
```
<div style='text-align:center; font-style: italic'>Exemplo retirado do website do Dust.js</div>

Invés de termos uma lógica no nosso template, criamos um modelo e implementamos a lógica nele. Se pegarmos o caso acima e passarmos para um modelo, ficaria mais ou menos assim:

```javascript
{#userAuthenticated}
  Welcome!
{/userAuthenticated}
```
<div style='text-align:center; font-style: italic'>Exemplo retirado do website do Dust.js</div>

Agora que já sabemos um pouco da ideia por trás do Dust.js (se quiser entender mais profundamente, no [site](http://www.dustjs.com/) do projeto existem mais informações), vamos meter a mão no código.


## Iniciando o Dust.js

Nessa primeira parte, vamos abordar o funcionamento da *engine* e seu "comportamento". Para iniciar, vamos criar uma estrutura básica para exemplificar o uso do Dust.js.

<a class="jsbin-embed" href="http://jsbin.com/qatizuf/3/embed?html,output"></a><script src="http://static.jsbin.com/js/embed.min.js?4.1.4"></script>

Fazendo um resumo de como o código acima funciona, teriamos a seguinte estrutura de código:

- Carregamos o arquivo do dust.js e do dust-helpers (explicarei no futuro);
- Implementamos uma função de *callback* para escrever nosso template na página;
- Criamos um template (usando [Template Strings](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/template_strings)) e um objeto modelo;
- Usamos o metódo `renderSource` para renderizar o modelo (dados), template e a execução da *callback*.

Se você já usou alguma *engine* de template javascript ([handlebars](), [mustache](), etc...) vai perceber que o uso é "bem parecido". Criamos um objeto modelo contendo uma chave e que chamamos em nosso template. Até ai, nada diferente, correto?

## Entendendo os contextos

O Dust.js trabalha com contextos globais e isso pode soar bastante estranho no começo. No caso, o contexto é baseado na "árvore" do seu modelo. Ou seja, ele fará uma varredura no seu modelo até achar a chave correspondente usada no template.

Para exemplicar um pouco desse conceito, observe o código abaixo:

<a class="jsbin-embed" href="http://jsbin.com/rajahus/1/embed?html,output"></a><script src="http://static.jsbin.com/js/embed.min.js?4.1.4"></script>

Estamos pecorrendo o nosso objeto modelo para acessar os valores das chaves `{name}`, `{age}` e `{city}`, mas se observamos, a chave `{city}` não está associada a chave `persona` em nosso objeto e mesmo assim o Dust consegue compilar. Estranho? Bastante! O Dust ler os dados de "dentro para fora". Ou seja, ao percorrer a chave `{persona}`, a *engine* irá acessar todas as chaves daquele nó, caso não encontre uma chave, vai pecorrer para fora do nó, se existir ele vai compilar o *template*.

Esse comportamento pode ser bastante perigoso quando não temos controle dos dados (no caso de usar uma API de terceiros, por exemplo), mas isso é uma das "coisas" estranhas que observamos durante esse tempo de uso da *engine*.

Como um exercicio de curiosidade, remova a chave `{city}` e veja o acontece. :)

## Iterando e usando condicionais

Nessa primeira parte, vamos abordar essas duas diretrizes de uso do Dust.js. Ao longo dos próximos posts (serão poucos, eu prometo!) vamos aprender mais recursos avançados e que serão de boa valia para caso comece a usar o Dust.js em seus projetos.

### Iterando objetos

### Condicionais
