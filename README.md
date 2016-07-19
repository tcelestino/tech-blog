<img align="right" src="http://images.elo7.com.br/assets/v3/desktop/svg/logo-elo7.svg" />

# Tech Blog
*Blog de técnologia do Elo7*

O blog usa como ferramenta o [docpad](http://docpad.org/docs/intro), um gerador dinâmico de sites estáticos.

## Criando Posts

Para criar um post, basta adiciona um novo arquivo dentro da pasta ``src/posts`` com o padrão de nomenclatura ``<nomedopost>.html.hb``. o layout para o post deve ser:
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

### Build and Development

- Necessario ter instalado o npm

``sudo npm install -g docpad``

``sudo npm install``

``docpad run``

### Deploy

``docpad deploy-ghpages --env static``

### Hospedagem

Blog hospedado no [github-pages](https://elo7.github.io/tech-blog) ou [engenharia.elo7.com.br](engenharia.elo7.com.br)
