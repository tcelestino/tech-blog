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

Desde de quando entrei para o time de engenharia do Elo7, a dois meses atrás, fiquei bem "assustado" quando olhei pela prmeira vez o código um código Java. Nunca tive a experiência de desenvolver aplicações em Java, o máximo de conhecimento que tinha foi a experiência que tive na época da faculdade. Por isso, uma das minhas metas é aprender e entender melhor esse mundo e documentar para todos como o "bicho de sete cabeças" não é tão assustador assim.

## Instalando o Java

Para começar, vamos precisar verificar se já temos o Java instalado na máquina. A grande maioria dos sistemas operacionais, já possuem alguma versão do Java instalada, para saber se realmente tem o Java instalado em sua máquina, abra o "Terminal" e execute o segundo comando:

(entra uma imagem aqui)

A mensagem deve ser igual a exibida na imagem acima. Caso você não tenha instalado, nesse link vai poder encontrar como instalar.

**Nota**

Para usuários macOS(OSX), pode ser preciso desabilitar o recurso de segurança (pesquisar recurso) para poder o instalador do Java ser executado.

Após instalação, podemos criar nossas classes Java.

Mas você deve tá se perguntando se não estou usando alguma IDE. Sim, estou usando o Eclipse, porém para os exemplos desses posts, vamos apenas precisar do Java instalado e o Terminal.

## Entendendo tipos primitivos

O Java é uma linguagem fortemente tipada, ou seja, toda variável precisa ter um tipo especifico, sendo que após seu tipo ser declarado, a variável será até o seu fim do mesmo tipo.

Existem diversos tipos de primitivos, irei falar dos mais básicos que são eles: String, int, float, Long e Boolean.

Para definir uma variável, você precisa apenas dizer qual é o tipo dela. Algo assim:

```Java

public void main(String args[]) {
  String myString = 'Minha Várivel é uma string';
  int myNumber = 10;
  float MyNumberWithDouble = 10.40;
  Long myNumberIsLong = 10000000;
  Boolean isTrue = false;

  System.out.printLn(myString);
  System.out.printLn(myNumber);
  System.out.printLn(MyNumberWithDouble);
  System.out.printLn(myNumberIsLong);
  System.out.printLn(isTrue);
}
```
Se rodar esse escri

### String

Para quem já programa, sabe o que é uma string. No Java, você define uma variável
