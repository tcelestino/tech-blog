---
title: 'Introdução ao Java - parte 2'
date: 2016-11-02
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
  int maiorIdade = 30;

  if(menorIdade < 18) {
    System.out.println("Você ainda é menor de idade!");
  } else if (maiorIdade > 18) {
    System.out.println("Agora você é maior de idade.");
  } else {
    System.out.println("Reveja sua idade, parça!");
  }
}
```

Rodando o código, você vai notar duas mensagens na tela. Isso aconteceu porque usamos o "else if", que criou uma condição a ser executada após a primeira condicional. Podemos ter diversas condições secundárias, ou seja, vários casos que precisamos fazer alguma comparação com a mesma variável ou valores com execuções diferentes.

### - while

A palavra "while" no português pode ser traduzida pela a palavra "enquanto". Na expressão booleana, esse é o comportamento que precisamos executar uma operação que em um "período de tempo", ou até chegarmos a uma quantidade de de loops naquela mesma condicional.

Um exemplo básico de como usar o "while".

```Java
public void main(String[] args) {
  int numero = 0;

  while(numero < 18) {
    System.outprintln(numero);
    numero = numero + 1;
  }
}
```

Ao executar o código, a váriavel "numero" receberá novos valores até chegar ao valor que está sendo comparada, no caso 18. Ou seja, enquanto a váriavel como "true", já que ela é menor que 18, o código será executado, havendo a sobrescrita e adicionando sempre o valor atual + 1. A execução do trecho do código só é finalizada quando o valor da váriavel se torna maior que a comparação, fazendo que a mesma tenha o valor "false" em relação ao valor comparado. Para deixarmos o código mais interessante, vamos fazer uma combinação de código com as expressões anteriores.

```Java
public void main(String[] args) {
  int menorIdade = 15;

  if(menorIdade < 18) {
    System.out.println("Você ainda é menor de idade!");
    while(menorIdade < 18) {
      menorIdade = menorIdade + 1;
    }
  } else if (menorIdade == 18) {
    System.out.println("Agora você é maior de idade.");
  } else {
    System.out.println("Reveja sua idade, parça!");
  }
}
```

### - for

Diferente do "while", que precisa de uma condição booleana para ser executado, o "for" serve para controlar a execução de loops em que algum momento da execução possa parar a qualquer momento.

## Operadores lógicos

https://www.caelum.com.br/apostila-java-orientacao-objetos/variaveis-primitivas-e-controle-de-fluxo/#3-9-controlando-loops
