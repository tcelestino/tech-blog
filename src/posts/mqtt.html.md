---
date: 2017-04-18
category: MQTT
layout: post
title: Criando um chat realtime com MQTT
description: Clojure é uma linguagem funcional e dinâmica que roda na JVM e que vem crescendo bastante no mercado de trabalho, com ajuda de algumas bibliotecas. Aprenda como subir uma API REST em 10 minutos!
author: cristianoperez
tags:
  - MQTT
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

Simples, facil e rapido. Porem qual o problema? Gera um enorme overread no servidor, o clinte fica batendo no servidor mesmo que não tenha nada de novo.
Isso torna a solução bem dificil de escalar, imagine o seguinte cenario, 10mil usuários online no site o servidor ira receber 10mil request por segundos apenas por os usuários estarem com a pagina aberta, agora imagine que cada usuário esta com 3 abas abertas, 10k * 3 = 30K Req/s (1.8 millhoes Req/min). Resultado DDoS em nós mesmos.

# WebSocket + HTTP

Como o http não foi pensando sendo uma via de 2 mãos, apenas de ida, fica dificil para o servidor informar nossa pagina que um evento especifico aconteceu e a pagina(ou parte dela) deve ser atualizada. Pensando nessa necessidade foi criado o WebSocket, com apenas uma requisição a conexão é aberta e mantida aberta com o servidor. Com isso o servidor consegue se comunica com o browser, e o browser reagir sem intervenção do usuário a cada mensagem que o servidor manda.




# WebSocket + MQTT








logo pensamos em WebSocket e que ele resolvera todos os nossos problemas. Porem a implementação padrão apresenta algumas limitações


MQTT é um protocolo de transporte que utiliza o paradigma publisher/subscriber. Leve, aberto, simples e desenhado para ser facil de implmentar. Essas caracteristicas fazem ele ser ideal para o uso de comunicação M2M (Machine to Machine) e IoT.

Foi criado em 1999 por um engenheiro da IBM com o intuito de conectar dutos de óleo com satelites, durante a criação o protocolo deveria ter as seguintes caracteristicas.
* Simples de implementar
* Garantia de entrega (QoS)
* Leve e utilização eficiente da banda
* Data Agnostic (Os dados podem ser enviados e recebidos independente da linguagem)
* Continuous Session Awareness (O estado da sessão deve ser preservado no disconnect/reconnect)
* Pub/Sub
