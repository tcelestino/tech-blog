---
title: 'HTTPS (provisório)'
date: 2017-01-30
category: devops
layout: post
description: Logs são parte fundamental de qualquer aplicação, e sua importância é notada especialmente nos momentos mais difíceis. Neste artigo veremos como gerenciar esses dados de forma eficaz e versátil, provendo robustez e, ainda assim, facilitando o dia-a-dia de nossas colabores aqui no Elo7.
author: edsonmarquezani
tags:
  - https
  - http2
---

Como vocês já devem ter notado, recentemente o [Elo7](https://www.elo7.com.br) passou a ser servido **unicamente em HTTPS**. Nenhuma parte de nosso conteúdo ou navegação está mais disponível em _HTTP_ simples. Isso segue uma tendência de toda a Internet e cada vez mais sites devem adotar esse "formato". Essa, que pode parecer uma mudança simples, tem uma série de motivos e também implicações, que serão discutidas a seguir.

## HTTP versus HTTPS

O protocolo _HTTPS_ é a versão segura do protocolo _HTTP_. Com ele, todos os dados trafegados são criptografados por outro protocolo chamado [_SSL_](https://en.wikipedia.org/wiki/Transport_Layer_Security). O _SSL_ é baseado em técnicas de criptografia tanto assimétrica (onde existem chaves separadas para criptografar e descriptografar) quando simétrica (onde uma única chave é usada). Por "debaixo" do _SSL_, permanece o mesmo _HTTP_ de sempre, como conhecemos.
O objetivo primário do _HTTPS_ é, como pode ser facilmente deduzido, prover privacidade na comunicação, impedindo que o valor real dos dados seja revelado caso seja interceptado. Isso é não apenas desejável, mas indispensável, para operações que transmitem dados sensíveis, como senhas, dados bancários, mensagens, etc. Por isso é que operações de _login_, pagamentos online e até mesmo troca de mensagens (por aplicativos ou e-mails) sempre são realizadas dessa forma.
Outra vantagem do _HTTPS_ é a comprovação de identidade do site, ou seja, poder ter certeza de que aquele site não é um site falso e que realmente pertence à entidade que diz pertencer. Isso é possível pois, na web, todo certificado utilizado é emitido por uma [Autoridade Certificadora](https://en.wikipedia.org/wiki/Certificate_authority) (_CA_) que, por sua vez, garante a autenticidade do certificado. O certificado nada mais é do que chave pública que faz parte da porção do protocolo _SSL_ onde se utiliza criptografia assimétrica. (A compreensão plena de todo o mecanismo de funcionamento do protocolo _SSL_ e, em especial, das técnicas de criptografia foge ao escopo desse artigo, por tratar-se de um tópico bastante extenso e complexo.) Essa chave (ou certificado) contém, entre outras coisas, o próprio endereço do site, e também informações da entidade a que ela pertence. Quando o navegador obtém esse certificado do site, por meio de mecanismos do próprio esquema de criptografia, ele pode validar se o certificado foi realmente emitido por uma _CA_ em quem confia, confirmando que o site é autêntico.

## Snowden, HTTP2, Google e navegadores

É bem verdade que o _HTTPS_ é fundamental para operações que envolvem dados mais sensíveis, mas e quanto à navegação mais corriqueira, como leitura de conteúdo, visualização de produtos, pesquisas, etc?
