---
title: 'Terraformando tudo - parte 1'
date: 2016-12-26
category: devops
layout: post
description: Logs são parte fundamental de qualquer aplicação, e sua importância é notada especialmente nos momentos mais difíceis. Neste artigo veremos como gerenciar esses dados de forma eficaz e versátil, provendo robustez e, ainda assim, facilitando o dia-a-dia de nossas colabores aqui no Elo7.
author: lucasvasconcelos
tags:
  - devops
  - terraform
  - IaC
  - Infrastructure as Code
  - infra
---

## Terraformando tudo - parte 1

Esse post dá início a uma série de posts intitulada **Terraformando tudo**. Nessa série iremos mostrar o caminho que trilhamos (e os percalços que tivemos) no **Elo7** e o que ainda falta alcançar na meta de termos **toda** nossa infraestrutura sendo gerenciada por código (o famoso IaC - Infrastructure as Code). 
Pelo título do post, é fácil ver que escolhemos o **Terraform** pra nos ajudar nessa tarefa, certo? :-). Mas como chegamos nessa conclusão? Hype? Know-how prévio? Nome bonito? Ninguém sabe?
Negativo! Apesar de *ágeis e early adopters*, pesamos nossas decisões em diversos aspectos, como curva de aprendizado, escopo da resolução do problema, possíveis *lock-ins* e escala à longo prazo.
E é exatamente disso que se trata esse primeiro post, um comparativo das features (**que nos interessam**) de cada ferramenta analisada e como nos pautamos para decidir utilizar o **Terraform**. Em nenhum momento esse post se trata de decidir se uma ferramenta é melhor que outra e sim, da ferramenta que é **melhor para nós**. 

## Um paralelo com o desenvolvimento das nossas aplicações

Ao buscar codificar nossa infra, tinhamos como intuíto utilizar o mesmo fluxo que nós já utilizamos para o desenvolvimento de nossas aplicações. Para termos o máximo de qualidade em tudo que fazemos, temos um fluxo rígido de desenvolvimento, que consiste em:

Pair-programming (cada dev com seu monitor/teclado/mouse na mesma workstation) -> Testes -> Pull-request -> Review/Testes -> Fixes -> Review/Testes fixes -> Deploy (ESSA LINHA SERÁ UM FLUXOGRAMA)

Nosso fluxo de desenvolvimento do código responsável por nossa infra deveria ser capaz de caber exatamente nesse fluxo, ou pelo menos em grande parte dele. Principalmente na parte de pair-programming e review. 

Além desse principal requisito, contamos com mais alguns:
* Suporte à AWS;
* Opensource (com comunidade ativa :P);
* Foco em infra: nosso ambiente roda todo com Docker + fleet (e no futuro Kubernetes, teremos novidades aqui no blog huhuhu). Portanto, não iríamos fazer uso das features de automação de aplicações, por exemplo.

E ainda alguns requisitos não tão importantes, mas desejáveis:
* Curva de aprendizado curta;
* Que a ferramenta não seja desenvolvida em uma linguagem exótica (tipo Erlang) para que uma possível contribuição seja factível;
* Suporte ao GCP;

## Nossas opções

Fizemos uma pré-seleção de algumas ferramentas para, dentre elas, escolher a que melhor cumpre os nossos requisitos. As ferramentas foram escolhidas baseando-se nas funcionalidades, know-how prévio e confiabilidade. Todas as ferramentas escolhidas cumpririam nossos requisitos principais. São elas:

* Puppet;
* Chef;
* Ansible;
* Terraform;
* AWS CloudFormation;

Vale citar que, do ponto de vista de IaC, todas elas seguem as mesmas práticas, que ajudam principalmente na curva de aprendizado para quem já teve experiência prévia com algumas delas, que era o caso do time responsável pela implementação desse projeto. Elas são:

* Declarativas;
* Buscam um estado final para a infra que está sendo criada;
* Controlam *recursos* da infra/configuração;
* Reutilização de código/referência entre recursos.

Os próximos sub-tópicos discutem os motivos que foram importantes **para nós** na escolha do Terraform.

### Puppet, Chef e Ansible

Nas nossas discussões sobre qual ferramenta escolher, essas 3 ficaram no mesmo balaio. Existia um know-how prévio dessas ferramentas no time, o que já trouxe elas para lista de finalistas automaticamente.
Porém, mesmo elas dando suporte à criação de infra, elas não foram concebidas para isso. A especialidade dessas ferramentas é gerenciamento de configurções e aplicações. O escopo onde elas brilham é a configuração de ambiente e aplicações.

Apesar de serem ferramentas completas, poderosas e confiáveis, extrapolavam bastante nosso escopo, então decidimos deixá-las em hold para ver se outra ferramenta se encaixaria melhor nas nossas necessidades. 

A outra opção veio de dentro do cloud provider que usamos (AWS).

### AWS Cloud-formation

Não poderíamos deixar de analisar a ferramenta oferecida pela própria AWS para gerenciamento de infraestrutura como código. Por ser da própria AWS, já podíamos contar com suporte a todos os recursos existentes (EC2, S3, route53, redshift, lambda, etc), além de performance e confiabilidade no que está sendo executado.

Além de não gostarmos da sintaxe JSON do Cloud Formation, decidimos pensar na ferramenta. Mas, o feitiço pode voltar contra o feiticeiro. O que podia ser considerado uma vantagem pra nós, que é o fato da ferramenta estar dentro da AWS, também pode ser um ponto negativo. O Cloud Formation só dá suporte à AWS (obviamente :P) e não gostamos de lock-ins. Temos planos futuros de rodar em um ambiente multi-cloud e essa característica tirou o Cloud Formation da nossa lista.

Com Puppet, Chef e Ansible esperando para uma possível finalissíma entre os 3, ainda restava o Terraform para analisarmos. Como já sabem, ele foi o escolhido e, a seguir, veremos que características que fizeram com que escolhessemos o Terraform como ferramenta de cabiceira para nosso IaC.

### Terraform

Ao nos deparar e analisar friamente o Terraform, levantamos algumas características dele. Todas elas se encaixaram bem nos nossos requisitos, inclusive nos requisitos desejáveis.

Primeiramente, o Terraform tem o suporte da *Hashicorp*, empresa que contribui com outros diversos projetos Opensource já conhecidos, como o Consul e Vault. É um projeto escrito em Golang com comunidade muito ativa e um ciclo de releases de aproximadamente 20 dias, com cada release trazendo bastante novas features e fixes importantes.

Foi a ferramenta que cabe exatamente no nosso escopo de criação de infra e somente infra, sem se preocupar com a aplicação. Dando suporte à AWS e GCP, além de diversos outros providers como Azure e Openstack. 

A linguagem utilizada para criação da infra no Terraform é a HCL (Hashicorp Configuration Language), que é uma linguagem declarativa desenvolvida pela Hashicorp. Apesar de parecer um pouco estranha no início, nos acostumamos fácilmente com ela.

## Conclusões e posts futuros

## Logs na era pré-Cloud
Logs sempre estiveram por aí, desde o momento em que o primeiro programa de computador foi criado. E, embora nem sempre tão estimados assim, eles são parte importantíssima de qualquer sistema, especialmente se você precisa diagnosticar um problema, coletar reatroativamente informações de uso ou execução, rastrear usuários, ou qualquer outra coisa que envolva saber o que seu programa fez de fato (e que você pode, ou não, ter previsto que ele faria).

Até pouco tempo atrás, o formato predominante de armazenamento e consulta de logs era o velho e bom arquivo texto e o acesso a eles costumava ser direto, conectando-se no próprio servidor (ambientes _on-premise_) e lendo seu conteúdo. Com o surgimento da computação em nuvem, especialmente soluções de plataforma e software como serviço, onde não se tem um controle direto da infra-estrutura, esse modelo tornou-se pouco prático ou até mesmo inviável. Soluções de centralização de logs, embora, de fato, já fossem adotados em ambientes on-premises de grande escala, tornaram-se algo obrigatório para essa nova realidade da computação em nuvem, ou _Cloud_. Nessa mesma linha, o surgimento e adoção de _containers_ como forma de entrega das aplicações só reforça essa necessidade.

## Servidores de logs
Como já mencionado, servidores de logs não são exatamente uma novidade. Alguns softwares bastante tradicionais como _Syslog_, _Syslog-ng_, _Rsyslog_, entre outros, vêm sendo usados como um centralizador de logs há muito anos, recebendo logs de múltiplas origens via rede ou localmente e gerenciando seu armazenamento, filtragem, repasse, entre outras coisas. Entretanto, esses sistemas, ainda assim, não atacam um aspecto muito importante do problema: **a busca e visualização desses dados**.

Nos últimos anos, tendo como ponto de apoio outras soluções de armazenamento e indexação de informações (como ferramentas baseadas no popular motor de busca [Apache Lucene](https://lucene.apache.org/core/), por exemplo), algumas soluções mais completas de gerenciamento e visualização de logs surgiram, como [Splunk](https://www.splunk.com) e [Graylog](https://www.graylog.org/), que é um "concorrente" _open-source_ do primeiro. Outras soluções, como [Kibana](https://www.elastic.co/products/kibana), também são usadas para essa finalidade, embora não sejam focadas nesse tipo de aplicação prática.

## Logs fora de série
### Graylog
Aqui no **Elo7**, nós usamos o _Graylog_ como gerenciador de logs já há algum tempo, com sucesso. Trata-se de uma solução bastante completa, possuindo, entre outras, as seguintes funcionalidades:
- suporte a ingestão de logs via rede em diversos protocolos (_inputs_);
- interface gráfica para consulta dos dados (incluindo suporte a criação de _dashboards_ customizados);
- suporte a fluxos de filtragem e repasse dos eventos/logs (_streams_ e _outputs_);
- suporte a módulos (para _inputs_, _outputs_, entre outras coisas).

![Busca de logs no Graylog](../images/gestao-de-logs-1.png)

Além de gerar logs em arquivo, nossas aplicações enviam os logs diretamente para o _Graylog_ em alguns dos formatos suportados. Aplicações internas tendem a usar o formato _GELF_ (um protocolo próprio do _Graylog_), pois temos a possibilidade de fazer essa customização. Já para aplicações terceiras de mercado, o _syslog_ (o protocolo, não o serviço) tende a ser um formato mais suportado, e portanto utilizado. Por exemplo, o servidor web _Nginx_ possui suporte a envio de logs em formato _syslog_ nativo, sem necessidade de qualquer customização. Uma vez entregues, esses logs ficam disponíveis aos usuários para consulta a partir do _Graylog_ por um período de tempo fixo, pré-estipulado, em dias.

![Agregação de valores no Graylog](../images/gestao-de-logs-3.png)

### Elastic Search e MongoDB
Embora gerencie toda a ingestão e visualização de dados, o _Graylog_ não faz a persistência deles, delegando essa tarefa para um cluster de [Elastic Search](https://www.elastic.co/products/elasticsearch), que fica a cargo de armazenar, indexar e oferecer uma API de consulta para os dados, utilizado pelo _Graylog_ para realizar as buscas dos usuários.

O _Elastic Search_ é um motor de busca baseado no já mencionado _Lucene_, que oferece funcionalidades de particionamento, replicação, agregação dos dados, entre diversas outras. O _Graylog_ cuida de criar os índices nele, rotacioná-los e purgá-los, tudo de acordo com a configuração definida pelo administrador.

O armazenamento de dados de configuração e _runtime_ do _Graylog_ ficam a cargo de um banco de dados _MongoDB_ (que pode estar em modo _replicaset_ ou _standalone_).

### Melhorias
Ainda que a solução acima nos atenda satisfatoriamente, ela possui alguns pontos fracos:
- indisponibilidades do _Graylog_ gera perda de eventos, que nunca mais são recuperados - os logs enviados durante o período de indisponibilidade são simplesmente perdidos;
- "sincronia" no recebimento dos dados - como o _Graylog_ não controla a ingestão dos dados, um aumento abrupto na geração de logs o sobrecarrega de uma só vez, podendo derrubar o serviço, mesmo que trate-se apenas de um pico e logo em seguida o volume de logs volte ao normal;
- efemeridade dos dados - devido à necessidade de expirarmos os dados do _Graylog_ (afinal, recursos **têm** limite), deixamos de ter um ponto central de armazenamento desses logs, voltando a depender dos velhos arquivos texto espalhados por diversas máquinas.

### Kafka
Embora existam uma série de alternativas possíveis pra solução dos problemas citados acima, optamos pela inclusão de um elemento a mais nessa arquitetura, que resolve ou facilita a solução de todos eles de uma só vez - o servidor de tópicos [Apache Kafka](http://kafka.apache.org/).

_Kafka_ é, segundo a definição oficial, um servidor de _commit-log_ distribuído, que oferece funcionalidades de replicação e particionamento. Na versão mais recente da nossa arquitetura, serve como ponto central da ingestão de logs, de modo que as aplicações possam enviá-los para um único local, e múltiplas fontes possam consumi-los. Além disso, serve como _buffer_ dos dados, evitando a perda em caso de indisponibilidade de outros componentes mais suscetíveis a falhas, como _Graylog_ e _Elastic Search_. Os dados nele também expiram, mas garantimos que fiquem disponíveis por tempo suficiente para que os outros sitemas possam se recuperar e zerar o atraso no consumo.

Dessa forma, isolamos a função de recebimento primário dos dados em um sistema altamente dedicado, conhecido por sua robustez, e que é totalmente independente do restante da arquitetura. O _Graylog_ passa a consumir os dados que estão no Kafka, que são enviados pelas aplicações. Além disso, torna-se muito mais simples e eficiente escalar o serviço para suportar a carga necessária, uma vez que ele é bastante leve e simples, por ser altamente especializado. Ao _Graylog_ é deixada apenas a função de enviar os dados para indexação e oferecer uma interface de consulta amigável aos usuários.

Diferente do _Graylog_, os dados disponíveis no _Kafka_ são facilmente "legíveis" por outras aplicações, o que nos permite plugar nessa arquitetura outros componentes como, por exemplo, um agente externo que faz o arquivamento desses logs em um outro tipo de _storage_, como o [Amazon S3](https://aws.amazon.com/pt/s3/). Foi exatamente dessa forma que atendemos uma das exigências do [Marco Civil da Internet](http://www.planalto.gov.br/ccivil_03/_ato2011-2014/2014/lei/l12965.htm), que determina que as empresas preservem os dados de acesso e transações dos usuários por determinado período de tempo, para fornecer à Justiça, caso assim determinado. Assim como nesse caso, qualquer outro sistema que precise desses dados também poderia consumi-los de forma independente.

O desenho conceitual final da arquitetura fica como abaixo:

![Arquitetura Logs Elo7](../images/gestao-de-logs-2.png)

E você, como gerencia seus logs? Deixe um comentário abaixo!
