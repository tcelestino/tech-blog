---
title: 'Gestão de logs'
date: 2016-09-27
category: devops
layout: post
description: Logs são parte fundamental de qualquer aplicação, e sua importância é notada especialmente nos momentos mais difíceis. Neste artigo veremos como gerenciar esses dados de forma eficaz e versátil, provendo robustez e, ainda assim, facilitando o dia-a-dia de nossas colabores aqui no Elo7.
author: edsonmarquezani
tags:
  - logs
  - graylog
---

## Introdução
_Todos os dias, universo afora, quantidades burlescas de logs são geradas pelos mais diversos tipos de sistemas, programas e até mesmo ínfimos e imperceptíveis scripts, mesmo nos "confins inexplorados da região mais brega da Borda Ocidental desta Galáxia". A maior parte desse aglomerado gigantesco de informação acaba perdida em meio a tanto volume, tão indistinto como um fóton num buraco negro. Nos momentos de dificuldade, qualquer viajante interestelar bem avisado e prevenido sempre tirará de sua mochila o bom e velho Grep. Entretanto, há momentos em que aquele velho one-liner (grep|cut|uniq|sort) não é suficiente ou, ao menos, não eficiente o bastante, nos fazendo pensar se aquele famoso Guia devia mesmo ser levado tão a sério assim. Em todo caso, esteja preparado para o fim do mundo, quando isso fatalmente acontecer e você não estiver com a arma certa em mãos._

(O parágrafo acima é para aqueles já iniciados no universo de _O Guia do Mochileiro das Galáxias_, do genial escrito britânico _Douglas Adams_. O restante dos leitores podem ignorá-lo e seguir direto para o parágrafo abaixo.)

Aqui no Elo7 nós cuidamos de nossos logs assim como cuidamos das pessoas - com muito carinho. Como toda empresa de tecnologia, nós geramos centenas de milhões de linhas de log diariamente, a partir dos mais diversos tipos de sistemas. Isso implica imediatamente em um problema: como gerenciar esses dados, organizá-los, salvá-los e disponibilizá-los para consulta quando necessário? Além disso, como extrair significado deles em tempo real e dar visibilidade da saúde de nossos sistemas e dos eventos que ocorrem? É disso que nesse artigo.

## Logs na era pré-Cloud
Logs sempre estiveram por aí, desde o momento em que o primeiro programa de computador foi criado. E, embora nem sempre tão estimados assim, eles são parte importantíssima de qualquer sistema, especialmente se você precisa diagnosticar um problema, coletar reatroativamente informações de uso ou execução, rastrear usuários, ou qualquer outra coisa que envolva saber o que seu programa fez efetivamente.
Até pouco tempo atrás, o formato predominante de armazenamento e consulta de logs era o velho e bom arquivo texto e o acesso a eles costumava ser direto, conectando-se no próprio servidor (ambientes _on-premise_) e lendo seu conteúdo. O surgimento da computação em nuvem, especialmente soluções de plataforma e software como serviço, onde não se tem um controle direto da infra-estrutura, tornou esse modelo pouco prático ou até mesmo inviável. Soluções de centralização de logs, embora, de fato, já fossem adotados em ambientes on-premises de grande escala, tornaram-se algo obrigatório para essa nova realidade da computação em nuvem, ou Cloud.

## Servidor de logs
Como já mencionado, servidores de logs não são exatamente um novidade. Alguns softwares bastante tradicionais como _Syslog_, _Syslog-ng_, _Rsyslog_, entre outros, vêm sendo usados como um centralizador de logs há muito anos, recebendo logs de múltiplas origens via rede e gerenciando seu armazenamento, filtragem, repasse, entre outras coisas. Entretanto, esses sistemas, ainda assim, não atacam um aspecto muito importante do problema: *a busca e visualização desses dados*.
Nos últimos anos, tendo como ponto de apoio outras soluções de armazenamento e indexação de informações (como ferramentas baseadas no popular motor de busca [Apache Lucene](https://lucene.apache.org/core/), por exemplo), algumas soluções mais completas de gerenciamento e visualização de logs surgiram, como [Splunk](https://www.splunk.com) e [Graylog](https://www.graylog.org/), que é um "concorrente" open-source do primeiro. Outras soluções, como [Kibana](https://www.elastic.co/products/kibana), também podem ser usadas para essa finalidade, embora não sejam focadas nesse tipo de aplicação prática.

## Logs fora de série
Aqui no Elo7, nós temos usado o Graylog como gerenciador de logs já há algum tempo, com sucesso. Ele é solução bastante completa, possuindo, entre outras, as seguintes funcionalidades:
- suporte a ingestão de logs via rede em diversos protocolos (_inputs_);
- interface gráfica para consulta dos dados (incluindo suporte a criação de _dashboards_ customizados);
- suporte a fluxos de filtragem e repasse dos eventos/logs (_outputs_);
- suporte a módulos (para _inputs_, _outputs_, entre outras coisas)

Embora gerencie toda a ingestão e visualização de dados, o Graylog não faz a persistência deles, delegando essa tarefa para um cluster de [Elastic Search](https://www.elastic.co/products/elasticsearch), que fica a cargo de armazenar, indexar e oferecer uma API de consulta para os dados.
