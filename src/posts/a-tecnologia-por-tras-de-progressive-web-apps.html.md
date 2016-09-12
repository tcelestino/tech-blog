---
date: 2016-08-09
category: front-end
tags:
  - javascript
  - progressive webapps
  - pwa
  - service workers
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

- APIs de acesso a sensores do dispositivo
    - Geolocalização (`navigator.geolocation`)
    - Câmera/microfone (`navigator.getUserMedia`)
    - Giroscópio/acelerômetro (eventos `deviceorientation` e `devicemotion`, respectivamente)
- LocalStorage/SessionStorage (`window.localStorage`/`window.sessionStorage`)
- Indexed Database (`window.indexedDB`)
- Manifesto para aplicações web (`link rel="manifest"`)
- A falecida especificação de cache de aplicação (atributo `manifest` na tag `html`)
- A especificação de `CacheStorage`, que veio substituir o cache de aplicação (`window.caches`)
- Service workers (`navigator.serviceWorker`)

Neste post, vamos focar nas APIs que permitem uma experiência "app" para qualquer tipo de site, que são as APIs de armazenamento (LocalStorage/SessionStorage, Indexed Database, Cache de aplicação e CacheStorage), o manifesto para aplicações web e os *service workers*.

## Manifesto para aplicações web

Quando acessamos uma página da web, ela é aberta dentro de um navegador. O navegador adiciona, ao redor do conteúdo, barra de endereços, menu, ícones de extensões, barra de status etc. Tudo isso atrapalha a experiência do usuário quando queremos que ele realize tarefas na nossa aplicação, não é verdade? Compare com a experiência de acessar um aplicativo: toda a tela pode ser usada por ele, tornando a experiência mais imersiva e aproveitando melhor o espaço de tela, que é restrito.

TODO: imagens

Fora isso, é comum que os usuários criem atalhos para seus aplicativos favoritos. No entanto, é difícil ver atalhos para sites. Por que? No Google Chrome, por exemplo, existe a opção de adicionar à tela inicial um atalho para o site que estamos visitando. Mas, quando fazemos isso num site simples, o atalho não é tão fácil de identificar quanto um atalho de aplicativo.

TODO: mais imagens

Para melhorar esses pontos, surgiu a especificação do manifesto para aplicações web. Com ele, você consegue especificar se seu site deve ser visualizado com a barra de endereços ou em tela cheia; qual orientação de tela é mais adequada para seu site (retrato, paisagem ou indiferente); qual a cor principal do tema de cores do site (útil para customizar a cor da janela do navegador); e qual nome e ícone deve ter o atalho na área de trabalho.

Usar essa especificação é simples: basta escrever um arquivo no formato JSON seguindo a especificação:

```json
{
    "name": "Elo7",
    "short_name": "Elo7",
    "icons": [
        {
            "src": "//images.elo7.com.br/marketplace/assets/web/common/png/favicon/32x32-negative.png",
            "sizes": "32x32",
            "type": "image/png",
            "density": 0.75
        },
        {
            "src": "//images.elo7.com.br/marketplace/assets/web/common/png/favicon/48x48-negative.png",
            "sizes": "48x48",
            "type": "image/png",
            "density": 1.0
        },
        {
            "src": "//images.elo7.com.br/marketplace/assets/web/common/png/favicon/64x64-negative.png",
            "sizes": "64x64",
            "type": "image/png",
            "density": 1.5
        },
    ],
    "start_url": "/?elo7_source=web_app_manifest",
    "display": "standalone",
    "orientation": "portrait",
    "theme_color": "#FDB933",
    "background_color": "#FDB933"
}
```

e referenciá-lo nas páginas de seu site com a tag `<link>`:

```html
<link rel="manifest" href="manifest.json">
```

Com isso, sua aplicação web já começa a ganhar uma aparência de aplicativo! Mas a experiência de navegação ainda é de um site: uma conexão ruim afeta diretamente a experiência.

## AppCache: uma primeira tentativa de experiência offline

A única forma de fazer com que a aplicação não dependa de conectividade com a internet para funcionar é fazer com que os recursos de que ela depende sejam armazenados no dispositivo do usuário.

Já existe há muito tempo a ideia de *cachear* recursos no navegador do cliente. A ideia é guardar algumas informações como arquivos CSS, Javascript e imagens que mudam pouco no site. Assim, na próxima visita do usuário, ele não precisa baixar de novo essas informações. No entanto, mesmo tendo esses dados armazenados, o navegador ainda faz requisições para carregar o HTML inicial e verificar se é necessário atualizar os dados em cache.

Para tentar resolver esse problema, surgiu a especificação *AppCache*. A ideia é parecida com a do manifesto de aplicação: você escreve um arquivo descrevendo os dados que seu site necessita para funcionar offline e qual o comportamento dele nessa situação:

```
CACHE MANIFEST
index.html
estilo.css
logo.svg
banner.png
interacoes.js
```

Em seguida, referencia esse arquivo no seu HTML usando um atributo na tag `<html>` para que o navegador possa carregá-lo:

```html
<html manifest="elo7.appcache">
    ...
</html>
```

Com essas informações, o navegador consegue fornecer uma versão offline do seu site ou aplicação web para o usuário quando necessário.

Apesar de parecer uma solução simples e efetiva, ela vem com uma série de complicações. Primeiro, uma vez que o conteúdo tenha sido cacheado pelo AppCache, o navegador do usuário vai **sempre** usar a versão cacheada. Ou seja, para servir uma nova versão da aplicação para seu usuário, você vai precisar força-lo a atualizar o cache, e isso não é nada fácil. O AppCache só é atualizado quando o arquivo de manifesto é alterado e, **além disso**, os arquivos por ele referenciados devem ser atualizados de acordo com as regras de cache HTTP tradicional.

Fora essas dificuldades com atualização, o AppCache também não fornece um controle muito forte sobre **o que** vai ser cacheado e **por quanto tempo**. Dependendo de como for utilizado, o cache pode crescer indefinidamente, gerando sérios problemas para o usuário.

Felizmente, uma nova especificação, muito mais poderosa, veio resolver a questão da experiência offline e *quase* offline (sabe aqueles momentos em que o 3G começa a falhar?) e enterrou a especificação AppCache.

## Service workers

Em meados de 2014, surgiu a primeira versão dessa nova especificação, trazendo um mundo enorme de possibilidades com ela. Pela primeira vez na web, uma página poderia especificar um arquivo Javascript para executar além do escopo da própria página e controlar **totalmente** o acesso a recursos externos.

```javascript
if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('sw.js')
        .then(function(sw) {
            // service worker registrado!
        }).catch(function() {
            // falha ao registrar service worker
        });
}
```

Para evitar problemas de segurança, esse é um recurso que está disponível apenas para páginas servidas via HTTPS (criptografia).

Na especificação AppCache, a estratégia de cache e *fallback* ficava toda a cargo do navegador; era inflexível. Com os *service workers*, o controle passa todo para o desenvolvedor. Ele pode implementar a mesma estratégia do AppCache (servir o conteúdo cacheado e atualizar em background) ou outra totalmente diferente, como acessar o cache e a rede ao mesmo tempo para responder rapidamente a uma requisição sem deixar de atualizar sempre o conteúdo. Nesse caso, o *service worker* trabalha em conjunto com outra especificação: CacheStorage, um cache programável voltado para o armazenamento de recursos pelo *service worker*.

```javascript
// sw.js
self.addEventListener('install', function(event) {
    event.waitUntil(
        caches.open('meusite-v1').then(function(cache) {
            return cache.addAll([ /* URLs aqui */ ]);
        })
    );
});

self.addEventListener('fetch', function(event) {
    event.respondWith(
        // sua estratégia para offline aqui
    );
});
```

Além do controle de acesso à rede, que por si só já é muito valioso, o *service worker* também permite trabalhar com sincronização de dados em background, algo que já existe há muito tempo em aplicações nativas e é fundamental para uma experiência de uso mais fluida e para aumentar o engajamento do usuário com o site ou a aplicação.

Tópicos a seguir:
- LocalStorage/SessionStorage
- IndexedDB