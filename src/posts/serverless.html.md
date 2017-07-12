---
title: Serverless e AWS Lambda
date: 2017-07-10
category: back-end
layout: post
description: Serverless. O que é? Onde vide? Do que se alimenta?
author: cristianoperez
tags:
  - serverless
  - aws
  - lambda
  - aws lambda
---

Todos os dias surgem novas buzzwords no mercado cada uma relacionada a uma nova tecnologia/metodologia que promete revolucionar o modo de fazer as coisas, uma das mais recentes é a Serverless. Ao longo desse post vou tentar descrever sobre o que é e que não é essa nova buzzword e vai de você analisar se faz sentido ou não aplicá-la ao seu projeto.

## Serverless

Serverless são funções executadas em containers stateless, efêmero e gerenciado por terceiro. Fundamentalmente serverless é executar o seu código sem ter que gerenciar nenhum servidor.

O ciclo de vida pode ser representado assim

![serverless](../images/serverless-1.jpg)

1. O browser faz uma chamada rest para o endpoint do API gateway (Não se preocupe com ele agora, vamos falar mais sobre ele em breve)
2. O API Gateway faz a chamada da função baseado no endpoint que é chamado
3. A função relacionada ao endpoint chamado é executada em um container que foi criado apenas para executá-la
4. O container em qual a função foi executada é destruído

Note que em nenhum momento nos preocupamos como seria executada a nossa função, apenas escrevemos o código da função e pedimos para alguém executá-la, como ela vai fazer isso, escalar, gerenciar a disponibilidade e máquinas não é problema nosso.

Além das vantagens infra estruturais já citadas temos também a vantagem economia, pagamos apenas pelo o que realmente usamos.
Em uma arquitetura tradicional boa parte dos recursos (memória/CPU/rede/disco) do servidor ficam ociosos e são usados apenas em momentos de alta demanda, estamos pagando por esse recurso ocioso porém não podemos abrir mão dele pois em um momento de alta demanda a falta dele pode se tornar um problema e até mesmo derrubar o sistema, um exemplo disso pode ser observado no gráfico abaixo.

![request spikes](../images/serverless-2.png)
A linha vermelha representa a capacidade máxima provisionada, a verde o tráfico, as setas azuis são os recursos ociosos que pagamos mas só utilizamos por cerca de 10% do tempo.

Uma arquitetura serverless agi em cima desses dois problemas, recurso ocioso e aumentos súbito/spike de requisições, como não precisamos nos preocupar com infra/provisionamento/escalabilidade só é cobrado pelo o que for executado, nada mais de máquinas sendo executadas com recursos ociosos, você entrega seu código para o vendor(aws/azure/gcp/etc) e ele vai se vira como executar isso.

### Stateless

Todo serverless por natureza é stateless, lembra da imagem do ciclo de vida? Então, no final da execução nosso container é destruído levando consigo todas as informações que foram guardadas localmente, como variáveis estáticas, arquivos da pasta /tmp, estado da RAM. Tenha isso em mente quando for desenvolver algo que utilize serverless, uma opção seria salvar esses dados se forem importante para execuções futuras em algum outro lugar como um banco relacional, dynamo, redis ou S3.

## AWS Lambda

Como serverless em si só representa um conjunto de conceitos precisamos de alguém para implementá-lo, entre os mais usados temos AWS Lambda, Google Cloud Functions, Azure Functions e Apache OpenWhisk como opção open source. Nesse post por questões de abrangência de conhecimento da minha parte vamos utilizar o AWS Lambda.

O Lambda traz todos os benefícios já citado, nenhum servidor para provisionar e gerenciar, escala horizontal automática, nada de pagar por recurso ocioso, tolerância a falha e alta disponibilidade. É possível criar funções utilizando Java, python, Node e C#. As funções podem ser executadas a partir das seguintes fontes de eventos:

1. Resposta a eventos de outros produtos da AWS

É possível executar uma função como resposta a eventos de outros produtos da AWS como por exemplo queremos executar a função sempre que uma mensagem for adicionada na fila `xpto` do SQS, apenas quando for feito update na tabela `user` do DynamoDB ou no S3 quando for deletado um arquivo com extensão .properties do bucket `data.production`.

2. Chamadas REST utilizando o Amazon API Gateway

É possível criar um endpoint no Amazon API Gateway e associar ele a uma função.

3. AWS SDK

Caso vocês já tenha um sistema e precise chamar uma função o próprio SDK da AWS te proporciona isso.

4. Agendamento

É possivel agendar funções para serem executadas em determinados horários e dias. É utilizar expressões cron para isso.

### Segurança

Como em todos os produtos da amazon é possível utilizar roles e VPC específicas para cada função.

### Precificação

A precificação é feita baseada no número de execuções da função e duração

1. Duração

A partir do momento que a função começa a ser executada é iniciada a cobrança até o término dela, o tempo sempre é arredondado para os 100ms mais próximo, logo uma execução com 2ms e 99ms terão o mesmo valor. E o valor também varia pela quantidade de memória alocada para a função, 0,00001667 USD a cada GB/segundo usado.

2. Quantidade

0,20  USD por 1 milhão de solicitações depois disso (0,0000002  USD por solicitação)

3. Free tier

Para incentivar o uso do lambda a AWS oferece um nível gratis, 1 milhão de solicitações por mês e 400gb/segundo de tempo por mês.

### Limites

Como o Lambda não é a zueira ele tem alguns limites que devem ser levados em conta na hora do desenvolvimento.

| Recurso 				   | Limite |
| ------- 				   | ------ |
| Memória 				   | 128mb até 1536mb |
| Tempo máximo de execução | 300seg (5min) |
| Execuções paralelas 	   | 1000 |

A AWS quer que você utiliza o Lambda porém sem canibalizar seus outros produtos, então ela colocou alguns limites que podem complicar a sua vida, vamos ver como esses limites afetam a sua vida.

1. Memória

Deve ser configurada manualmente para cada função, não é elástica. Quantas vezes você criou uma função sabendo quanto de memória ela consumia? Lembre-se quanto maior a memória alocada para executar aquela função, mais caro você para. Facilitaria muito a vida se cada função tivesse memória elástica sendo cobrado com base no uso de memória e não na quantidade alocada podendo apenas limitar o tamanho máximo que ela pode consumir. Os limites de memória no geral são o suficiente para executar funções de propósito geral porém se for necessário algo mais pesado talvez seja melhor subir uma instância EC2 de uma máquina mais potente.

2. Tempo

Como a AWS não quer ninguém utilizando o lambda para rodar tasks grandes e pesadas ou long running applications afinal para isso existem outros produtos, ela coloca o tempo máximo de execução de 5min, esse tempo é configurado para cada função podendo ir de 1 seg até 5min. Após o tempo limite da função ser atingido ela é cortada sem nenhum tipo de callback apenas lançando uma exception no CloudWatch.

3. Execuções paralelas

Esse pode ser um dos mais problemático, como no lambda não existe separação entre ambientes, uma função executada em prod, dev ou teste entram no mesmo contador, o que pode se tornar um problema. Imagine o cenário, um desenvolvedor estar criando uma nova funcionalidade que dispara funções lambda, digamos que esse chamada da função fique dentro de um FOR/WHILE, ao testar a funcionalidade esse loop é chamado tantas vezes que ultrapassa o limite de 1000 execuções em paralelo, esse teste em dev vai afetar todas as funções de produção que vão começar a ser enfileiradas ou nem sendo executadas, degradando a performance de produção.

Esses são apenas alguns limites, no site da aws você pode encontrar todos os limites [http://docs.aws.amazon.com/lambda/latest/dg/limits.html](http://docs.aws.amazon.com/lambda/latest/dg/limits.html)

### Vendor lock-in

O primeiro passo ao utilizar uma arquitetura serverless é escolher o vendor. AWS? GCP? AZURE? Não importa muito a sua escolha no final do dia independente da sua escolha você estará preso a ele, principalmente quando as funções começam a se integrar e ser ativadas por eventos de outros produtos do vendor como filas (SQS, GCP pub/sub) por exemplo. Como você migra uma função do AWS Lambda para o Cloud Funcions e faz um ele manter a integração com a fila do SQS que ativa essa função? O trigger nativo que a AWS fornece é perdido, será necessário um trabalho de desenvolvimento em cima e provavelmente uma mudança no desenho da arquitetura e muito boiler plate code para fazer essa integração e tornando tudo muito custoso.


## Conclusão

Existem vários outro topico dos quais no falei como logging, test, deploy, boas práticas, entre outros que podem ficar para um próximo post. Falei o mundo mágico do serverless e como ele pode tornar sua vida mais produtiva, fácil de gerenciar e escalar as coisas, porém isso qualquer engenheiro de vendas das empresas citadas sabe falar, o importante é saber das limitações e restrições que existem. Serveless é um assunto muito novo no mercado o Lambda nasceu em 2014, Cloud Funcions 2011, que apesar de já estar sendo utilizado em grande escala e ser field tested só tende a melhorar no próximos anos, existem alguns frameworks que facilitam a vida na hora de criar funções como o [Serverless framework](https://serverless.com/) que trabalha de maneira genérica para abranger os principais provedores de serverless. Agora vai de sua necessidade avaliar o quanto essa restrição te afetam e decidir de vale a pena utilizar serverless ou não.


