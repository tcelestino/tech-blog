---
date: 2017-04-18
category: MQTT
layout: post
title: Arquiteturas para aplicações realtime utilizando MQTT
description: Vamos descrever os diferentes tipos de arquitetura para criação de aplicações realtime e suas vantagens e desvantagens em relação ao MQTT
authors: [cristianoperez]
tags:
  - MQTT
  - WebSocket
  - Arquitetura
---
Neste post vamos explicar alguns modelos arquiteturais para desenvolver um chat em realtime que deve atender as seguintes especificações:
* Mensagem 1-N: Apenas o usuário que recebeu a mensagem deve receber a notificação de nova mensagem
* Realtime: O chat do destinatário deve ser atualizado sem nenhuma ação por parte do usuário
* *Lightspeed*: todo o processo de envio e recebimento deve ser rápido e consumir o mínimo possível de recursos de todos os componentes (remetente, destinatário e servidor);

 Quando temos como objetivo o desenvolvimento de uma aplicação realtime com essas características, com rápidas pesquisas (ou no caso de um leitor mais experiente, que verá essas opções como óbvias), podemos encontrar dois modelos arquiteturais, o WebSocket e o Long Pooling. A seguir discutiremos as vantagens e desvantagens de cada um:

# Long Pooling

Nesse modelo, o cliente faz requisições periódicas para o servidor. Entre as duas opções, é o mais fácil e rápido de ser implementado.

Sua simplicidade pode ser vista nesse trecho de pseudo-código que simula requisições para buscar uma mensagem em uma conversa:
```
while(true){
	GET("http://localhost:8080/conversa/1/messages")
}
```

Simples, fácil e rápido. Porém gera um enorme overhead no servidor, o cliente fica batendo no servidor mesmo que não tenha nada de novo, não é performático. Supondo que cada usuário possua uma média de 3 conversas, o servidor receberá 30 mil requisições por segundo (1.8 milhões req/min). Sendo que a maioria delas não irá resultar em nada. Assim, no cenário descrito e com o uso de Long pooling, vamos precisar contar com bastante recursos para atender esse grande número de requisições ou nossos servidores irão ficar indisponíveis (ataque DDoS em nós mesmos).

# WebSocket + HTTP

Como o HTTP 0.9/1.0/1.1 não foi pensando sendo uma via de 2 mãos, apenas de ida, o HTTP/2 busca resolver alguns desses problemas. Fica difícil para o servidor informar nossa pagina que um evento específico aconteceu e a página(ou parte dela) deve ser atualizada. Pensando nessa necessidade foi criado o WebSocket, com apenas uma requisição a conexão é aberta e mantida aberta com o servidor.
Com isso o servidor consegue comunicar-se com o browser, e o browser reagir sem intervenção do usuário a cada mensagem que o servidor manda.

Porém no HTTP temos um overhead de headers.
![headers](../images/mqtt-6.png)
Um dos nossos requisitos é que ele seja Lightspeed. Esse overhead aumenta o tamanho da mensagem, consome mais banda e bateria no caso de apps mobile. Segundo um [estudo do google](http://dev.chromium.org/spdy/spdy-whitepaper) os requests variam entre 200 bytes até 2kb, com a maioria na casa dos 700-800 bytes.
```
~ $ curl -s -w \%{size_header} -o /dev/null www.elo7.com.br
438 bytes
```

# WebSocket + MQTT


MQTT é um protocolo de transporte que utiliza o pattern [publisher/subscriber](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern). Leve, aberto, simples e desenhado para ser fácil de implementar. Essas características fazem ele ser ideal para o uso de comunicação M2M (Machine to Machine) e IoT.

Foi criado em 1999 por um engenheiro da IBM com o intuito de conectar dutos de óleo aos satélites, com o objetivo de enviar métricas, possibilitando gerenciar remotamente os dutos. Os requisitos para o desenvolvimento do MQTT dizem que ele deve ser/ter:
* Simples de implementar
* Garantia de entrega (QoS)
* Leve e utilização eficiente da banda
* Data Agnostic (Os dados podem ser enviados e recebidos independente da linguagem)
* Continuous Session Awareness (O estado da sessão deve ser preservado no disconnect/reconnect)
* Pub/Sub

O MQTT resolve o problema que temos no HTTP do overhead de headers, é possível enviar uma mensagem com um header de apenas 2 bytes, abaixo temos o formato de como deve ser a requisição:

![mttt header](../images/mqtt-7.jpg)

Na tabela abaixo temos uma comparação entre MQTT e HTTP

![http vs mqtt](../images/mqtt-5.png)

## Pub/Sub

Uma das vantagens do Pub/Sub é o desacoplamento que ele gera, o publisher não precisa saber para quem ou quantos clientes ele está enviando a mensagem. Isso é possível graças ao MQTT Broker. O broker filtra as mensagens por tópicos, cada cliente envia mensagens para um determinado tópico que quem estiver inscrito neste tópico, receberá a mensagem.

![broker](http://www.hivemq.com/wp-content/uploads/Screen-Shot-2014-10-22-at-12.21.07.png)

## Broker e Client
### Broker
É o coração e o cérebro do MQTT é o responsável por receber e enviar as mensagens para os clientes corretos, pela garantia de entrega (QoS) e session. Algumas implementações têm features adicionais como segurança, clusterização e suporte a websocket.

[Lista de borkers](https://github.com/mqtt/mqtt.github.io/wiki/brokers)

### Client
É a lib que vai ficar dentro da sua aplicação, é a responsável por se conectar, enviar e receber as mensagens do broker. Os clients estão [disponível em diversas linguagens e frameworks](https://github.com/mqtt/mqtt.github.io/wiki/libraries) como JAVA, JAVASCRIPT, .NET, C++, Go, Objective-C, Swift, etc. Isso quer dizer que é possível enviar e receber mensagens desde aplicações web até pequenos dispositivos IOT como sensores de temperatura. O cliente se conecta com o broker enviando uma mensagem de ´CONNECT´ e o broker deve responder com ´CONNACK´, após a conexão estabelecida ela é mantida aberta até o cliente se desconectar ou perder a conexão.

### Quality of Service (QoS)
QoS é o nível de garantia de entrega das mensagens entre cliente e servidor.

Existem 3 níveis:

QoS 0 - At most once

![qos0](../images/mqtt-1.png)

Garante o menor nível de entrega, também chamado de *fire and forget*. É o mais rápido, consome menos banda mas representa a menor garantia de entrega entre todos. Seu ciclo de vida é composto apenas pelo envio de uma mensagem pelo cliente ao broker


QoS 1 - At last once

![qos1](../images/mqtt-2.png)

Garante que a mensagem será enviada pelo menos uma vez ao broker. Após a mensagem ser enviada, o cliente guarda essa mensagem até receber o PUBACK do broker, caso o PUBACK não seja recebido em um determinado espaço de tempo, o cliente envia outro PUBLISH. Quando o broker recebe um PUBLISH com QoS 1, a mensagem é processada de imediato enviando para todos os SUBs e respondendo para o cliente com o PUBACK.
O cliente utiliza o packetId que é retornado no PUBACK para fazer a associação entre PUBLISH e PUBACK


QoS 2 - Exacly once

![qos2](../images/mqtt-3.png)

Garante que cada mensagem é recebida pelo menos uma vez pelo destinatário. Dos três tipos descritos é o que possui a maior garantia de entrega com o porém de ser mais lento.


Devemos ter em mente que quanto maior o nível de QoS, mais trocas de mensagens são feitas, isso afeta o tempo que a mensagem é efetivamente entregue, gasta mais banda de rede e bateria em dispositivos móveis.


## Arquitetura real time do Elo7

![Arquitetura mqtt elo7](../images/mqtt-4.png)

A imagem acima é um resumo de como utilizamos o MQTT + WebSocket. Podemos separar o que acontece nas seguintes etapas:

- O comprador enviar uma mensagem para o vendedor

Quando a mensagem enviada existe a necessidade de realizar diversas operações secundárias (enviar métricas, capturar eventos, enviar push, notificar o mosquitto) a fim de não comprometer a operação principal, que é salvar a mensagem.
Realizamos essas operações de maneira assíncrona enfileirando uma mensagem no [SQS](https://aws.amazon.com/pt/sqs/). Temos o mqtt-publisher que é um worker que fica processando as mensagens da fila e faz o publish no tópico da conversa no mosquitto.

- O vendedor recebe a mensagem

O vendedor ao abrir a conversa se conecta no Mosquitto por WebSocket e faz o subscribe no tópico daquela conversa. Isso é feito utilizando o client MQTT (pahoJS no nosso caso), com isso ao receber uma nova mensagem do comprador a conversa é atualizada sem nenhuma interação (Ex: refresh na página) por parte do vendedor.

## Conclusão

Foi demonstrado que existem certas vantagens ao se adotar o MQTT com WebSocket, porém nem tudo são unicórnios e arco-íris. Os custos para ter realtime são maiores em todos os aspectos (infra, manutenção, tempo de desenvolvimento e complexidade).

Caso decida por MQTT é necessário ter um bom conhecimento do broker escolhido, conhecer suas vantagens e desvantagens em relação aos outros, como você vai escalar ele no futuro, como trabalhar com brokers distribuídos e também segurança (afinal, não queremos que o usuário tenha acesso às mensagens que não são destinadas a ele.
Enfim, esperamos que essa análise possa ajudar os leitores na escolha da arquitetura ideal. Lembrando que essa escolha depende de muitos outros fatores, como análise do negócio, retorno do investimento, se a funcionalidade realmente precisa ser realtime e mais características internas da empresa/time envolvido.
