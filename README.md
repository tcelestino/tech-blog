<img align="right" src="http://images.elo7.com.br/assets/v3/desktop/svg/logo-elo7.svg" />

# Tech Blog
*Blog de tecnologia do Elo7*

O blog usa como ferramenta o [docpad](http://docpad.org/docs/intro), um gerador de sites estáticos.

## Criando Posts

Para criar um post, basta adicionar um novo arquivo dentro da pasta ``src/posts`` com o padrão de nomenclatura ``<nomedopost>.html.md``. O layout para o post deve ser:
```html
---
date: 2016-07-18
category: back-end
tags:
  - java
  - mockito
  - tdd
author: seugithub
layout: post
title: Título do post
description: Alguma descrição do post que irá aparecer na home...
---
```

Para adicionar imagens ao seu post, adicione cada uma das imagens na pasta ``src/assets/images``. Sua imagem deve ser ``.png`` ou ``.jpg`` e o nome deve seguir o padrão: ``<nomedopost>-<numerodaimagem>.<extensão>``. Para referenciá-las no post, use URLs absolutas como ``/images/titulo-post-1.png``.

## Criando sua página de autor
Se você ainda não tem a sua página de autor, crie um arquivo ``<seugithub>.html.md`` na pasta ``src/publishers/``. 
O template para esse arquivo deve ser:
```html
---
title: Fernanda Bernardo
publisher: Fernanda Bernardo
layout: publisher
twitter: Feh_Bernardo <seu twitter sem @>
github: fernandabernardo <seu github sem @>
linkedin: fernandabernardo <seu linkedin>
description: Aqui você pode descrever uma minibio sua :)
---
```

Dessa forma você poderá acessar a sua página de autor nessa url: ``localhost:9778/<seugithub>``

## Markdown
Todo o post deve ser escrito na linguagem markdown. Abaixo seguem alguns exemplos da marcação (apenas para demonstração, todas as marcações do markdown funcionam :) ):
* h2 - ``## Título de segundo nível``
* h3 - ``### Título de terceiro nível``
* negrito - ``**texto em negrito**``
* itálico - ``*texto em itálico*``
* underline - ``_texto sublinhado_``
* imagem - ``![Alt da imagem](url da imagem)``
* link - ``[texto do link](url do link)``
* código em bloco -

\`\`\` nomedalinguagem

``
trecho do código
``

\`\`\`

* código inline - \```código``\`
* lista - ``* item da lista``
* lista numerada - ``1. item da lista``
* blockquote - ``> quote``

### Build e Desenvolvimento

- Para rodar o projeto na sua máquina, é necessário ter instalado o npm e seguir os seguintes passos:

```
npm install
npm start
```

### Labels do PR
Seu PR(Pull Request) pode ter duas classificações: ``POST`` (novo post do blog) ou ``ENHANCEMENT`` (melhorias para o blog como um todo).
O PR pode passar pelas etapas de avaliação:
* ``TO REVIEW`` - inicialmente seu PR entra para que outras pessoas possam testar.
* ``FIX`` - quando um usuário testar um PR e tiver partes que devem ser alteradas, a label deve mudar para fix. Após o dono do PR fazer as modificações, a tarefa volta para ``TO REVIEW``
* ``APPROVED`` - após um usuário diferente do dono do PR testar e não existir mais modificações a serem feitas, deve-se aprovar o PR. Apenas o dono da tarefa pode mergear com a master.

### Deploy
Existem dois tipos de deploy:
- Deploy de Post
``./deploy-post.sh``

- Deploy de Enhancement
``./deploy-enhancement.sh``

### Hospedagem

Blog hospedado no [github-pages](https://elo7.github.io/tech-blog) ou [engenharia.elo7.com.br](http://engenharia.elo7.com.br)
