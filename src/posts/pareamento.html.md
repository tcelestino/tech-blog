---
title: Pareamento quase 100% do tempo, como é isso?
date: 2018-04-13
category: cultura
layout: post
description: Já ouviu falar de pareamento? Todos os dias e não aquele uma vez por ano? Sabe como isso funciona? Nesse post falarei como fazemos isso no time de front end aqui do Elo7 e como há uma rotação de pessoas, o fluxo de tarefas e o que achamos bom e ruim dessa cultura.
authors: [fernandabernardo]
tags:
  - agile
  - cultura
  - metodologias
  - processos
  - pareamento
---

Geralmente temos a visão dos programadores como sendo aquelas pessoas de fone que se isolam do mundo e de todos.

Mas existem outras formas do trabalho funcionar. Uma delas é a cultura de pareamento. Aqui no Elo7 todos os times tem essa cultura, mudando entre elas apenas a frequência que isso acontece. No meu time, de front end isso acontece em quase 100% do tempo. Ao longo desse post eu vou explicar mais como que funciona e quais são os pontos que eu acho vantagem e desvantagem.

# Como funciona?

Para começar, como é isso? Como na imagem abaixo, temos apenas uma máquina (PC), e nessa máquina conectamos dois monitores espelhados. Além disso, cada pessoa tem um teclado e um mouse. Logo, as duas pessoas podem mexer ao mesmo tempo.

![Pareamento no Elo7](../images/pareamento-01.png)

Já ouvi muitas pessoas perguntando se não funciona como um dojo, em que cada pessoa tem um tempo determinado para digitar e depois troca. Bom… na verdade não. É bem mais dinâmico que isso. E o nome disso é bom senso. Óbvio que às vezes coincide das duas pessoas mexerem ao mesmo tempo, mas aí entramos em um acordo e um só mexe. Mas na grande maioria das vezes esse processo acontece de forma intercalada e assim vamos desenvolvendo o código.

# Troca de pareamento

Outro questionamento bem comum é sobre a troca de duplas do pareamento. Não ficamos com as mesmas duplas todos os dias. Existe um revezamento. E isso pode mudar a cada um dia ou até mesmo no mesmo dia. Hoje, estou em um time de 5 pessoas. Isso significa que pode ter 2 duplas e uma pessoa sozinha todo dia.

Uma coisa importante de dizer, é que não temos lugar fixo, temos uma bancada com 6 computadores reservados ao nosso time. Isso facilita a troca de pareamento, porque é possível trocar facilmente de computador sem aquela ideia de "minhas coisas".

A troca de pareamento estimula a troca de conhecimento, já que cada pessoa tem um assunto que é mais especialista e também diminui a entrada de bugs em produção.

Também testamos e fazemos code review das nossas tarefas em duplas. Isso melhora a análise do código, já que duas pessoas podem analisar ou perceber partes diferentes. Além disso, é muito bom para passar conhecimento sobre alguma linguagem, sistema, design de código...

# Fluxo de uma tarefa

O pareamento influencia diretamente na execução de uma tarefa. Imagine o seguinte cenário: temos que desenvolver uma determinada tarefa, é apenas uma pessoa tem conhecimento do código daquela tarefa e do contexto dela. Essa pessoa que tem o conhecimento vai parear com a Pessoa01 para desenvolver a tarefa. Depois da tarefa desenvolvida, a tarefa passa para a fase de teste, e a regra é que nenhuma das pessoas que fez pode testar. Logo, Pessoa02 e Pessoa03 vão testar, pois também testamos tarefas em duplas. A tarefa pode ter mais ciclos de teste, já que podem ser encontrados bugs e colocar para fix. Fica nesse ciclo de teste e fix até que ela seja aprovada.

Ou seja, pelo menos 3 pessoas vão adquirir um novo conhecimento sobre esse feature, e pelo menos 4 pessoas vão saber sobre essa tarefa. Esse formato, além de passar um conhecimento para outras pessoas do time de uma forma mais simples, também evita que bugs entrem em produção (bugs sempre existem, mas eles diminuem), afinal 4 pessoas olharam aquele código e testaram aquela tarefa.

# Produtividade

A produtivdade é algo muito questionado quando o assunto é pareamento. A parte óbvia é que estamos deixando duas pessoas para produzir apenas uma tarefa, ou seja, precisaríamos do dobro de programadores para fazer o mesmo código que uma empresa que não tem pareamento. Mas não é bem assim... Ficamos muito menos dispersos quando estamos pareando, até porque uma pessoa acaba puxando a atenção da outra. Então o tempo que ficamos produzindo acaba sendo maior. Também tem muito menos tempo para procrastinação, como ficar olhando redes sociais, olhando para o editor de texto em branco pensando em uma solução.


# Conclusão

Essa é a nossa forma de lidar com o pareamento, e para gente funciona bem. É interessante lembrar que não somos tão rígidos nessas regras e que podemos ir mudando conforme nossas necessidades. Para finalizar vou listar o que eu acredito serem vantagens e desvantagens do uso do pareamento.

## Vantagens

- Compartilhamento de conhecimento rápido
- Menos bugs para produção
- Código tende a sair com melhor qualidade na primeira entrega
- Menos tempo travado em uma tarefa por não saber começar
- Foco maior, uma pessoa acaba puxando a outra

## Desvantagens

- Às vezes pode criar uma dependência da sua dupla, pois pode ficar cômodo ter sempre alguém para resolver um problema e não ficar um tempo "quebrando a cabeça". Para contornar isso, às vezes cada um prefere ficar sozinho para fazer uma tarefa.
- Desgastante. Por você ficar focado por muito mais tempo, a adaptação ao pareamento dessa forma pode ser um pouco desgastante no começo. Pois o tempo de procrastinação diminui muito.
- Para a pessoa que não está "pilotando", ou seja, que não está digitando no momento, pode ser um pouco massante. O que usamos para tentar evitar isso, é ir intercalando mais rápido, ou até mesmo dar uma parada para tomar um café e voltar melhor.

---

Você já trabalha com pareamento? Como que funciona na sua empresa? Deixe seu feedback ou sua pergunta aqui nos comentários :)
