---
title: 'HTTPS (título provisório)'
date: 2017-01-30
category: devops
layout: post
description: Logs são parte fundamental de qualquer aplicação, e sua importância é notada especialmente nos momentos mais difíceis. Neste artigo veremos como gerenciar esses dados de forma eficaz e versátil, provendo robustez e, ainda assim, facilitando o dia-a-dia de nossas colabores aqui no Elo7.
author: edsonmarquezani
tags:
  - https
  - http2
---

Como vocês já devem ter notado, recentemente o [Elo7](https://www.elo7.com.br) passou a ser servido **unicamente em HTTPS**. Nenhuma parte de nosso conteúdo ou navegação está mais disponível em _HTTP_ plano. Isso segue uma tendência de toda a Internet e cada vez mais sites devem adotar esse "formato". Essa, que pode parecer uma mudança simples, tem uma série de motivos e também implicações, que serão discutidas a seguir.

## HTTP versus HTTPS

O protocolo _HTTPS_ é a versão segura do protocolo _HTTP_. Com ele, todos os dados trafegados são criptografados por outro protocolo chamado [_SSL_](https://en.wikipedia.org/wiki/Transport_Layer_Security). O _SSL_ é baseado em técnicas de criptografia tanto assimétrica (onde existem chaves separadas para criptografar e descriptografar) quando simétrica (onde uma única chave é usada). Por "debaixo" do _SSL_, permanece o mesmo _HTTP_ de sempre, como conhecemos.

O objetivo primário do _HTTPS_ é, como pode ser facilmente deduzido, prover privacidade na comunicação, impedindo que o teor dos dados seja revelado em caso de interceptação por terceiros. Isso é não apenas desejável, mas indispensável para operações que transmitem dados sensíveis, como senhas, dados bancários, mensagens, etc. É por isso que operações de _login_, pagamentos _online_ e até mesmo troca de mensagens (por aplicativos ou e-mails) sempre são realizadas dessa forma.

Outra vantagem do _HTTPS_ é a comprovação de identidade do site, ou seja, poder ter certeza de que aquele site não é falso e que realmente pertence à entidade que diz pertencer. Isso é possível pois, na _web_, todo certificado _SSL_ utilizado é emitido por uma [Autoridade Certificadora](https://en.wikipedia.org/wiki/Certificate_authority) (_CA_) que, por sua vez, garante a autenticidade do certificado. O certificado nada mais é do que chave pública que faz parte da porção do protocolo _SSL_ onde se utiliza criptografia assimétrica. (A compreensão plena de todo o mecanismo de funcionamento do protocolo _SSL_ e, em especial, das técnicas de criptografia foge ao escopo desse artigo, por tratar-se de um tópico bastante extenso e complexo.) Essa chave (ou certificado) contém, entre outras coisas, o próprio endereço do site, e também informações da entidade a que ela pertence. Quando o navegador obtém esse certificado do site, ele pode validar se o certificado foi realmente emitido por uma _CA_ em quem confia, confirmando se o site é autêntico. (O mecanismo de validação envolve um outro conjunto certificados das _CAs_ que vêm junto dos navegadores.) Em um cenário onde alguém tentasse usar um certificado falso, essa validação falharia, expondo a fraude.

Uma das desvantagens do _HTTPS_ em relação ao _HTTP_ é o custo computacional maior para cliente e servidor, devido à série de cálculos que é necessário realizar para criptografar e descriptografar os dados. Entretanto, para o _hardware_ que temos nos dias de hoje, esse _overhead_ costuma ser desprezível perto da complexidade das aplicações em si, impactando muito pouco na carga do servidores ou tempo de resposta. Assim como para os _desktops_, cujos CPUs ficam ociosos boa parte do tempo.

Outra desvantagem é o custo: em geral, as autoridades certificadoras cobram pela emissão dos certificados. Entretanto, atualmente já existem serviços gratuitos como o [_Let's Encrypt_](https://letsencrypt.org/), e até mesmo o [_AWS Certificate Manager_](https://aws.amazon.com/pt/certificate-manager/), que oferece certificados para uso com outros recursos _AWS_ (como seu _Elastic Load Balancer_ e _CloudFront_).

## Snowden, HTTP2, Google e navegadores

É bem verdade que o _HTTPS_ é fundamental para operações que envolvem dados mais sensíveis, mas e quanto à navegação mais corriqueira, como leitura de conteúdo, visualização de produtos, pesquisas, etc? Bem, o mundo pós-[Snowden](https://en.wikipedia.org/wiki/Edward_Snowden) encara essa questão de forma diferente. Hoje, é de conhecimento público que diversos governos de nações espionam a comunicação de cidadãos, empresas e até mesmo de outros governos. A preocupação com a privacidade levou a comunidade técnica a um consenso de que, no mundo de hoje, a criptografia deixou de ser uma opção, para se tornar uma necessidade, razão pela qual a adoção do _HTTPS_ tem sido não apenas incentivada, mas também de certa forma forçada pelas grandes empresas do setor e grupos que atuam na definição de padrões e regulação da Internet. Portanto, a perguntar que se fazia antes - "por que usar _HTTPS_?" - foi invertida para - "por que **não** usar _HTTPS_?"

De fato, a nova versão do protocolo _HTTP_, o [_HTTP/2_](https://http2.github.io/) já foi concebido como _SSL-only_, ou seja, nessa versão já nem sequer há mais a opção de trafegar _HTTP_ plano. Navegadores como o _Chrome_, por exemplo, já tem há um bom tempo em seus planos [classificar explicitamente páginas _HTTP_ como não seguras](https://www.chromium.org/Home/chromium-security/marking-http-as-non-secure). Futuramente, toda página _HTTP_ deve ser exibida como abaixo (atualmente depende de habilitar uma _flag_ na configuração):

![Chrome avisa: esse pudim não é seguro!](../images/https-1.png)

A partir da versão 56, o Chrome já exibe **por padrão** avisos para formulários de senha ou cartão de créditos em páginas _HTTP_.

**(inserir screenshot aqui)**

Todos os outros navegadores também apontam na mesma direção - a migração total para _HTTPS_ parece ser uma realidade inevitável.

## 301 ou 302?

## Page ranking e bots
