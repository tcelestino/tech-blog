---
title: 'Terraformando tudo - parte 1'
date: 2016-12-26
category: devops
layout: post
description: Início da série de posts 'Terraformando Tudo', que conta a nossa tragetória em busca da codificação da nossa infraestrutura. Esse primeiro post mostra nossas premissas para o projeto e como escolhemos o Terraform como ferramenta para nos auxiliar nesse caminho.
author: lucasvasconcelos
tags:
  - devops
  - terraform
  - IaC
  - Infrastructure as Code
  - infra
---

## Terraformando tudo - parte 1

Esse post dá início a uma série de posts intitulada **Terraformando tudo**. Nessa série iremos mostrar o caminho que trilhamos (e os percalços que tivemos) no **Elo7** e o que ainda falta alcançar a meta de termos **toda** nossa infraestrutura sendo gerenciada por código (o famoso IaC - Infrastructure as Code). 
Pelo título do post, é fácil ver que escolhemos o [**Terraform**](http://terraform.io) pra nos ajudar nessa tarefa, certo? :-). Mas como fizemos essa escolha? Hype? Know-how prévio? Nome bonito? Ninguém sabe?!?
Negativo! Apesar de *ágeis e early adopters*, pesamos nossas decisões em diversos aspectos, como curva de aprendizado, escopo da resolução do problema, possíveis *lock-ins* e escala à longo prazo.
E é exatamente disso que se trata esse primeiro post, um comparativo das features (**que nos interessam**) de cada ferramenta analisada e como nos pautamos para decidir utilizar o **Terraform**. Em nenhum momento esse post se trata de decidir se uma ferramenta é melhor que outra e sim, da ferramenta que é **melhor para nós e para nossas necessidades**. 

## Um paralelo com o desenvolvimento das nossas aplicações

Ao buscar codificar nossa infra, tinhamos como intuíto utilizar o mesmo fluxo que nós utilizamos para o desenvolvimento de nossas aplicações. Para termos o máximo de qualidade em tudo que fazemos, temos um fluxo rígido de desenvolvimento, que consiste em:

Pair-programming (cada dev com seu monitor/teclado/mouse na mesma workstation) -> Testes -> Pull-request -> Review/Testes -> Fixes -> Review/Testes fixes -> Deploy (ESSA LINHA SERÁ UM FLUXOGRAMA)

Nosso fluxo de desenvolvimento do código responsável por nossa infra deveria ser capaz de caber exatamente nesse fluxo, ou pelo menos em grande parte dele. Principalmente na parte de pair-programming e review. 

Além desse principal requisito, também temos algumas outras necessidades:
* Suporte à AWS;
* Opensource (com comunidade ativa :P);
* Foco em infra: nosso ambiente roda todo com Docker + fleet (e no futuro Kubernetes, teremos novidades aqui no blog huhuhu). Portanto, não iríamos fazer uso das features de automação de aplicações/configurações, por exemplo.

E ainda contamos com alguns requisitos não tão importantes, mas desejáveis:
* Curva de aprendizado curta;
* Que a ferramenta não seja desenvolvida em uma linguagem exótica (tipo Erlang) para que uma possível contribuição seja factível;
* Suporte ao GCP;

## Nossas opções

Fizemos uma pré-seleção de algumas ferramentas para, dentre elas, escolher a que melhor cumpre os nossos requisitos. As ferramentas foram escolhidas baseando-se nas funcionalidades, know-how prévio e confiabilidade. Todas as ferramentas escolhidas possuem a capacidade de cumprir com os nossos requisitos principais. São elas:
* Puppet;
* Chef;
* Ansible;
* Terraform;
* AWS CloudFormation;

Vale citar que, do ponto de vista de *IaC*, todas elas seguem as mesmas práticas, que ajudam principalmente na curva de aprendizado para quem já teve experiência prévia com algumas delas, que era o caso do time responsável pela implementação desse projeto. As ferramentas são:
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

Além de não gostarmos da sintaxe JSON do Cloud Formation, decidimos apostar na ferramenta. Mas, o feitiço pode voltar contra o feiticeiro. O que podia ser considerado uma vantagem pra nós, que é o fato da ferramenta estar dentro da AWS, também pode ser um ponto negativo. O Cloud Formation só dá suporte à AWS (obviamente :P) e não gostamos de lock-ins. Temos planos futuros de rodar em um ambiente multi-cloud e essa característica tirou o Cloud Formation da nossa lista.

Com Puppet, Chef e Ansible esperando para uma possível finalissíma entre os 3, ainda restava o Terraform para analisarmos. Como já sabem, ele foi o escolhido e, a seguir, veremos que características que fizeram com que escolhessemos o Terraform como ferramenta de cabeceira para nosso IaC.

### Conclusão: Terraform

Ao nos analisar friamente o Terraform, levantamos algumas características. Todas elas se encaixaram bem nos nossos requisitos, inclusive nos requisitos desejáveis.

Primeiramente, o Terraform tem o suporte da *Hashicorp*, empresa que contribui com outros diversos projetos Opensource já conhecidos, como o Consul e Vault. É um projeto escrito em Golang com comunidade muito ativa e um ciclo de releases de aproximadamente 20 dias, com cada release sempre trazendo novas features e fixes importantes.

Foi a ferramenta que cabe exatamente no nosso escopo de criação de infra e somente infra, sem se preocupar com a aplicação. Dando suporte à AWS (suporte aos principais serviços) e GCP, além de diversos outros providers como Azure e Openstack. 

A linguagem utilizada para criação da infra no Terraform é a HCL (Hashicorp Configuration Language), que é uma linguagem declarativa desenvolvida pela Hashicorp. Apesar de parecer um pouco estranha no início, nos acostumamos fácilmente com ela.

Encontramos alguns posts sobre o *Terraform*, alguns falando bem e outros falando mal, principalmente por ser uma ferramenta nova, que realmente carece de algumas funcionalidades. Fizemos validações e diversas simulações, principalmente de desastres. Estávamos muito precupados com comportamentos inesperados na hora de criar/destruir a nossa infra, principalmente mudanças críticas, como alteração de um registro DNS no *Route53*. Então queríamos conhecer exatamente como a ferramenta se comporta em diversas situações.

Encontramos sim, alguns problemas com a nossa escolha. Tanto técnicos como na definição de um fluxo que seja capaz de ser implementado para todo o time da Engenharia Elo7. Um assunto polêmico que fez a gente pensar bastante, foi como íamos tratar a infra já existente, criada na base do mouse... Mas esses serão assuntos para os próximos posts! :D

Pretendemos voltar logo mais, nesse mesmo canal, com os próximos posts dessa série, dando exemplos práticos de como utilizamos o Terraform e como resolvemos problemas conhecidos e não conhecidos nessa nossa aventura de Terraformar tudo. 

