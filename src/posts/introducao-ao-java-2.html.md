---
title: 'Introdução ao Java - parte 2'
date: 2016-12-24
category: back-end
layout: post
description: Entenda como controlar o fluxo de funcionamento do seu código usando expressão boolena. Entenda o funcionamento do "if", "else", "for", "while" e de alguns operadores.
author: tcelestino
tags:
  - java básico
  - controle de fluxo
---

No [primeiro post](http://engenharia.elo7.com.br/introducao-ao-java/) da série de introduação ao Java, mostrei como configurar e executar nosso código Java. Continuando, nesse post vou apresentar alguns conceitos que são necessários para lidarmos com o controle de fluxo na lógica de funcionamento dos nossos códigos. Sim, vamos continuar no básico, porém essencial para os próximos posts, que pretende se tornar muito mais interessante. Mas vamos deixar de conversa e partimos!!

##Lidando com o controle de fluxo

Provavelmente, se você já iniciou algum estudo em qualquer linguagem de programação, acredito que já tenha ouvido falar de "if", "else", do "while" e "for". Eles são usadas quando queremos criar alguma condicional, ou seja, controlar o fluxo de funcionamento dos nossos códigos.

Para trabalharmos com condicionais, vamos precisar criar uma expressão booleana, que é nada mais, nada menos, uma expressão que retorna "true" ou "false". Para obter o resultado esperado, podemos usar os seguintes operadores: < (menor que), > (maior que), <= (menor e igual a que), >= (maior e igual a que), == (igual a), != (diferente de), entre outros. Basicamente, podemos encontrar esses operadores em diversas outras linguagens (Java, Ruby, Javascript etc...).

### - if, else, else if

Vamos imaginar que temos um caso de uso: apenas maiores de idades podem visualizar a mensagem de texto.

```Java
public void main(String[] args) {
  int menorIdade = 15;

  if(menorIdade < 18) {
    System.out.println("Você ainda é menor de idade!");
  } else {
    System.out.println("Agora você é maior de idade.");
  }
}
```

Analisando o código acima, podemos notar que existe uma expressão booleana, no qual verificamos se o valor da nossa váriavel 'menorIdade' tem o valor menor que o número 18. Para executar o código acima, tem uma [tem a cola aqui](http://engenharia.elo7.com.br/introducao-ao-java/). Agora, se alteramos o valor da váriavel para um valor acima de 18, o que aconteceria? Execute o código e veja.

Para deixarmos mais interessante nosso código, vamos adicionar mais uma expressão booleana, que irá verificar duas situações:

1. se valor da váriavel menorIdade é menor que 18;
2. se o valor da váriavel maiorIdade é maior que 18.

```Java
public void main(String[] args) {
  int menorIdade = 15;

  if(menorIdade < 18) {
    System.out.println("Você ainda é menor de idade!");
  } else if (menorIdade == 18) {
    System.out.println("Agora você é maior de idade.");
  } else {
    System.out.println("Reveja sua idade, parça!");
  }
}
```

Executando o código acima, ele exibirá a primeira condicional, porém se alteramos o valor da variável `menorIdade` para 18, entrará no "else if" e se alteramos o valor para maior que 18, o que acontece?

### - while

A palavra "while" no português pode ser traduzida pela a palavra "enquanto". Na expressão booleana, esse é o comportamento que precisamos executar uma operação que em um "período de tempo", ou até chegarmos a uma quantidade de de loops naquela mesma condicional.

Um exemplo básico de como usar o "while".

```Java
public void main(String[] args) {
  int numero = 0;

  while(numero < 20) {
    System.out.println(numero);
    numero = numero + 1;
  }
}
```

No código acima, a variável "numero" receberá novos valores até chegar ao valor que está sendo comparada. Ou seja, enquanto a variável estiver com o status verdadeiro (true), o código será executado, havendo a sobrescrita do valor anterior e fazendo a soma do valor atual. A execução do trecho do código só é finalizada quando o valor da variável chegar ao valor menor que 20. Vamos melhorar um pouco o código, deixando um pouco mais interessante.

```Java
public void main(String[] args) {
  int menorIdade = 15;


  while(menorIdade < 20) {
    if(menorIdade < 18) {
      System.out.println("Você ainda é menor de idade!");

      } else if(menorIdade == 18) {
        System.out.println("Agora você é maior de idade.");

      } else {
        System.out.println("Reveja sua idade, parça!");
      }

    menorIdade = menorIdade + 1;
  }
}
```

Isso é apenas um exemplo de como podemos fazer uma combinação de várias expressões boolenas para criar lógicas em nossos códigos.

### - for

O "for" tem o mesmo comportamento do "while", porém podemos executar nossos códigos de maneira mais prática e mais legível. Veja o exemplo:

```Java
public void main(String[] args) {
  for (int i = 0; i < 20; i = i + 1) {
    System.out.println("Executando: " + i);
  }
}
```
Já que o "for" e o "while" são bem "parecidos", você deve tá se perguntando: quando usar o for e o while? Tudo vai depender de como você está implementando seu código e também o seu gosto. Eu prefiro o "for", porque consigo entender mais facilmente o que está acontecendo. Fica ao seu gosto!

## Controlando loops

Agora que sabemos usar os loops, porque não aprender a controla-los? Podemos dizer quando que o código vai parar ou continuar (passar para outro trecho de código). Para ficar mais fácil de entender, vejamos o exemplo:

```Java
public void main(String[] args) {
  for (int i = 0; i < 100; i++) {
    if (i < 51) {
      System.out.println("Olha até aonde vamos" + i);
      break;
    }
  }
}
```

Olhando o código acima, não existe nada tão diferente. Nosso código vai executar um "for", vai pecorrer a variável até a mesma ter o valor 50. Ao encontrar, nosso código irá parar de executar. Isso só acontece porque adicionamos ao trecho da nossa expressão boolena a palavra chave "break".

Além do "break", temos a palavra chave "continue", que é serve para o ao contrário do "break", fazendo nosso código executar o próximo laço.

```Java
public void main(String[] args) {
  for (int i = 0; i < 100; i++) {
    if (i > 10 && i < 20) {
      continue;
    }
    System.out.println(i);
  }
}
```

Ao executar, alguns números serão imprimidos, não todos. Veja no seu terminal o que acontece com essa condicional.

## Resumo

Nesses dois primeiros posts sobre Introdução ao Java ([leia o primeiro post](http://engenharia.elo7.com.br/introducao-ao-java/)), aprendemos como configurar o Java e como executar nosso código sem necessidade de um IDE. Também descobrimos como que podemos utilizar expressões boolenas para criar fluxos em nosso código, controlando loops e criando condicionais. Agora, acredito que podemos evoluir nossos estudos, começanndo a estudar algo mais real, principalmente o grande princípio do Java: Orientação a Objetos. Preparados!?
