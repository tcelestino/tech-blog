---
title: 'Introdução ao Java'
date: 2016-08-19
category: back-end
layout: post
description:
author: tcelestino
tags:
  - java
---

Entrei para o time de front-end da [Elo7](http://elo7.com.br) tem alguns meses e digo que fiquei "assustado" quando vi que o time mexia muito com código Java. Meu susto maior é que minha única experiência com a linguagem foi na época da faculdade, chegando apenas a desenvolver o [iSnake](https://github.com/tcelestino/iSnake). Tirando isso, posso dizer que minha experiência é null.

Mas chega de história e vamos ao que interessa!

## Instalando o Java

Antes de começar a escrever algum código, precisamos verificar se já temos o Java instalado. A grande maioria dos sistemas operacionais (SO's) já vem com alguma versão do Java instalada, mas para ter certeza abra o terminal e execute o comando:

```bash
$ javac -version
```

Mas para frente vamos ver para que serve o `javac`.

![Verificando se o Java já está instalado](../images/introducao-ao-java-1.jpg)

*Estou usando o Java 8, provavelmente terá uma outra versão instalada*

Caso a mensagem não seja a informada no console do terminal, leia esse [artigo](https://goo.gl/XfZCiB) do pessoal da Caelum que explica muito bem como instalar o Java em diversos SO's

Após a instalação, podemos começar a iniciar o básico..

***Nota***

*Se for usuário do El Capitan(OSX), pode ser que tenha problemas para executar o instalador do Java. Caso o instalador não esteja sendo executado, leia [esse tutorial](http://osxdaily.com/2015/10/05/disable-rootless-system-integrity-protection-mac-os-x/) (em inglês).*

## Nosso primeira classe

Abra seu editor de texto preferido. Sim, por enquanto não vamos usar nenhuma IDE, nos próximos posts pretendo abordar mais sobre a IDE que usamos aqui na Elo7, e vamos criar a nossa primeira classe.

***Nota***

*Todos os exemplos de código que serão usados na série, estará disponivel [nesse repositório](http://github.com/tcelestino/intro-java.git)*

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

O comando acima, irá compilar seu código, criando o arquivo `MyFirstClass.class`. Após a compilação do arquivo, execute:

```bash
$ javac MyFirstClass
```

Esse comando irá executar o código compilado anteriormente, mostrando a mensagem no console do terminal.

(add image)

## Entendendo tipos primitivos

Existem diversos tipos de primitivos, irei falar das mais básicas, que são:

  * String
  * int
  * double
  * boolean

Crie agora criar um arquivo chamado `MyTypes.class` e vamos adicionar o código abaixo:

```Java
class MyFirstClass {
  public static void main(String[] args) {
    String myString = "Introdução ao Java"; //apenas texto
    int postStep = 1; //numeros inteiros
    doubl numberLine = 10.4; //numeros como double
    boolean hasEmoji = false; //verdadeiro ou falso.

    System.out.Println(myString);
    System.out.Println(postStep);
    System.out.Println(numberLine);
    System.out.Println(hasEmoji);
  }
}
```

Faça a compilação do arquivo e execute-o.

(add image)

Se você notou, todas as variáveis estão especificamente tipadas, sendo mais direito, digo quais serão os tipos de valores que cada uma delas poderá suportar. E se tentarmos adicionar valores que não seja do tipo definido, o que pode acontecer?

Vejamos o código abaixo:

```Java
class MyFirstClass {
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

Notou o que aconteceu quando tentou compilar seu arquivo? Isso acontece porque o Java é uma linguagem fortemente tipado, ou seja, toda variável precisa ter um tipo especifico, sendo que após seu tipo ser declarado a variável será até o seu fim do mesmo tipo.

Se tiver algo para acrescentar ou sugerir, deixe nos comentários e aguardem os próximos posts.
