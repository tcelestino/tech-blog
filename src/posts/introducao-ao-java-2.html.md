---
title: Introdução ao Java - parte 2
date: 2017-01-16
category: back-end
layout: post
description: Entenda como controlar o fluxo de funcionamento do seu código usando expressão booleana. Entenda o funcionamento do "if", "else", "for", "while" e de alguns operadores.
author: tcelestino
tags:
  - java básico
  - controle de fluxo
  - expressões booleanas
---

No [primeiro post da série de introdução ao Java](http://engenharia.elo7.com.br/introducao-ao-java/), mostrei como configurar e executar nosso código Java. Continuando, nesse post vou apresentar alguns conceitos que serão necessários para lidarmos com o controle de fluxo na lógica de funcionamento dos nossos códigos. Sim, vamos continuar no básico, porém essencial para os próximos posts. Mas vamos deixar de conversa e partir para o que mais interessa: código!

## Lidando com o controle de fluxo

Se você já iniciou algum estudo em qualquer linguagem de programação, acredito que já tenha ouvido falar de "if", "else", "while" e "for". Essas palavras são usadas quando queremos criar alguma condicional, ou seja, controlar o fluxo de funcionamento dos nossos códigos.

Para trabalharmos com condicionais, vamos precisar criar uma expressão booleana, que é uma expressão que retorna "true" (verdadeiro) ou "false" (falso). Para obter o resultado esperado, podemos usar os seguintes operadores: `<` (menor que), `>` (maior que), `<=` (menor ou igual a que), `>=` (maior ou igual a que), `==` (igual a), `!=` (diferente de), entre outros. Basicamente, podemos encontrar esses operadores em diversas outras linguagens como PHP, Ruby, Javascript entre outras.

### - if, else, else if

Vamos imaginar o seguinte caso: apenas maiores de idades podem visualizar a mensagem de texto.

```Java
public static void main(String[] args) {
  int menorIdade = 15;

  if(menorIdade < 18) {
    System.out.println("Você ainda é menor de idade!");
  } else {
    System.out.println("Agora você é maior de idade.");
  }
}
```

Analisando o código acima, podemos notar que existe uma expressão booleana, na qual verificamos se o valor da nossa variável `menorIdade` tem o valor menor que o número 18. Para executar o código acima, [tem a cola aqui](http://engenharia.elo7.com.br/introducao-ao-java/). Agora, se alteramos o valor da variável para um valor acima de 18, o que acontece? Execute o código e veja.

Para deixarmos mais interessante nosso código, vamos adicionar mais uma expressão booleana. Com isso, vamos verificar duas situações:

1. se valor da variável `menorIdade` é menor que 18;
2. se o valor da variável `menorIdade` é exatamente igual a 18.

```Java
public static void main(String[] args) {
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

Se alteramos o valor da variável `menorIdade` para 18, a condicional entrará no `else if` e se alteramos o valor para maior que 18?

### - while

A palavra "***while***" no português pode ser traduzida pela palavra "enquanto". Na expressão booleana, podemos usar o `while` quando precisamos executar uma operação até que nossa expressão booleana se torne verdadeira. Para ficar mais claro, vamos ao exemplo básico de como utilizá-lo.

```Java
public static void main(String[] args) {
  int numero = 0;

  while(numero < 20) {
    System.out.println(numero);
    numero = numero + 1;
  }
}
```

A variável `numero` receberá novos valores até chegar ao valor ao qual está sendo comparada. Ou seja, enquanto a condição booleana for verdadeira (`true`), o código será executado, havendo a sobrescrita do valor anterior da variável `numero` somando o valor atual da variável mais 1. A execução do trecho do código entre as chaves do `while` só é finalizada quando o valor da variável chegar a exatamente 20. Vamos melhorar nosso o código, deixando um pouco mais interessante.

```Java
public static void main(String[] args) {
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

Isso é apenas um exemplo de como podemos fazer uma combinação de várias expressões booleanas para criar lógicas em nossos códigos.

### - for

O `for` tem o mesmo comportamento do `while`, porém podemos executar nossos códigos de maneira mais prática e mais legível. Veja o exemplo:

```Java
public static void main(String[] args) {
  for (int i = 0; i < 20; i = i + 1) {
    System.out.println("Executando: " + i);
  }
}
```
Já que o `for` e o `while` são bem "parecidos", você deve estar se perguntando: quando usar o `for` e o `while`? Tudo vai depender de como você está implementando seu código e também do seu gosto. Eu prefiro o `for` porque consigo entender mais facilmente o que está acontecendo. Fica ao seu gosto!

## Controlando loops

Agora que sabemos usar os loops, por que não aprender a controlá-los? Para ficar mais fácil de entender, vejamos o exemplo:

```Java
public static void main(String[] args) {
  String times[] = {"São Paulo", "Palmeiras", "Vitória", "Ferroviária", "Santos", "XV de Piracicaba"};
  for (int i = 0; i < times.length; i++) {
    if(times[i].equals("Vitória")) {
      System.out.println("Esse é o time do " + times[i]);
      break;
    }
  }
}
```

O código acima irá fazer o loop em nosso array de Strings até encontrar a palavra que estamos buscando, que no caso, "Vitória". Ao encontrar a palavra, o "loop" é finalizado, deixando de percorrer nosso array. Isso é bom para performance, já que não é preciso pecorrer todo o array para fazer a busca de valor. Claro, existem outras formas de fazer essa busca, utilizando programação funcional usando o Java 8. O Diego César escreveu um post bem explicativo sobre [programação funcional com o Java 8](http://engenharia.elo7.com.br/introducao-a-programacao-funcional-com-java8/). Vale a pena dar uma lida.

Além do `break`, temos a palavra chave `continue`. Diferente do `break`, ao usar o `continue` fazemos nosso código parar de executar uma iteração e passar para outro bloco de nosso código. Vejamos o exemplo abaixo.

```Java
public static void main(String[] args) {
  for (int i = 0; i < 100; i++) {
    if (i > 10 && i < 20) {
      continue;
    }
    System.out.println(i);
  }
}
```

Se notar bem os números impressos nos seu terminal, vai notar que nem todos foram exibidos.

## Resumo

Nesses dois primeiros posts sobre Introdução ao Java ([leia o primeiro post](http://engenharia.elo7.com.br/introducao-ao-java/)), aprendemos como configurar o Java e como executar nosso código sem necessidade de uma IDE. Também descobrimos como que podemos utilizar expressões booleanas para criar fluxos em nosso código, controlando loops e criando condicionais. Agora, acredito que podemos evoluir nossos estudos, começando a estudar algo mais real, principalmente o grande princípio do Java: Orientação a Objetos. Preparados!?
