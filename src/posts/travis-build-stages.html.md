---
title: Controlando e melhorando a performance do build no Travis CI
date: 2017-11-17
category: front-end
layout: post
description: Aprenda como criar fluxos de forma simples e flexível em uma das ferramentas mais famosas de Integração Contínua: o Travis CI. Além disso, veja  como podemos otimizar o seu tempo de execução.
authors: [williammizuta]
tags:
  - travis ci
  - integracao continua
  - testes
---

![Alt "Travis CI"](/images/travis-build-stages-1.png)

Hoje a maioria dos projetos, tanto de código livre quanto fechado, utilizam [git](https://git-scm.com) como a ferramenta de controle de versão. E muitos destes estão hospedados no [GitHub](https://github.com), uma das plataformas mais comuns para armazenamento de projetos. Além disso, muitos projetos adotam a prática conhecida como integração contínua ou [continuous integration](https://martinfowler.com/articles/continuousIntegration.html), a qual visa facilitar a integração do código sendo desenvolvido e encontrar problemas mais rapidamente. Há inúmeras ferramentas que auxiliam a implementação dessa prática. Aqui no [Elo7](https://www.elo7.com.br?utm_source=tech-blog&utm_medium=travis-build-stages), utilizamos tanto o [Jenkins](https://jenkins.io) quanto o [Travis CI](https://travis-ci.org). Neste post falarei um pouco mais sobre como controlar este processo e como melhorar o tempo de build no [Travis Ci](https://travis-ci.org).

## Por que utilizar o Travis CI?
O Travis CI é uma plataforma de integração contínua que se integra com o GitHub de forma bem simples. E não importa se o time utiliza a metodologia do GitHub Flow, feature branches ou commit direto na master, o Travis CI auxilia na entrega do código. Além disso, o Travis CI já traz ambientes preparados para diversas linguagens como JavaScript, Java, PHP, Python, Ruby e Swift.

E como não há nenhum custo para projetos de código livre (open source), vários deles utilizam o Travis CI ([Angular](https://travis-ci.org/angular/angular), [jQuery](https://travis-ci.org/jquery/jquery) e [Bootstrap](https://travis-ci.org/twbs/bootstrap)). Inclusive alguns dos projetos abertos do [Elo7](https://travis-ci.org/elo7) utilizam essa ferramenta.

## Criando workflows com build stages
Recentemente, o Travis CI anunciou a adição de uma nova ferramenta que permite criar fluxos (_pipelines_) de forma bem flexível: [build stages](https://blog.travis-ci.com/2017-05-11-introducing-build-stages). Nós já a adotamos para manter o nosso [blog técnico](https://travis-ci.org/elo7/tech-blog):

![Alt "Build stages do blog"](/images/travis-build-stages-2.png)

Com isso, conseguimos definir o que cada estágio do fluxo precisa fazer de forma bem simples:

```yaml
jobs:
  include:
    - stage: test
      script: <script de teste>
    - stage: deploy
      script: <script de deploy>
```

Além disso, conseguimos definir a ordem que os estágios devem executar:

```yaml
stages:
  - name: test
  - name: deploy
```

E se um deles falhar, os seguintes não rodarão. No caso do blog, o deploy não é realizado se os testes falharem.

Outra vantagem dos _build stages_ é que conseguimos definir facilmente regras que um estágio deve rodar. Por exemplo, podemos definir que o processo de deploy rode apenas quando o CI for disparado a partir da _branch_ _master_ e que não seja um _pull request_.

```yaml
stages:
  - name: test
  - name: deploy
  if: branch = master AND NOT type = pull_request
```

Juntando tudo, temos o seguinte código:

```yaml
stages:
  - name: test
  - name: deploy
  if: branch = master AND NOT type = pull_request
jobs:
  include:
    - stage: test
      script: <script de teste>
    - stage: deploy
      script: <script de deploy>
```

## Otimizando o Travis com build stages

Outra vantagem do _build stages_ é que podemos paralelizar a execução do fluxo da aplicação. Para isso, basta escrever mais de uma _job_ com o mesmo estágio:

```yaml
jobs:
  include:
    - stage: test
      script: <script de teste 1>
    - stage: test
      script: <script de teste 2>
    - stage: test
      script: <script de teste 3>
    - stage: deploy
      script: <script de deploy>
```

Dessa forma, o estágio de teste disparará 3 _jobs_ que rodarão em paralelo. Se todos eles passarem, o estágio de _deploy_ é iniciado.

## Conclusão

O _build stages_ veio para facilitar a criação de fluxos de integração contínua de projetos além de ajudar a otimizar o processo paralelizando a execução de _scripts_.
