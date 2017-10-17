---
date: 2017-05-15
category: front-end
tags:
  - e-mail
  - html
  - css
authors: [erikatakahara]
layout: post
title: Técnicas para codificar um e-mail - parte 3
description: Já teve problemas ao visualizar um e-mail no celular? Por exemplo, aquelas letras pequenas, scroll lateral e colunas quebradas? Nesse post iremos abordar como criar colunas nos e-mails e como deixá-las responsivas para melhor visualização em seu dispositivo móvel.
---

No [segundo post da série](/tecnicas-para-codificar-um-e-mail-parte-2/), aprendemos a lidar com espaçamento nos e-mails. Neste, iremos abordar como criar conteúdo em colunas e como deixá-las <a href='https://tableless.com.br/introducao-ao-responsive-web-design/' rel='nofollow' target='_blank'>responsivas</a>.

Finalmente chegamos ao conteúdo! Para começar, vamos criar uma nova tabela. É possível usar a mesma tabela do container e alterar o `bgcolor` para mudar a cor da célula ao invés da tabela. Mas aconselho a criar uma nova para evitar problemas com o `colspan` e `rowspan`, porque essas propriedades causam problemas para manter a estrutura correta a medida que são criadas novas células.

Para montar o conteúdo, vamos usar as mesmas técnicas citadas nos posts anteriores:

![E-mail com o conteúdo](../images/tecnicas-para-codificar-um-e-mail-parte-3-1.png)

```HTML
<table bgcolor="#ffffff" width="100%" cellpadding="0" cellspacing="0" style="padding-left: 15px; padding-right: 15px">
    <tr>
        <td>
            <h2 style="padding: 0; margin: 0.5em 0; font-size: 1.5em; font-family: arial, sans-serif; color: #788895">Novidades do tech blog!</h2>
            <img src="http://placehold.it/570x150" alt="Imagem" width="570" height="150">
            <p>Lorem ipsum  [...]</p>
            <p>Phasellus vulputate [...]</p>
        </td>
    </tr>
</table>
```

Mas temos um problema, da forma que está o e-mail deixou de ser responsivo por causa da imagem com largura fixa:

![Problema da largura fixa nos dispositivos móveis](../images/tecnicas-para-codificar-um-e-mail-parte-3-2.png)

Para torná-lo responsivo, basta adicionar uma largura que ocupe o máximo que conseguir do container, ou seja, `width: 100%`. O problema dessa técnica é que a altura definida acaba deixando a imagem desproporcional em telas menores.

![Adicionando largura 100% para os dispositivos móveis](../images/tecnicas-para-codificar-um-e-mail-parte-3-3.png)

Uma solução é remover a altura fixa, mas caso a imagem esteja quebrada ou ainda está para carregar o nosso navegador não consegue definir a altura sozinho e chuta uma altura proporcional a largura:

![Template do e-mail quebra quando a imagem demora para carregar](../images/tecnicas-para-codificar-um-e-mail-parte-3-4.png)

A melhor solução que encontrei é fazer uma mescla de `width="100%"` e limitar com o `max-width` e o `max-height` o tamanho da imagem.

![Imagem com altura máxima definida](../images/tecnicas-para-codificar-um-e-mail-parte-3-5.png)

```HTML
<table bgcolor="#ffffff" width="100%" cellpadding="0" cellspacing="0" style="padding-left: 15px; padding-right: 15px">
    <tr>
        <td>
            <h2 style="padding: 0; margin: 0.5em 0; font-size: 1.5em; font-family: arial, sans-serif; color: #788895">Novidades do tech blog!</h2>
            <img src="http://placehold.it/570x150" alt="Imagem" width="100%" style="max-width: 570px; max-height: 150px;">
            <p>Lorem ipsum  [...]</p>
            <p>Phasellus vulputate [...]</p>
        </td>
    </tr>
</table>
```

## Colunas responsivas

Para as colunas, vamos criar duas tabelas com uma largura de 270px: uma com a imagem e a outra com o título do texto e a descrição:

```HTML
<table cellpadding="0" cellspacing="0" width="270">
    <tr>
        <td>
            <img src="http://placehold.it/270x150" width="100%" style="max-width: 270px; height: 150px;" alt="Imagem veja mais">
        </td>
    </tr>
</table>

<table cellpadding="0" cellspacing="0" width="270">
    <tr>
        <td>
            <h2 style="margin: 0; font-size: 1.5em; font-family: 'Lobster', sans-serif; color: #788895">Veja mais!</h2>
            <p>Sed congue purus lorem, nec luctus nibh fermentum non. Ut fermentum aliquet nunc, tempus placerat turpis tristique sed.</p>
        </td>
    </tr>
</table>
```

Para alinhar os elementos na mesma linha vamos usar a propriedade `display: inline-block`:

![Colunas em e-mail](../images/tecnicas-para-codificar-um-e-mail-parte-3-6.png)

```HTML
<table cellpadding="0" cellspacing="0" width="270" style="display: inline-block">
    [...]
</table>

<table cellpadding="0" cellspacing="0" width="270" style="display: inline-block">
    [...]
</table>
```

Para alinhar no topo, é só adicionar o atributo `valign="top"`, o `valign` tem a mesma função da propriedade `vertical-align`.

```HTML
<table cellpadding="0" cellspacing="0" width="270" style="display: inline-block" valign="top">
    [...]
</table>

<table cellpadding="0" cellspacing="0" width="270" style="display: inline-block" valign="top">
    [...]
</table>
```

E por fim, vamos adicionar uma margem para a direita na primeira tabela e `margin-bottom: 15px` nas duas para separar o conteúdo verticalmente.

![Colunas alinhadas verticalmente](../images/tecnicas-para-codificar-um-e-mail-parte-3-7.png)

```HTML
<table cellpadding="0" cellspacing="0" width="270" style="display: inline-block; margin-right: 15px;" valign="top">
    [...]
</table>
```

E como usamos o `display: inline-block`, essas colunas já são responsivas:

![Colunas em um dispositivo móvel](../images/tecnicas-para-codificar-um-e-mail-parte-3-8.png)

O problema agora é que a primeira tabela está causando um scroll horizontal. Isso porque a margem da direita (15px) somada com a largura da imagem (270px) e a margem interna (30px) ultrapassa o limite de 300px (largura mínima de uma device).

Uma forma de resolver é remover o `margin-right` da primeira tabela e adicionar um `span` envolta com um `border-right: 15px solid white`. Essa borda se encarrega de criar o espaçamento entre uma tabela e a outra na horizontal e não contabiliza na soma por ser um elemento `inline`. Dessa forma conseguimos atingir o efeito desejado:

![Colunas usando borda para criar a margem](../images/tecnicas-para-codificar-um-e-mail-parte-3-9.png)

A outra forma é adicionar uma media query específica para mobile e remover essa margem. Sim! Alguns clientes de e-mail agora aceita a tag `style` no cabeçalho e medias queries! Essa mudança está revolucionando o desenvolvimento de e-mails responsivos, criando experiência mais rica para os nossos usuários e melhorando a legibilidade do código.

Voltando ao nosso exemplo, vamos adicionar a tag `style` com uma media query dentro do header:

```HTML
<head>
    <style>
        @media only screen and (max-width: 480px) {

        }
    </style>
</head>
```

Essa media query vai aplicar os estilos declaradas nela para todas as telas com uma largura de no máximo 480px, ou seja, apenas para a versão mobile. Para aplicar a regra de remoção da margem, vamos adicionar uma classe para a primeira tabela:

```HTML
<table class="tabela-responsiva" bgcolor="#ffffff" width="100%" cellpadding="0" cellspacing="0" style="padding-left: 15px; padding-right: 15px; margin-right: 15px;">
```

E dentro da media query:

```CSS
@media only screen and (max-width: 480px) {
    .tabela-responsiva {
        margin-right: 0 !important;
    }
}
```

O `!important` é necessário para conseguirmos sobrescrever o estilo que está declarado `inline`. Com essa mudança conseguimos atingir o mesmo resultado. O único problema é que a tag `style` no cabeçalho não funciona em alguns clientes de e-mail, segue a lista dos quais eu testei:

- Chrome Android
    - Gmail
    - Outlook
    - Yahoo
    - Android
    - Gmail App
    - Inbox App
    - Yahoo App
    - Outlook App
- iOS
    - Apple Mail

Voltando ao nosso e-mail, agora o único problema que falta resolver é o fato do template quebrar em telas um pouco menor que 600px, mas maior que 480px:

![Colunas quebram em duas linhas em devices com uma largura um pouco menor que 600px](../images/tecnicas-para-codificar-um-e-mail-parte-3-10.png)

Para esse problema, podemos alterar a largura das tabelas para serem baseadas em uma porcentagem. Por exemplo, se alterarmos as larguras dessas tabelas para 47% (um valor que aproxima da largura de 270px)  ficaria da seguinte forma:

![Usando porcetagem nas colunas](../images/tecnicas-para-codificar-um-e-mail-parte-3-11.png)

Mas como podemos ver, essa alteração piora a usabilidade na versão mobile.  Nesse caso podemos aproveitar a nossa media query no header e fazer essas tabelas ocuparem 100% do espaço em telas menores. Vamos adicionar a mesma classe `.tabela-responsiva` para a segunda tabela e adicionar a seguinte regra na media query:

```CSS
@media only screen and (max-width: 480px) {
    .tabela-responsiva {
        margin-right: 0 !important;
        width: 100% !important;
    }
}
```

![Template final](../images/tecnicas-para-codificar-um-e-mail-parte-3-12.png)

E voilá! Chegamos no efeito que queríamos!

Se caso quiser optar por não utilizar a tag `style` para corrigir esse problema, não resolve muito, mas sugiro voltar para as medidas fixas e adicionar uma tabela envolta para alinhar os elementos no centro para melhorar um pouco o design.

Por fim podemos só adicionar uma tipografia padrão na tabela de conteúdo:

```HTML
<table bgcolor="#ffffff" width="100%" cellpadding="0" cellspacing="0" style="padding-left: 15px; padding-right: 15px; font-family: arial, sans-serif">
```

Assim todo o texto que está no conteúdo já herda por padrão essa tipografia.

Essas técnicas apresentadas foram testadas nos seguintes clientes de e-mail:
- Chrome
    - Gmail
    - Inbox
    - Outlook
    - Yahoo
- Internet Explorer
    - Outlook
    - Yahoo
- Android
    - Gmail App
    - Inbox App
    - Yahoo App
    - Outlook App

Enfim conseguimos finalizar o e-mail como o mock apresentado no [primeiro post](/tecnicas-para-codificar-um-e-mail/)! No próximo e último post da série, vamos comentar sobre algumas dicas e sobre web fontes nos e-mails. E você? Já teve problemas com e-mails responsivos?
