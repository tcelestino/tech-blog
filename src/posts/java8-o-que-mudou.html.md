---
title: 'Java 8: O que mudou?'
date: 2016-10-24
category: back-end
layout: post
description: Disponível desde 2014, o Java 8 ainda deixa muitas dúvidas, principalmente quanto às novidades em relação à sua versão anterior. Nesse post vamos falar sobre as principais novidades do Java8.
author: diegocesar
tags:
  - java
  - java8
  - back-end
---

Disponível desde 2014, o Java 8 ainda deixa muitas dúvidas, principalmente quanto às novidades em relação à sua versão anterior. Nesse post vamos falar sobre as principais novidades do Java8. É importante observar é que o Java 8 foi desenvolvido pensando na retrocompatibilidade, ou seja, aplicações desenvolvidas na versão 7 funcionarão perfeitamente nas versõese mais atuais da linguagem. Esse é um dos pontos fortes do java, que ajudam a garantir o seu sucesso.

Veremos a seguir um pouco sobre as principais novidades implementas no Java 8:

## Lambda expressions
Uma das principais e mais comentadas mudanças do Java 8, são **Lambda Expressions** que trazem um pouco do paradigma da programação funcional para o java. [Segundo a oracle](http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/Lambda-QuickStart/index.html) Lambda é uma forma clara e objetiva de representar um método usando apenas uma expressão. É importante lembrar que Lambda Expressions só funcionarão para **interfaces funcionais**. Interfaces funcionais são aquelas que possuem apenas método um abstrato.

Exemplo:
```java
interface Operator {
	abstract float calc(float number1, float number2);
}

public class Calculator {
	public static void main(String[] args) {
		System.out.println(
			calculate(15, 10, (number1, number2) -> { return number1 + number2; })
		);
	}

	public static float calculate(float number1, float number2, Operator operator) {
		return operator.calc(number1, number2);
	}
}
```

Resultado: `25.0`

## Stream
Stream, no java 8, é uma abstração que permite processar dados de coleções de forma declarativa, usando Lambda Expressions. Os passos para fazer uso do stream são:

1. Obter o stream a partir de uma Collection
2. Adicionar uma ou mais operações no pipeline como filtros, ordenações, etc.
3. Invocar o método collect, este é responsável por processar o pipeline e retornar o resultado no formato solicitado

Veja algumas das operações que você pode executar em um Stream:

### filter

Filtra strings de acordo com a regra passada como parâmetro. Neste caso, filtra todas as strings não vazias.

```java
public void removeEmptyStrings() {
	List<String> strings = Arrays.asList("abc", "", "bc", "abcd", "", "xyz", "foo");
	strings = strings.stream().filter(var -> !var.isEmpty()).collect(Collectors.toList());
}
```

Resultado: `[abc, bc, abcd, xyz, foo]`

### sorted

Ordena os itens da Collection:

```java
public void sortListAlphabetically() {
	List<String> strings = Arrays.asList("z", "x", "a", "c", "b", "y");
	strings = strings.stream().sorted().collect(Collectors.toList());
}
```

Resultado: `[a, b, c, x, y, z]`


Também é possível ordenar utilizando regras diferentes da natural:

```java
public void sortNumbersReversed() {
	List<Integer> numbers = Arrays.asList(3, 5, 1, 4, 2);
	numbers = numbers.stream().sorted((num1, num2) -> num2 - num1).collect(Collectors.toList());
}
```

Resultado: `[5, 4, 3, 2, 1]`

### map

O map aceita uma função como argumento que pode transformar cada um dos itens em um novo elemento

```java
public void countStringCharacters() {
	List<String> strings = Arrays.asList("one", "two", "three", "four");
	List<Integer> totals = strings.stream().map(str -> str.length()).collect(Collectors.toList());
}
```

Resultado: `[3, 3, 5, 4]`

### reduce

O objetivo do reduce, como o nome sugere, é reduzir o número de itens de uma Collection, para isso o reduce receber um argumento [opcional] que será utilizado como valor inicial do segundo argumento, em que passamos uma função que recebe dois parâmetros e trata os dados da forma desejada de modo a reduzi-los.

Exemplo: Retornar a soma dos números pares de uma lista:

```java
public void sumEvenNumbers() {
	List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6);
	Integer result = numbers.stream().reduce(0, (num1, num2) -> (num2 % 2) == 0 ? num1 + num2 : num1);
}
```

Resultado: `12`

### distinct

O distinct devolve uma lista sem nenhuma entrada duplicada.

```java
public void distinctElements() {
	List<Integer> numbers = Arrays.asList(1, 1, 2, 2, 3, 3, 4, 5);
	numbers = numbers.stream().distinct().collect(Collectors.toList());
}
```

Resultado: `[1, 2, 3, 4, 5]`

## Parallel Stream
O resultado final do Parallel Stream é o mesmo do Stream, a diferença entre eles é que neste caso os dados são processados de forma paralela, em várias threads, diferente do Stream que é serial. O processamento paralelo por si só não garante melhora de performance, exceto em casos onde exista um grande volume de dados ou múltiplos cores de processamento.

## Default Methods
O Java 8 permite a implementação de métodos padrões em interfaces utilizando a palavra chave **default**.

```java
interface Vehicle {
	default void turnOn() {
		System.out.println("The vehicle is turned on!");
	}
}

class Car implements Vehicle { }

public class DefaultTest {
	public static void main (String[] args) {
		Car myCar = new Car();
		myCar.turnOn();
	}
}
```

Resultado: `The vehicle is turned on`


## Optionals
Optional é um `Wrapper` ou `Container` que determina a existência ou não de um valor. Esta classe contém métodos para verificar se um valor está presente ou não e recuperar o seu valor. Os métodos mais comuns são: **of**, **isPresent** e **get**.

```java
	// Cria um Optional a partir do número 5
	Optional<Integer> myOptional = Optional.of(5);

	// Verifica se existe um valor definido em myOptional
	if (myOptional.isPresent()) {
		// Recupera o valor de myOptional e o exibe
		System.out.println(myOptional.get());
	}
```

Resultado: 5
