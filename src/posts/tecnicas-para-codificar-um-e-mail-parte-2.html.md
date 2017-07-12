---
date: 2017-05-15
category: front-end
tags:
  - e-mail
  - html
  - css
authors: [erikatakahara]
layout: post
title: Técnicas para codificar um e-mail - parte 2
description: Continuando com a série de posts sobre codificar e-mails, você já teve problemas para adicionar espaçamentos? Ou com cliente de e-mail que não lê corretamente o que foi codificado? Nesse segundo post, vamos abordar diversas técnicas.
---

No [primeiro post da série](/tecnicas-para-codificar-um-e-mail/), aprendemos a criar uma base para codificação de e-mail. Neste, iremos abordar as diversas formas de como trabalhar com os espaçamentos do e-mail.

Para começar, vamos adicionar um cabeçalho ao nosso e-mail, criaremos uma tabela e dentro da mesma adicionar um `h1` para o nosso e-mail. Para ficar igual ao mock, vamos adicionar a cor do fundo o marrom claro (#E2D6C7) no `bgcolor` da tabela:

![Adicionando uma cor de fundo ao nosso cabeçalho](../images/tecnicas-para-codificar-um-e-mail-parte-2-1.png)

```HTML
<table bgcolor="#E2D6C7" width="100%" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <h1>Meu primeiro e-mail</h1>
        </td>
    </tr>
</table>
```

Agora, vamos para a parte que nos interessa, adicionar um pequeno espaçamento entre o texto e as bordas. Podemos adicioná-la das seguintes formas:

## Colunas

Adicionamos uma célula antes e após a célula que contém o texto, definimos uma largura e adicionamos algum conteúdo (`&nbsp;` significa um espaço na tabela de entidades html) para que ela seja sempre considerada nos clientes de e-mail.

```HTML
<table bgcolor="#E2D6C7" width="100%" cellpadding="0" cellspacing="0">
    <tr>
        <td width="15">&nbsp;</td>
        <td>
            <h1>Meu primeiro e-mail</h1>
        </td>
        <td width="15">&nbsp;</td>
    </tr>
</table>
```

## Cellspacing

Podemos usar a propriedade que define o espaçamento interno da célula para fazer esse trabalho para nós:

```HTML
<table bgcolor="#E2D6C7" width="100%" cellpadding="15" cellspacing="0">
    <tr>
        <td>
            <h1>Meu primeiro e-mail</h1>
        </td>
    </tr>
</table>
```
O problema dessa é que não é possível definir diferentes espaçamentos, o valor sempre vai contar para todas as direções (`top`, `left`, `bottom` e `right`).


## Padding

Com essa propriedade podemos definir o espaçamento como fazemos hoje no desenvolvimento de um site, é só adicionar o `padding-left` e o `padding-right` com o valor de 15px e temos o mesmo efeito:

```HTML
<table bgcolor="#E2D6C7" width="100%" cellpadding="0" cellspacing="0" style="padding-left: 15px; padding-right: 15px">
    <tr>
        <td>
            <h1>Meu primeiro e-mail</h1>
        </td>
    </tr>
</table>
```

## Margin

Uma outra forma é adicionar uma margem para os lados no nosso texto:

```HTML
<table bgcolor="#E2D6C7" width="100%" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <h1 style="margin-left: 15px; margin-right: 15px">Meu primeiro e-mail</h1>
        </td>
    </tr>
</table>
```

Feito isso, vamos o texto para que fique semelhante ao nosso mock. Para adicionar a cor, podemos usar a propriedade `color`, a `font-family` para definir a tipografia e o `font-size` para o tamanho, também vamos precisar redefinir as margens e os paddings para garantir que a renderização entre os clientes se mantenham iguais:

![Espaçamento no e-mail](../images/tecnicas-para-codificar-um-e-mail-parte-2-2.png)

```HTML
<table bgcolor="#E2D6C7" width="100%" cellpadding="0" cellspacing="0" style="padding-left: 15px; padding-right: 15px">
    <tr>
        <td>
            <h1 style="margin: 0.5em 0; padding: 0; font-family: arial; color:  #7F674D; font-size: 2em">Meu primeiro e-mail</h1>
        </td>
    </tr>
</table>
```

Para o tipo de fonte é sempre legal colocar um fallback, pois nem sempre a tipografia escolhida existe no sistema que o usuário utiliza. Um fallback genérico são as `sans-serif`, `serif` e `cursive` para as fontes sem serifa, serifadas e cursivas respectivamente.

Nesse caso só adicionamos o nosso fallback após a fonte desejada:

```CSS
    font-family: arial, sans-serif;
```

Essas técnicas apresentadas funcionam nos seguintes clientes de email:

- Chrome
    - Gmail
    - Inbox
    - Outlook
    - Yahoo
- Internet Explorer 10
    - Outlook
    - Yahoo
- Android
    - Gmail App
    - Inbox App
    - Yahoo App
    - Outlook App

Esta foi a segunda parte da série de posts de como codificar um e-mail, em que aprendemos a como lidar com espaçamentos. No próximo iremos escrever sobre como deixá-lo responsivo. E você? Já teve problemas com espaçamentos? =]
