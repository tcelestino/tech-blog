---
date: 2017-04-18
category: MQTT
layout: post
title: Criando um chat realtime com MQTT
description: Clojure é uma linguagem funcional e dinâmica que roda na JVM e que vem crescendo bastante no mercado de trabalho, com ajuda de algumas bibliotecas. Aprenda como subir uma API REST em 10 minutos!
author: cristianoperez
tags:
  - MQTT
  - WebSocket
  - Arquitetura
---
Nesse post vamos explicar alguns modelos arquiteturais para se criar um chat em realtime que deve atender as seguintes especificações.
* Mensagem 1-1 (Deve ser atualizado apenas para o usuário que recebeu a mensagem e se ele estiver na tela da conversa sendo atualizada)
* Realtime (O chat do destinatario deve ser atualizado sem nenhuma ação por parte do usuário)
* Lightspeed (Todo o processo de enviar a mensagem e o recebimento deve ser rapido, consumir o minimo de banda e processamento do remetente, destinatario e servidor)

 Quando se pensa em criar aplicações realtime logo vem na cabeça alguns modelos arquiteturais como WebSocket e Long Pooling, ambos tem seus prós e contras como vamos ver a seguir.

# Long Pooling

É o modelo no qual o cliente fica fazendo requisições para o servidor em um determinado intervalo de tempo. É o mais facil e rapido de ser implementado.

Pseudo code que fica buscando as mensagem da conversa
```
while(true){
	GET("http://localhost:8080/conversa/1/messages")
}
```

Simples, facil e rapido. Porem qual o problema? Gera um enorme overhead no servidor, o clinte fica batendo no servidor mesmo que não tenha nada de novo.
Isso torna a solução bem dificil de escalar, imagine o seguinte cenario, 10mil usuários online no site o servidor ira receber 10mil request por segundos apenas por os usuários estarem com a pagina aberta, agora imagine que cada usuário esta com 3 abas abertas, 10k * 3 = 30K Req/s (1.8 millhoes Req/min). Resultado DDoS em nós mesmos.

# WebSocket + HTTP

Como o http não foi pensando sendo uma via de 2 mãos, apenas de ida, fica dificil para o servidor informar nossa pagina que um evento especifico aconteceu e a pagina(ou parte dela) deve ser atualizada. Pensando nessa necessidade foi criado o WebSocket, com apenas uma requisição a conexão é aberta e mantida aberta com o servidor. Com isso o servidor consegue se comunica com o browser, e o browser reagir sem intervenção do usuário a cada mensagem que o servidor manda.

Bom, porem ainda temos um problema e ele se chama HTTP.
No HTTP temos um overhead de headers.
![headers](http://i.imgur.com/d3AOH7K.png)
Um dos nossos requisitos é que ele seja Lightspeed. Esse overhead aumenta o tamanho da mensagem, consome mais banda e bateria. Segundo um [estudo do google](http://dev.chromium.org/spdy/spdy-whitepaper) os requests variam entre 200 bytes até 2kb, com a maioria na casa dos 700-800 bytes.
```
~ $ curl -s -w \%{size_header} -o /dev/null www.elo7.com.br
438 bytes
```

# WebSocket + MQTT


MQTT é um protocolo de transporte que utiliza o paradigma publisher/subscriber. Leve, aberto, simples e desenhado para ser facil de implmentar. Essas caracteristicas fazem ele ser ideal para o uso de comunicação M2M (Machine to Machine) e IoT.

Foi criado em 1999 por um engenheiro da IBM com o intuito de conectar dutos de óleo aos satelites, durante a sua criação foi levantado que ele deveria ter as seguintes caracteristicas.
* Simples de implementar
* Garantia de entrega (QoS)
* Leve e utilização eficiente da banda
* Data Agnostic (Os dados podem ser enviados e recebidos independente da linguagem)
* Continuous Session Awareness (O estado da sessão deve ser preservado no disconnect/reconnect)
* Pub/Sub

O MQTT resolve o problema que temos no HTTP do overhead de headers, é possivel enviar uma mensagem com um header de apenas 2 bytes, abaixo temos o formato de como deve ser a requisição

![mttt header](http://www.rfwireless-world.com/images/MQTT-protocol-message-format.jpg)

A tabela abaixo temos uma comparação entre MQTT e HTTP

![http vs mqtt](http://i.imgur.com/wJo2kSN.png)

## Pub/Sub

Uma das vantagens do Pub/Sub é o desacoplamento que ela gera, o publisher não precisa saber para quem ou quantos clientes ele esta enviando a mensagem. Isso é possivel graças ao MQTT Broker. O broker filtra as mensagens baseado em topicos, cada cliente envia uma mensagem para um topico e quem tiver feito o subs daquele topico recebe a mensagem

![broker](http://www.hivemq.com/wp-content/uploads/Screen-Shot-2014-10-22-at-12.21.07.png)

## Broker e Client
### Broker
É o coração e o cerebro do MQTT é o responsavem por receber e enviar as mensagens para as pessoas corretas, garantia de entrega (QoS), session, algumas implementações tem features adicionais como segurança, clusterização e suporte a websocket.

[Lista de borkers](https://github.com/mqtt/mqtt.github.io/wiki/brokers)

### Client
É a lib que vai ficar dentro da sua aplicação
