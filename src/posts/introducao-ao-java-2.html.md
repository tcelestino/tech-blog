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

No [primeiro post](http://engenharia.elo7.com.br/introducao-ao-java/) da série de introduação ao Java, mostrei como configurar e executar nossos códigos via Terminal. Dando continuidade a série, vou apresentar o conceito de expressão booleana para controlar o fluxo de funcionamento de lógica do nossos códigos. Sim, é básico, porém essencial para que passamos para os próximos posts, que começará a ser mais "legal", já que vamos começar a lidar com o conceito principal da linguagem, a Programação Orientada à Objetos.

##Lidando com o controle de fluxo

Provavelmente, se você já iniciou algum estudo em qualquer linguagem de programação, acredito que já tenha ouvido falar do "if", "else", ou do "while" e do "for". Basicamente faland são usadas quando queremos criar alguma condicional, ou seja, controlar o fluxo de funcionamento dos nossos códigos (melhorar essa parte).

Para trabalharmos com condicionais, vamos precisar criar uma expressão booleana, que é nada mais, nada menos, que uma expressão que retorna "true" ou "false". Para obter o resultado esperado, podemos usar os seguintes operadores: <, >, <=, >=, ==, !=, entre outros. Podemos encontrar esses operadores em diversas outras linguagens (Java, Ruby, Javascript etc...).

### - if, else, else if

Vamos imaginar que temos um caso de uso:

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

Execute o código (se não lembrar, [tem a cola aqui](http://engenharia.elo7.com.br/introducao-ao-java/)). (adicionar print).

Se explicaramos traduzindo o código acima, teriamos algo assim: se a váriavel "menorIdade" for menor que "18", exiba na tela a mensagem, se não, exiba na tela a outra mensagem. Ou seja, verificamos se o valor da variável é menor que o número que passamos, como o resultado será "true", entramos no nossa primeira condicional. Utilizamos o "else" para quando a expressão booleana retornar "false", com isso podemos tratar os dois casos.

Mas e o "else if"?

Agora vamos imaginar o seguinte cenário

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

Se rodar o código acima, vai notar que os teremos duas mensagens na tela (colocar print screen).

Isso acontece devido ao uso do "else if", que cria uma nova condição a ser executada após o primeiro "if". Podemos ter diversas condições secundárias, ou seja, vários casos que precisamos fazer alguma comparação com a mesma variável ou valor com execuções diferentes.

### - while

Em portugues, a palavra "while" quer dizer "enquanto", esse é o mesmo comportamento que temos quando precisamos fazer uma operação que seja executada a partir de um período de tempo. Resumindo, quando precisamos fazer um "loop" de um trecho de código algumas vezes.

Vamos ver abaixo como podemos usar o "while".

```Java
public void main(String[] args) {
  int numero = 0;

  while(numero < 18) {
    System.outprintln(numero);
    numero = numero + 1;
  }
}
```

O código acima será executado até o valor da variável "numero" ter o valor de "18", ou seja, enquanto o valor da variável (numero) estiver como "true" (já que ela é menor que 18), irá passar e salvar o valor na mesma variável (criando a sobrescrita) e somando mais um valor. A execução do "while" só será finalizada quando o valor da variável ser igual ao número passado na condição, se tornado falsa.

Podemos utilizar o "while", "if", etc... para melhorarmos nosso controle. Vejamos melhorar o nosso penúltimo código, acrescentando o "while".

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

## Operadores lógicos
