---
date: 2017-04-18
category: back-end
layout: post
title: Arquiteturas para aplicações realtime utilizando MQTT
description: Vamos descrever os diferentes tipos de arquitetura para criação de aplicações *realtime* e suas vantagens e desvantagens em relação ao MQTT
authors: [cristianoperez]
tags:
  - MQTT
  - WebSocket
  - Arquitetura
  - Polling
  - HTTP
  - PUB
  - SUB
  - PUB/SUB
---
Neste post vamos explicar alguns modelos arquiteturais para desenvolver um chat em *realtime* que deve atender às seguintes especificações:
* Mensagem 1-N: Apenas o usuário que recebeu a mensagem deve receber a notificação de nova mensagem
* *realtime*: O chat do destinatário deve ser atualizado sem nenhuma ação por parte do usuário
* *Lightspeed*: Todo o processo de envio e recebimento deve ser rápido e consumir o mínimo possível de recursos de todos os componentes (remetente, destinatário e servidor);

Quando temos como objetivo o desenvolvimento de uma aplicação *realtime* com essas características, com rápidas pesquisas (ou no caso de um leitor mais experiente, que verá essas opções como óbvias), podemos encontrar dois modelos arquiteturais, o *WebSocket* e o *Long Pooling*. A seguir discutiremos as vantagens e desvantagens de cada um:

# Short Polling

Nesse modelo, o cliente faz requisições periódicas para o servidor. Entre as opções, é o mais fácil e rápido de ser implementado.

Sua simplicidade pode ser vista nesse trecho de pseudo-código que simula requisições para buscar uma mensagem em uma conversa:
```
while (true) {
    fetch("http://localhost:8080/conversa/1/messages").then(msgs => {
        // trata a lista de novas mensagens
    });
}
```

Simples, fácil e rápido. Porém gera um enorme *overhead* tanto no servidor como no cliente, o cliente fica batendo no servidor mesmo que não tenha nada de novo, não é performático.
Imagine o seguinte cenário, 10mil usuários online, supondo que cada usuário possua uma média de 3 conversas abertas, o servidor receberá 30 mil requisições por segundo (1.8 milhões req/min). Sendo que a maioria delas não irá resultar em nada. Assim, no cenário descrito e com o uso de *Long pooling*, vamos precisar contar com bastantes recursos para atender esse grande número de requisições ou nossos servidores irão ficar indisponíveis (ataque DDoS em nós mesmos).

# Long polling

É parecido com o short polling, porém nesse cenário o servidor em vez de retornar respostas vazias quando não há nada de novo, o servidor segura a requisição com a conexão aberta até ter algo novo. Apesar de funcionar bem e do menor número de requisição, você pode acabar sem recursos (CPU/memória/threads) no servidor rapidamente.

# WebSocket + HTTP

Como o HTTP 1.X é um protocolo stateless e de apenas uma via, fica difícil para o servidor informar o cliente do usuário que um determinado evento ocorreu e é necessário um refresh em parte ou no todo da página. Para isso existe o protocolo *WebSocket*, que resolve esse problema estabelecendo e mantendo uma conexão entre cliente e servidor. O WebSocket específica como conectar, mas não especifica como mandar mensagens (não é um protocolo de transporte). Então, podemos usar o protocolo HTTP para mandar mensagens por meio de uma conexão WebSocket.

Assim, o servidor consegue comunicar-se com o browser, e o browser reagir sem intervenção do usuário a cada mensagem que o servidor manda.

Porém, no HTTP temos um *overhead* de headers.
![Lista com mais de vinte cabeçalhos enviados e recebidos numa requisição HTTP](../images/mqtt-6.png)
Um dos nossos requisitos é que ele seja *Lightspeed*. Esse *overhead* aumenta o tamanho da mensagem, consome mais banda e bateria no caso de *apps mobile*. Segundo um [estudo do google](http://dev.chromium.org/spdy/spdy-whitepaper), os requests variam entre 200 bytes até 2kb, com a maioria na casa dos 700-800 bytes.
```
~ $ curl -s -w \%{size_header} -o /dev/null www.elo7.com.br
438 bytes
```

# WebSocket + MQTT


MQTT é um protocolo de transporte que utiliza o *pattern* [publisher/subscriber](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern). Leve, aberto, simples e desenhado para ser fácil de implementar. Essas características fazem dele a melhor escolha quando se trata de comunicação Machine to Machine (M2M) e Internet das coisas (IoT, do termo em inglês *Internet of Things*).

Foi criado em 1999 por um engenheiro da IBM com o intuito de conectar dutos de óleo a satélites, com o objetivo de enviar métricas, possibilitando gerenciar remotamente os dutos. Os requisitos para o desenvolvimento do MQTT dizem que ele deve ser/ter:
* Simples de implementar
* Garantia de entrega (QoS)
* Leve e utilização eficiente da banda
* *Data Agnostic* (Os dados podem ser enviados e recebidos independente da linguagem)
* *Continuous Session Awareness* (o estado da sessão deve ser preservado no *disconnect/reconnect*)
* *Pub/Sub*

O MQTT resolve o problema do overhead de headers que temos no HTTP. É possível enviar uma mensagem com um header de apenas 2 bytes. Abaixo temos o formato de como deve ser a requisição:

![Esquema do cabeçalho de uma mensagem no protocolo MQTT](../images/mqtt-7.jpg)

Na tabela abaixo temos uma comparação entre MQTT e HTTP [fonte](https://pt.slideshare.net/steve.liang/mqtt-and-sensorthings-api-mqtt-extension)

| Cenário | HTTP | MQTT |
| --------- | --------- | --------- |
| GET | 302 *bytes* | 69 bytes (~4x) |
| POST | 320 *bytes* | 47 *bytes* (~7x) |
| GET 100x | 12600 *bytes* | 2445 *bytes* (~5x) |
| POST 100x | 14100 *bytes* | 2126 *bytes* (~7x) |

## Pub/Sub

Uma das vantagens do Pub/Sub é o desacoplamento que ele gera, o *publisher* não precisa saber para quem ou quantos clientes ele está enviando a mensagem. Isso é possível graças ao MQTT Broker. O *broker* filtra as mensagens baseado em tópicos. Cada cliente pode se inscrever em um ou mais tópicos. Quando uma mensagem é enviada, ela é destinada a um tópico específico, e todos os clientes inscritos no tópico de destino recebem a mensagem.

![Esquema de funcionamento da arquitetura pub/sub](../images/mqtt-8.png)

## Broker e Cliente
### Broker
É o coração e o cérebro do MQTT. É o responsável por receber e enviar as mensagens para os clientes corretos, pela garantia de entrega (QoS) e session. Algumas implementações têm *features* adicionais como segurança, *clusterização* e suporte a *WebSocket*.

[Lista de brokers](https://github.com/mqtt/mqtt.github.io/wiki/brokers)

### Cliente
É a *lib* que vai ficar dentro da sua aplicação, é a responsável por se conectar, enviar e receber as mensagens do *broker*. Os clientes estão [disponível em diversas linguagens e frameworks](https://github.com/mqtt/mqtt.github.io/wiki/libraries) como JAVA, JAVASCRIPT, .NET, C++, Go, Objective-C, Swift, etc. Isso quer dizer que desde aplicações web até pequenos dispositivos IoT, como sensores de temperatura, podem enviar e receber mensagens. O cliente se conecta com o *broker* enviando uma mensagem de `CONNECT` e o *broker* deve responder com `CONNACK`. Após a conexão ser estabelecida, ela é mantida aberta até o cliente se desconectar ou perder a conexão.

### Quality of Service (QoS)
QoS é o nível de garantia de entrega das mensagens entre cliente e servidor.

Existem 3 níveis:

QoS 0 - *At most once* (No máximo uma vez)

![qos0](../images/mqtt-1.png)

Garante o menor nível de entrega, também chamado de *fire and forget*. É o mais rápido, consome menos banda mas representa a menor garantia de entrega entre todos. Seu ciclo de vida é composto apenas pelo envio de uma mensagem pelo cliente ao *broker*.


QoS 1 - *At least once* (Pelo menos uma vez)

![qos1](../images/mqtt-2.png)

Garante que a mensagem será enviada pelo menos uma vez ao *broker*. Após a mensagem ser enviada, o cliente guarda essa mensagem até receber o `PUBACK` do *broker*, Caso o `PUBACK` não seja recebido em um determinado tempo, o cliente envia outro `PUBLISH`. Pelo lado do broker, quando ele recebe um `PUBLISH` com QoS 1, a mensagem é processada de imediato enviando para todos os `SUBs` e respondendo para o cliente com o `PUBACK`.
O cliente utiliza o packetId que é retornado no `PUBACK` para fazer a associação entre `PUBLISH` e `PUBACK`.


QoS 2 - *Exactly once* (Exatamente uma vez)

![qos2](../images/mqtt-3.png)

Garante que cada mensagem é recebida pelo menos uma vez pelo destinatário. Dos três tipos descritos é o que possui a maior garantia de entrega com o porém de ser mais lento.

Devemos ter em mente que, quanto maior o nível de QoS, mais trocas de mensagens são feitas. Isso afeta o tempo que a mensagem leva para ser efetivamente entregue, e gasta mais banda de rede e bateria em dispositivos móveis

## Arquitetura realtime do Elo7

![Arquitetura mqtt elo7](../images/mqtt-4.png)

A imagem acima é um resumo de como utilizamos o MQTT + *WebSocket*. Podemos separar o que acontece nas seguintes etapas:

- O comprador enviar uma mensagem para o vendedor

Quando uma mensagem é enviada, várias operações secundárias são executadas em segundo plano (envio de métricas, captura de eventos, push notifications, etc) a fim de não comprometer a operação principal, que é persistir a mensagem.
Realizamos essas operações de maneira assíncrona enfileirando uma mensagem no [SQS](https://aws.amazon.com/pt/sqs/). O *mqtt-publisher* é o *worker* responsável pelo processamento das mensagens da fila e as publica no tópico da conversa no broker MQTT (Mosquitto, no nosso caso).

- O vendedor recebe a mensagem

Ao abrir uma conversa, o cliente do vendedor se conecta ao *Mosquitto* via *WebSocket* e se inscreve (sub) no tópico daquela conversa. Isso é feito utilizando o cliente MQTT ([pahoJS](https://eclipse.org/paho/) no nosso caso), com isso ao receber uma nova mensagem do comprador a conversa é atualizada sem nenhuma interação (ex: atualização da página) por parte do vendedor.

## Conclusão

Foi demonstrado que existem certas vantagens ao se adotar o MQTT com *WebSocket*, porém nem tudo são unicórnios e arco-íris. Os custos para ter *realtime* são maiores em todos os aspectos (infra, manutenção, tempo de desenvolvimento e complexidade).

Caso decida por MQTT é necessário ter um bom conhecimento do *broker* escolhido, conhecer suas vantagens e desvantagens em relação aos outros, como você vai escalar ele no futuro, como trabalhar com *brokers* distribuídos e também segurança (afinal, não queremos que o usuário tenha acesso às mensagens que não são destinadas a ele).
Enfim, esperamos que essa análise possa ajudar os leitores na escolha da arquitetura ideal. Lembrando que essa escolha depende de muitos outros fatores, como análise do negócio, retorno do investimento, se a funcionalidade realmente precisa ser *realtime* e mais características internas da empresa/time envolvido.


