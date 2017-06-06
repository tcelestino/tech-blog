---
title: Google I/O - Web
date: 2017-06-01
category: front-end
layout: post
description: Durante diversas sessões os palestrantes incentivaram fortemente o uso de AMP e PWA. Além de reforçarem que Mobile Web é mainstream.
author: davidrobert
tags:
  - google io
  - web
  - pwa
  - amo
  - chrome
  - devtools
---

Durante diversas sessões os palestrantes incentivaram fortemente o uso de AMP e PWA. Além de reforçarem que Mobile Web é mainstream.

Um Product Manager do Twitter apresentou casos de sucesso com PWA. Onde seu uso incrementou 65% de pages/sessions e 75% mais tweets.

Forbes, Expedia, Pinterest, Lyft, Airbnb, Trivago, Lacôme, entre outros já utilizam PWAs. Sendo que a Lacôme teve um incremento de 53% de tempo de sessão após a adoção da tecnologia.

O Trivago pergunta se o usuário deseja adicionar um atalho na home (apresentando de maneira idêntica a um app aplicativo nativo.

O Head de Web Products do [Olacabs](https://www.olacabs.com/) apresentou um caso de sucesso no uso do uso de PWA (com web components). Sendo que atualmente o Olacabs tem mais de 1 milhão de corridas diárias, em mais de 110 cidades, com mais de 600 mil motoristas.

A versão com PWA teve cerca de 30% mais conversão que o app nativo. 20% das reservas usando PWA foram de usuários que tinham desinstalado o app. 

Outros tópicos relevantes:

- [https://www.chromestatus.com/features](https://www.chromestatus.com/features)
- [https://developers.google.com/web](https://developers.google.com/web)
- [http://bit.ly/pwa-media](http://bit.ly/pwa-media)

## Web Payments

Foram apresentados os casos de uso de Web Payments com [Wego](https://www.wego.com/) e [Kogan](https://www.kogan.com) focando no checkout na versão web mobile.

Web Payments já está pronto para utilização e diversas empresas já implementaram: Monzo, Kogan, Groupon, Nivea, Wego, Washington Post, Mobify, Shopify, WooCommerce, BigCommerce, WompMobile, Weebly, etc.

O time do [Alipay & Alibaba](https://www.alipay.com/webpay) apresentaram um caso de sucesso da utilização de Web Payments. A versão mobile web deles é a que melhor atende sua audiência global. Sendo que o Alipay possibilita a utilização de fingerprint (impressão digital do usuário) para autorizar uma compra.

A integração de pagamento com Web Payments com PaymentRequest é feita de maneira simples utilizando uma API JavaScript cross-browser. Navegadores que tem suporte a API: Chrome, IE, Samsung Internet e, em breve, Firefox. 

Por enquanto o número de parceiros de pagamento é limitado: PayPal, Samsung Pay e Alipay. Entretanto outras alternativas serão adicionadas em breve. 🚨 O Android Pay chegará ao Brasil até o fim de 2017.

Continuando no tema foi apresentado o resultado de uma pesquisa sobre transações mobile. Cerca de 80% das transações de compra no mobile só possuem 1 produto. E apresentar a opção para o usuário "Buy Now" ao além de "Add to Cart" aumenta significativamente a conversão.

- [https://g.co/PaymentRequesgtGuide](https://g.co/PaymentRequesgtGuide)
- [https://g.co/PayAppIntegration](https://g.co/PayAppIntegration)
- [https://g.co/PaymentRequestCodeLab](https://g.co/PaymentRequestCodeLab)

## DevTools
- A ferramenta **Lighthouse** foi integrada ao DevTools do Chrome [https://www.chromestatus.com/features](https://www.chromestatus.com/features)
- O debug ficou melhor, agora da pra debugar promises, arrow functions e async/await functions;
- Breakpoint mais inteligente mesmo com a alteração do código agora ele mantém o breakpoint no lugar que você colocou e não na linha;
- Agora existe um novo painel de Performance, bem legal também juntando network e profiles, é possível ver, por exemplo, quando um js termina de carregar e faz o evaluated, ou até quando uma fonte customizada termina o carregamento faz o recálculo do layout e começa a mostrar o texto para os usuários;
- Coverage: mostra quantos % e o trecho do código específico de js/css que está sendo usado, e muda essas informações em tempo real conforme você executa ações na tela;
- Agrupamento dos assets baseado no domínio usando uma badge (assim podemos ver se algum domínio em específico está travando nosso carregamento);
- Screenshots, edição de cookie (adeus EditThisCookie);
- Chrome headless [https://developers.google.com/web/updates/2017/04/headless-chrome](https://developers.google.com/web/updates/2017/04/headless-chrome);
- Melhorias bem interessantes no debug do node.js.
- [DevTools: State of the Union 2017 (Google I/O '17) https://www.youtube.com/watch?v=PjjlwAvV8Jg](https://www.youtube.com/watch?v=PjjlwAvV8Jg)
- Web Components -> Lançamento do Polymer 2.0 [https://www.polymer-project.org/](https://www.polymer-project.org/)
- [https://developers.google.com/web/tools/lighthouse/](https://developers.google.com/web/tools/lighthouse/)

## V8

Foram apresentados diversos dados sobre a evolução da tecnologia [V8](https://developers.google.com/v8/) e como essa evolução impacta positivamente o usuário final. Incluindo a redução do consumo de memória, a melhora na performance do setup inicial e as otimizações feitas em tempo de execução (JIT) para múltiplas execuções da mesma chamada.

Tópicos recomendados para uma boa compreensão:

- Conhecer bem JavaScript é fundamental;
- Entender o comportamento entre uma execução e múltiplas execuções da mesma chamada em JS;
- [TurboFan](https://github.com/v8/v8/wiki/TurboFan);
- [Ignition Interpreter](https://github.com/v8/v8/wiki/Interpreter); 
- [Orinoco](https://v8project.blogspot.com.br/2016/04/jank-busters-part-two-orinoco.html);
- [Speedometer 2](http://browserbench.org/Speedometer/);
- Otimizações: Generators, Async e Await.

- [https://v8project.blogspot.com.br/2017/05/launching-ignition-and-turbofan.html](https://v8project.blogspot.com.br/2017/05/launching-ignition-and-turbofan.html)
- [https://nodejs.org/en/blog/release/v8.0.0/#say-hello-to-v8-5-8](https://nodejs.org/en/blog/release/v8.0.0/#say-hello-to-v8-5-8)


## Cloud / Firebase
Diversas sessões sobre Firebase ocorreram durante o evento. Focando principalmente em autenticação por número de telefone, hosting e realtime.
![Cloud / Firebase](../images/google-io-3.png)
- [https://firebase.google.com/](https://firebase.google.com/)
