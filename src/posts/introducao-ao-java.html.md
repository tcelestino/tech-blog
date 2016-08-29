---
title: 'Introdução ao Java'
date: 2016-08-19
category: back-end
layout: post
description: O primeiro post de uma série sobre como começar a codificar algo em Java. Nesse primeiro post você vai entender como que funciona a execução do Java no computador, além de entender sobre tipos primitivos.
author: tcelestino
tags:
  - java
---

Entrei para o time de front-end do [Elo7](http://elo7.com.br) tem alguns meses e digo que fiquei "assustado" quando vi que o time mexia muito com código Java. Meu susto maior é que minha única experiência com a linguagem foi na época da faculdade, chegando apenas a desenvolver o [iSnake](https://github.com/tcelestino/iSnake). Tirando isso, posso dizer que minha experiência é `null`.

Mas chega de história e vamos ao que interessa!

## Instalando o Java

Antes de começar a escrever algum código, vamos precisar verificar se já temos o Java instalado. Para descobrir se já tem o compilador Java instalado em seu computador, execute o seguinte comando no terminal:

```bash
$ javac -version
```

Você precisa ver uma mensagem como a que aparece na imagem abaixo:

![Verificando se já temos o Java instalado](../images/introducao-ao-java-1.png)

Estou usando a versão 8 do Java, provalvemente você estará usando uma outra versão, que não vai impactar por enquanto nossos primeiros passos. Agora, caso a mensagem não seja parecida com a que tem na imagem acima, recomendo esse [artigo](https://goo.gl/XfZCiB) do pessoal da Caelum que explica como fazer a instalação do Java em diversos sistemas operacionais.

## Nossa primeira classe

Para começarmos a fazer algum código, vamos apenas precisar do terminal e seu editor de texto preferido (Sublime, Atom, Bloco de Notas etc...). Sim, por enquanto não vamos usar nenhuma IDE, assunto que ficará para os futuros posts. Com seu editor de texto aberto, escreva (ou copie) o código abaixo:

```Java
public class HelloWorld {
  public static void main(String[] args) {
    System.out.println("Hello World!");
  }
}
```

Salve o arquivo como "HelloWorld.java". No terminal digite o seguinte comando:

```bash
$ javac HelloWorld.java
```

*Explicando:* o comando `javac` irá compilar seu `arquivo.java`, e criar um arquivo chamado `nomeDaClasse.class`, no nosso caso `HelloWorld.class`.

Depois de compilar nosso arquivo, vamos precisar executar o nosso código compilado. Rode o comando:

```bash
$ java HelloWorld
```

*Explicando:* o comando "java" irá executar o nosso arquivo `HelloWorld.class`.

![Nossa primeira classe: Hello World!](../images/introducao-ao-java-2.png)

*Nota*

*Todos os exemplos de código que serão usados nos posts, estarão disponíveis [nesse repositório](http://github.com/tcelestino/intro-java)*

## Entendendo tipos primitivos

No Java, precisamos sempre definir o tipo das variáveis que não poderá ser modificada em qualquer momento da execução do código. Vou mostrar as mais básicas, sendo elas:

  * String - apenas texto
  * int - número inteiro (Ex.: 5)
  * double - números flutuante (Ex.: 1.80)
  * boolean - verdadeiro ou falso

Vamos colocar na prática como que funciona a tipificação/declaração de variáveis no Java. Crie um arquivo chamado `MyPersonalInfo.java` e adicione o código abaixo:

```Java
public class MyPersonalInfo {
  public static void main(String[] args) {
    String myName = "Tiago Celestino";
    int age = 29;
    double weight = 80.0;
    boolean isBrazilian = true;

    System.out.Println(myName);
    System.out.Println(age);
    System.out.Println(weight);
    System.out.Println(isBrazilian);
  }
}
```

Compile e execute o código (não esqueça do `javac` e `java`) e o resultado no seu terminal deverá ser esse:

![Tipos primitivos no Java](../images/introducao-ao-java-3.png)

Se você bem notou, todas as variáveis estão declaradas com o seu tipo, ou seja, cada uma está especificamente "rotulada" com o tipo de valores que elas poderão suportar.

Agora, se tentarmos adicionar valores que não seja do tipo definido, o que pode acontecer? Vamos alterar nossa classe anterior para ver o acontece.

```Java
public class MyPersonalInfo {
  public static void main(String[] args) {
    String myName = 29;
    int age = 78.9;
    double weight = 29;
    boolean isBrazilian = "Tiago Celestino";

    System.out.Println(myName);
    System.out.Println(age);
    System.out.Println(weight);
    System.out.Println(isBrazilian);
  }
}
```

Viu o que acontece quando tentou compilar o arquivo?

![Exibe erros ao tentar compilar o código Java](../images/introducao-ao-java-4.png)

Isso acontece porque o Java é uma linguagem fortemente tipada, ou seja, toda variável precisa ter um tipo especifico, sendo que após seu tipo ser declarado a variável será até o seu fim do mesmo tipo. Vale lembrar que a tipagem não está restrita apenas a variáveis, mas também aos metódos, mas isso fica para os futuros posts.

Se tiver algo para acrescentar/sugerir, deixe nos comentários e aguardem os próximos posts.

***Fontes***

- [Variáveis primitivas e Controle de fluxo](https://www.caelum.com.br/apostila-java-orientacao-objetos/variaveis-primitivas-e-controle-de-fluxo/) - Caelum
