---
title: 'Introdução ao Java'
date: 2016-08-19
category: back-end
layout: post
description:
author: tcelestino
tags:
  - java
  - tipos primitivos
---

Entrei para o time de engenharia da Elo7 há dois meses e vou dizer que fiquei "assustado" quando vi que o time de front end mexia muito com código Java. Por falta de experência em desenvolver aplicações em Java, tirando na época da faculdade que até cheguei a desenvolver o [iSnake](https://github.com/tcelestino/iSnake), minha experiência com Java era quase nula.

Mas chega de história e vamos ao que interessa!

## Instalando o Java

Para iniciar, precisamos verificar se já temos o Java instalado. A grande maioria dos sistemas operacionais (SO's) já vem com alguma versão do Java instalada, mas para ter certeza execute no terminal:

```bash
$ javac -version
```

A imagem abaixo é o que deve aparecer para você

![Verificando se o Java já está instalado](../images/introducao-ao-java-1.jpg)

*Estou usando o Java 8, provavelmente terá uma outra versão instalada*

Caso a mensagem não seja a informada no console do terminal, leia esse [artigo](https://goo.gl/XfZCiB) do pessoal da Caelum que explica muito bem de como instalar o Java nos diversos SO's

Após a instalação, já podemos brincar um pouco com o Java.

***Nota***

*Se for usuário do El Capitan(OSX), pode ser que tenha problemas para executar o instalador do Java. Caso o instalador não esteja sendo executado, leia [esse tutorial](http://osxdaily.com/2015/10/05/disable-rootless-system-integrity-protection-mac-os-x/) (em inglês).*

## Nosso primeira classe

Abra seu editor de texto preferido. Sim, por enquanto não vamos usar nenhuma IDE, nos próximos posts pretendo abordar mais sobre a IDE que usamos aqui na Elo7.

Para começar, vamos criar a nossa classe com o velho e famoso "Hello World".

```Java
class MyFirstClass {
  public static void main(String[] args) {
    System.out.println("Hello World!");
  }
}

```

Salve o arquivo como MyFirstClass.java e no terminal, execute o seguinte comando:

```bash
$ java MyFirstClass.java
```

O comando acima, irá compilar seu código, criando o arquivo MyFirstClass.class. Após compilar seu arquivo, execute:

```bash
$ javac MyFirstClass
```

Esse comando irá executar o código compilado anteriormente, mostrando a mensagem no console do terminal.

(add image)

## Entendendo tipos primitivos



Existem diversos tipos de primitivos, farei um uso das mais básicas, que são:

  * String
  * int
  * float
  * Boolean

Abra o arquivo MyFirstClass.java e atualize o código adicionando as variáveis:

```Java
class HelloWorld {
  public static void main(String[] args) {
    String myString = "Introdução ao Java"; //apenas texto
    int postStep = 1; //numeros inteiros
    float numberLine = 10.4; //numeros como double
    Boolean hasEmoji = true; //verdadeiro ou falso.

    System.out.Println(myString);
    System.out.Println(postStep);
    System.out.Println(numberLine);
    System.out.Println(hasEmoji);
  }
}
```

Faça a compilação do arquivo e execute-o.

(add image)

Se notar, todas as variáveis estão especificamente tipadas, sendo mais direito, digo quais serão os tipos de valores de cada uma delas.

E se tentarmos adicionar valores que não seja do tipo definido, o que pode acontecer? Vejamos o código abaixo:

```Java
class HelloWorld {
  public static void main(String[] args) {
    String myString = true;
    int postStep = 1.3;
    float numberLine = 10;
    Boolean hasEmoji = "true";

    System.out.Println(myString);
    System.out.Println(postStep);
    System.out.Println(numberLine);
    System.out.Println(hasEmoji);
  }
}
```

O que aconteceu? Sim, seu código não nem compilado. Isso acontece porque o Java é fortemente tipado, ou seja, toda variável precisa ter um tipo especifico, sendo que após seu tipo ser declarado a variável será até o seu fim do mesmo tipo.

Existem outros tipos (Long, Double, etc...), mas deixamos para falar delas nos próximos posts.
