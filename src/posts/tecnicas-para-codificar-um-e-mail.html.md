---
date: 2017-05-15
category: front-end
tags:
  - e-mail
  - html
  - css
author: erikatakahara
layout: post
title: Técnicas para codificar um e-mail
description: Todo front-end já passou por problemas ao codificar um e-mail, principalmente quando se trata de compatibilidade com todos os clientes de e-mail (Yahoo, Gmail, Outlook). Neste post iremos tratar de algumas técnicas e com o que devemos nos preocupar ao desenvolver um layout de e-mail.
---

Há alguns anos atrás, eu tive que codificar o meu primeiro e-mail marketing (aqueles e-mails promocionais que você geralmente recebe de um e-commerce). Como não conhecia muito sobre como funcionava os clientes de e-mail, fiz o código como se estivesse codificando um site: usei várias propriedade de css, abusei da propriedade `float` (que na época era moda), usei classes e coloquei todo o css dentro da tag `style`. O e-mail ficou igualzinho ao mock, mas quando fiz o primeiro teste de envio, nada do que tinha feito refletia o que esperava.

Quando abria o html que tinha feito em um navegador, tudo funcionava como deveria, então porque quando fazia o envio não tinha nada estilizado?

A resposta é simples, os clientes de e-mail, por questões de segurança, não aceitam nada disso. Eles esperam que o e-mail seja codificado como se estivéssemos na época do HTML 2.0. Ou seja, layout montado a base de tabelas, css inline e só as propriedades mais básicas de css, como `font-size`, `border`, `width`, `height`, etc.

É lógico que daquela época para cá houveram várias mudanças e hoje conseguimos utilizar mais recursos para montar e-mails. Neste post gostaria de falar algumas dessas mudanças e algumas técnicas novas para montar um e-mail.

Para facilitar a explicação, vamos montar o seguinte e-mail:

![Layout do e-mail](../images/tecnicas-para-montagem-de-e-mail-1.png)

## Background

Primeiramente vamos adicionar a cor de fundo azul (#798C98) no fundo do e-mail. Normalmente, adicionaríamos no `body` a propriedade `background-color: #798C98`, mas infelizmente isso não funciona na maioria dos clientes. Portanto, vamos seguir com uma outra abordagem.

A forma mais aceita em todos os clientes de e-mail é usar a tag `table`, mesmo não sendo semanticamente correto esta ainda é a melhor abordagem.

Para adicionar a cor vamos usar o atributo `bgcolor` e, como não temos um reset para os padrões de cada navegador, para remover os espaçamentos desnecessários interno e entre as células, vamos adicionar as propriedades `cellpadding="0"` e `cellspacing="0"`.

E por fim, para que o e-mail ocupe toda a largura possível, vamos adicionar o atributo `width="100%"`. Ficaria da seguinte forma:

![E-mail ocupando 100% da largura](../images/tecnicas-para-montagem-de-e-mail-2.png)

``` html
<body>
  <table width="100%" bgcolor="#798C98" cellpadding="0" cellspacing="0">
        <tr>
            <td>Teste</td>
        </tr>
    </table>
</body>
```

## Container

Vamos agora adicionar agora um container para envelopar o nosso conteúdo e limitar a largura do nosso e-mail para 600px - geralmente é o padrão de largura dos e-mails, mas nada impede de usar um valor maior ou menor.

Para isso precisaremos de uma nova tabela com os mesmos resets de espaçamento. Definimos a largura para 600px e um fundo branco (#ffffff). Ficaria assim:

![E-mail limitado a um container de 600px](../images/tecnicas-para-montagem-de-e-mail-3.png)

```HTML
<td>
    <table bgcolor="#ffffff" width="600" cellpadding="0" cellspacing="0">
        <tr>
            <td>Teste</td>
        </tr>
    </table>
</td>
```

Mas definir a largura para 600px fixo acaba acarretando problemas quando estamos visualizando em telas menores como um celular, a largura não se ajusta e acaba criando aquela barra de rolagem horizontal indesejada. Para que o e-mail se ajuste, teríamos que alterar a largura para ocupar a largura total (100%), mas isso não limita o nosso e-mail para ter no máximo 600px, como obter o melhor dos dois mundos?

A solução é simples, podemos fazer igual na web, onde o container ocupa o quanto conseguir, entretanto declaramos uma propriedade que limita a largura máxima: o `max-width`. Aplicando isso no exemplo:

```HTML
<td>
    <table bgcolor="#ffffff" style="max-width: 600px" width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td>Teste</td>
        </tr>
    </table>
</td>
```

## Centralizar o corpo do e-mail

Como podemos ver, o nosso container não está alinhado no centro, como podemos fazer isso? Usar o clássico `margin: 0 auto` que faz com que o navegador calcule automaticamente as distâncias em volta do e-mail e alinhe no centro? Mas isso funciona em todos os clientes de e-mail?

A forma mais simples e aceita nos clientes de e-mail é usando o atributo `align` na `td` que envolve nosso container. Isso faz com que o navegador entenda como deve centralizar os textos e elementos internos. No nosso exemplo ficaria assim:

```HTML
<td align="center">
    <table bgcolor="#ffffff" style="max-width: 600px" width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td>Teste</td>
        </tr>
    </table>
</td>
```

Podemos também utilizar a tag `<center>`, mas esta não funciona muito bem no Yahoo Mail.

Esta é a primeira parte de uma série de posts de como codificar um e-mail, neste primeiro aprendemos a criar a base para o nosso e-mail. No próximo iremos escrever sobre as diversas formas para lidar com espaçamentos nos e-mails. E você? Já passou por problemas ao codificar um e-mail? =]
