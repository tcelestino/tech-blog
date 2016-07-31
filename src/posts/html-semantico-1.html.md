---
date: 2016-08-01
category: front-end
layout: post
title: 'A importância da semântica no HTML - parte I'
description:
author: rapahaeru
tags:
  - html
  - semantica
  - SEO
  - acessibilidade
  - front-end
---

![Onde encontrar](../images/onde-encontrar.jpg)

Antigamente a informação era armazenada em papéis, rochas e até paredes. A única forma de encontrar o que queríamos era indo até o local no qual a mensagem estava armazenada. Hoje existe um mundo digital onde se gera terabytes por segundo.

E para onde vai toda essa informação? Será que ficou mais fácil encontrar o que se deseja? O problema atual não é a escassez, mas a quantidade de ruído proveniente de uma quantidade exorbitante de dados.

Para facilitar que o seu conteúdo criado seja encontrado, é fundamental utilizar um conceito que não é nem um pouco novo: a semântica.

Este é o primeiro de dois posts que trataremos sobre semântica na web. Falaremos de forma introdutória sobre a sua importância e a sua real utilidade, tanto para usuários quanto para nós desenvolvedores.

### O que é semântica ?
Semântica é uma palavra que tem origem no grego semantikos, termo que pode ser traduzido como “aquilo que tem sentindo”. É o estudo do significado dos signos, que podem ser palavras, frases ou sons na linguagem.

### Qual a importância do HTML semântico para o profissional front-end ?
O objetivo do HTML é marcar o conteúdo de um site de acordo com o seu significado, estruturando a informação a ser passada. Quanto mais semântico, mais fácil para os leitores (usuários ou motores de busca) interpretarem as informações de um site.

E apesar de um site ser composto por HTML, CSS e JavaScript, é do HTML a responsabilidade de repassar as informações. Os outros dois têm outras responsabilidades que ajudam o HTML no seu papel.

É no HTML que os motores de busca e leitores de tela procurarão informações armazenadas em seus reais significados. O CSS estilizará os elementos para que o conteúdo fique mais claro, mais legível. Já o JavaScript cuida de definir as atuações dos elementos e aprimorando a experiência para o usuário, porém aqui no Elo7 sempre nos preocupamos em desenvolver de forma não obstrutiva ( quando não afeta a experiência do usuário na falta do JavaScript). Então, se soubermos como organizar as marcações no HTML de forma correta, podemos ter muitos benefícios.

### Acessibilidade e visibilidade
Ser acessível para pessoas com deficiência. Esse é um dos vários pilares de um HTML bem estruturado semanticamente, independente de sua apresentação visual. Clientes não visuais podem acessar um site utilizando um leitor de tela para "ouvir" sua página. Não podemos esquecer dos robôs de busca que também são leitores não-visuais e varrem todo o HTML para detectar a melhor maneira de apresentar os dados a quem os procura.

Ainda não possuímos computadores/algoritmos capazes de interpretar o significado dos conteúdos na web, mas podemos ajudar a marcar um trecho de informação e "tagueá-lo", atribuindo a ele um significado.

Por exemplo, ao inserir a tag <h1>, você está informando que este é o seu título mais importante de sua página (ou seção =]), independente do idioma.

Utilizando microdatas baseados em vocabulário, como o Schema (aprofundaremos mais futuramente) podemos atribuir o título da página a um objeto ou a um sentimento. Por exemplo, uma página que vende bem-casado pode ter como título "lembranças de casamento" e ser associada tanto a um objeto que se presenteia ou a uma memória de casamento.

Graças a esse tipo de meta informação, hoje já podemos encontrar nos sites de busca o que procuramos de forma mais exata, e a tendência é que isso se aprimore cada vez mais.

### Significados
![Significado da informção](../images/significado-da-informcao.jpg)

Cada elemento do HTML é uma etiqueta que representa um significado, porém, em nosso idioma há algumas similaridades e pequenas nuances que podem oferecer outros sentidos, como exemplificado acima com a palavra "lembrança".

Como um computador diferenciaria ou interpretaria uma frase entre aspas ou uma citação?

Ao falarmos de semântica em nosso código, precisamos nos focar na diversidade interpretativa. Aparentemente, ao utilizar as tags <q> e <bloquote> não é possível notar muita diferença, mas ao saber utilizá-las de forma específica, o contexto pode ser alterado sutilmente.

Utiliza-se <q> com o objetivo de fazer uma citação do texto atual discorrido. Já o <bloquote> é focado em uma citação externa ao texto.

Há o caso de inserir apenas as aspas e pronto, porém o computador sabe diferenciar o significado? Também não podemos esquecer do <cite> que no HTML5 atualizou seu contexto. No html 4.01 a tag era referente a uma citação e na versão atual se refere ao nome de uma obra a ser creditada. Caso queiram mais comparações de significado, recomendo o post da Dani Guerrato  no Tableless.

Mas aí entra um questionamento, por que mudar o contexto de uma tag? O desenvolvimento web tem um paralelo com a nossa linguagem, sutil, porém importante. A língua é viva e não pode ser controlada. Portanto, o que hoje significa algo, amanhã pode ter outro significado e os padrões deverão ser atualizados.

Com isso, o HTML faz com que o conteúdo seja mais "apresentável" para leitores não-visuais, oferecendo uma melhor forma de compreensão do documento. Além disso, fica mais fácil a manutenção da página por outros desenvolvedores.

Saber como expor seus dados ao mundo é fundamental. Saber da forma correta é ainda melhor.

Por enquanto é só, mas este tema continuará no próximo post.
