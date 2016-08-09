---
date: 2016-08-09
category: front-end
tags:
  - javascript
  - progressive
  - webapp
author: luiz
layout: post
title: A tecnologia por trás de *progressive web apps*
description: Se você trabalha com web, provavelmente já deve ter ouvido falar no termo *progressive web app*. Essa é uma tendência que vem aparecendo muito forte, impulsionada principalmente pela Google. O [Fabricio Teixeira](http://fabricio.nu/) já escreveu [um post explicando bem o **conceito** de *progressive web apps*](http://arquiteturadeinformacao.com/mobile/o-que-sao-progressive-web-apps/). O objetivo aqui, então, vai ser explorar um pouco mais o lado técnico dessa tendência: como a tecnologia evoluiu para chegarmos nesse ponto, o que temos de ferramentas e o que ainda está por vir.
---

Se você trabalha com web, provavelmente já deve ter ouvido falar no termo *progressive web app*. Essa é uma tendência que vem aparecendo muito forte, impulsionada principalmente pela Google, que até já organizou [um evento especificamente sobre esse tema](https://events.withgoogle.com/progressive-web-app-dev-summit/).

O [Fabricio Teixeira](http://fabricio.nu/) já escreveu [um post explicando bem o **conceito** de *progressive web apps*](http://arquiteturadeinformacao.com/mobile/o-que-sao-progressive-web-apps/). O objetivo aqui, então, vai ser explorar um pouco mais o lado técnico dessa tendência: como a tecnologia evoluiu para chegarmos nesse ponto, o que temos de ferramentas e o que ainda está por vir.

## Tudo começou há um tempo atrás...

A ideia de tentar transformar um site em algo mais próximo de um aplicativo não é tão nova quanto parece. A partir do momento em que os celulares começaram a ser capazes de ter aplicativos com boa usabilidade, os provedores de conteúdo e de serviços começaram a disponibilizar aplicativos para melhorar a experiência de seus usuários. A melhora da experiência vinha por conta de uma melhor **integração com o sistema nativo** e **performance**.

Conforme os desenvolvedores foram percebendo a importância desses fatores para uma melhor experiência do usuário, começaram a surgir algumas especificações que procuram tornar os sites mais próximos do sistema operacional, com acesso a mais recursos do dispositivo e sem tanta dependência de conectividade para funcionar. Dentre elas, podemos citar:

- APIs de acesso a recursos do dispositivo
    - Geolocalização (`navigator.geolocation`)
    - Câmera/microfone (`navigator.getUserMedia`)
    - Giroscópio/acelerômetro (eventos `deviceorientation` e `devicemotion`, respectivamente)
    - Vibração (`navigator.vibrate`)
- Manifesto para aplicações web (`link rel="manifest"`)
- A falecida especificação de cache de aplicação (atributo `manifest` na tag `html`)
- Service workers (`navigator.serviceWorker`)

Tópicos a seguir:
- Explicar manifest.json
- Explicar por que a especificação AppCache é ruim
- Explicar Service Workers
- SPA
- União Service Workers + SPA