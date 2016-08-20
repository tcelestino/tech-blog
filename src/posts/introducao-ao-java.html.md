---
title: 'Introdução ao Java'
date: 2016-08-19
category: back-end
layout: post
description:
author: tcelestino
tags:
  - java
  - eclipse
---

Entrei para o time de engenharia da Elo7 há dois meses e vou dizer que fiquei "assustado" quando vi que o time de front end mexia muito com código Java. Nunca tive a experiência em desenvolver aplicações em Java, o máximo de conhecimento que tinha foi a experiência que tive na época da faculdade.

Chega de história e vamos ao que interessa!

## Instalando o Java

Para iniciar, vamos precisar verificar se já temos o Java. A grande maioria dos SO's já tem alguma versão do Java instalada. Para verificar se já tem uma versão instalada, execute no terminal:

introducao-ao-java-1.png

![Verificando se o Java já está instalado](../images/introducao-ao-java-1.jpg)

Caso ainda não tenha o Java instalado em sua máquina, leia esse tutorial de como instalar no seu SO.

Após a instalação, já podemos brincar um pouco com o Java.

***Nota***

<small>Se for usuário do macOS(OSX), pode ser que tenha problemas para executar o instalador do Java. Caso tenha esse problema, recomendo ler [esse tutorial](http://osxdaily.com/2015/10/05/disable-rootless-system-integrity-protection-mac-os-x/) (em inglês).</small>

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

O Java é uma linguagem fortemente tipada, ou seja, toda variável precisa ter um tipo especifico, sendo que após seu tipo ser declarado, a variável será até o seu fim do mesmo tipo.

Existem diversos tipos de primitivos, irei falar dos mais básicos que são eles: String, int, float, Long e Boolean.

Para definir uma variável, você precisa apenas dizer qual é o tipo dela. Algo assim:

Se rodar esse escri

### String

Para quem já programa, sabe o que é uma string. No Java, você define uma variável
