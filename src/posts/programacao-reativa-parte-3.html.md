---
date: 2018-05-21
category: back-end
tags:
  - java
  - programacao-reativa
authors: [ljtfreitas]
layout: post
title: Programação Reativa - Parte 3
description: Terceiro capítulo da Jornada Reativa! Falaremos agora sobre coisas interessantes: código assíncrono, execução em paralelo e backpressure!
---
Nos dois [posts](/programacao-reativa) [anteriores](/programacao-reativa-parte-2) sobre Programação Reativa, estudamos os fundamentos desse paradigma e vimos muitos exemplos de código usando o [RxJava](https://github.com/ReactiveX/RxJava). Nesse capítulo, vamos nos focar na abstração sobre a **execução assícrona e parelela** que os frameworks Rx fornecem, e especialmente em um conceito que é um dos pilares do modelo reativo: a **contrapressão ou backpressure**.

> *“A dúvida é o princípio da sabedoria. (Aristóteles)”*

## Processamento assíncrono

Um dos assuntos que mais causam discussão a respeito da programação reativa é questão do processamento assíncrono. Com efeito, as idéias sobre as quais o paradigma reativo é fundamentado favorecem a execução concorrente do código, assim como ocorre nas linguagens funcionais: código declarativo, funções livres de efeitos colaterais, propagação de estado e imutabilidade. Todos os operadores reativos que vimos no [post anterior](/programacao-reativa-parte-2) funcionam dessa forma, de modo que qualquer operação **poderia** ser executada de maneira assíncrona, ou mesmo em paralelo, sem nenhum problema. Mas isso deve ser feito **explicitamente**; colocando em outras palavras: a não ser que você diga o contrário, todas as operações irão ocorrer **em uma única thread**, por uma questão de economia de recursos do *hardware*. O código abaixo demonstra isso.

```java
Observable.create(emitter -> {

	emitter.onNext("one");
	emitter.onNext("two");
	emitter.onComplete();

}).subscribe(
		value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId()),
		Throwable::printStackTrace,
		() -> System.out.println("Receive OnCompleted on Thread " + Thread.currentThread().getId()));

/*
output:

Receive one on Thread 1
Receive two on Thread 1
Receive OnCompleted on Thread 1
*/
```

O código acima demonstra claramente que não há nenhuma outra *thread* envolvida; todas as coisas aconteceram na *thread* corrente do programa, e também seria o caso se tivéssemos realizado mais operações sobre o `Observable` (*map*, *flatMap*, etc). E se os eventos fossem emitidos em uma *thread* diferente? Vejamos o exemplo abaixo, usando um `Subject`:

```java
BehaviorSubject<Integer> subject = BehaviorSubject.create();

AtomicInteger counter = new AtomicInteger(0); //efeito colateral; apenas para testes! :)

Runnable runnable = () -> {
	System.out.println("Emitting value " + counter.incrementAndGet() + " on Thread " + Thread.currentThread().getId()); //thread em que o onNext está sendo emitido
	subject.onNext(counter.get());
};

subject.subscribe(value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId())); //thread em que o subscribe está sendo executado

System.out.println("Current thread: " + Thread.currentThread().getId()); //thread atual do programa

// inicializa duas novas threads que farão a emissão dos eventos
new Thread(runnable).start();
new Thread(runnable).start();

Thread.sleep(1000);

/*
output:

Current thread: 1
Emitting value 1 on Thread 12
Emitting value 2 on Thread 13
Receive 2 on Thread 12
Receive 2 on Thread 13
*/
```

O detalhe importante a ser percebido no exemplo acima é que **a emissão dos eventos e o subscribe ocorrem sempre na mesma thread, sincronamente**. Esse é o comportamento padrão dos frameworks Rx, e tambem é o caso do RxJava.

Mas e se quisermos publicar e processar eventos em *threads* diferentes?

### (Um pouquinho de) Schedulers

Um dos princípios de design dos frameworks Rx é fornecer uma fundação simples e segura para programação assíncrona e concorrente. O principal objeto que abstrai esses conceitos é o [Scheduler](http://reactivex.io/RxJava/javadoc/io/reactivex/Scheduler.html). Naturalmente, a implementação depende de detalhes específicos de cada linguagem, e no caso do RxJava, o comportamento é implementado com o *Executor Framework*, a API padrão de concorrência do Java.

Para criamos uma instância de um `Scheduler`, podemos utilizar os métodos de fábrica da classe [Schedulers](http://reactivex.io/RxJava/javadoc/io/reactivex/schedulers/Schedulers.html):

```java
// Scheduler indicado para tarefas computacionais comuns
Scheduler computation = Schedulers.computation();

// Scheduler indicado para tarefas envolvendo IO
Scheduler io = Schedulers.io();

// Scheduler que criará uma nova thread para cada unidade de trabalho requerida
Scheduler newThread = Schedulers.newThread();

// Scheduler que irá empilhar as unidades de trabalho em uma fila, consumindo-as no formato FIFO usando as threads do poll
Scheduler trampoline = Schedulers.trampoline();

// Scheduler que irá executar cada unidade de trabalho em uma única thread. Indicada para trabalhos que requerem computação sequencial
Scheduler single = Schedulers.single();

// Scheduler criado a partir de um Executor do Java fornecido por você (o código abaixo cria um ExecutorService usando a classe Executors, da API padrão do Java)
Scheduler customized = Schedulers.from(Executors.newFixedThreadPool(100));
```

Um dos pontos fortes dos frameworks reativos é fornecer um nível de abstração simples para o processamento assíncrono, que historicamente é uma grande dor de cabeça para os programadores (incluindo especialmente a linguagem Java). Com efeito, trabalhar diretamente com *threads* não é algo trivial, envolvendo diversos detalhes complicados, que fatalmente serão refletidos em códigos igualmente complicados. O papel do `Scheduler` é simplificar essa complexidade, de tal maneira que não precisamos nos preocupar com os detalhes de baixo nível acerca da manipulação de *threads*, e sim apenas nos concentramos nas operações que desejamos realizar com nosso `stream`, uma vez escolhido o `Scheduler` mais adequado à tarefa.

Como os métodos acima, podemos criar um `Scheduler` para diversos casos de uso. Mas e agora, o que fazemos com ele?

### subscribeOn e observeOn

Os métodos [subscribeOn](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#subscribeOn-io.reactivex.Scheduler-) e [observeOn](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#observeOn-io.reactivex.Scheduler-) permitem controlar qual será o comportamento, em relação às *threads*, da emissão e subscrição de eventos. Ambos recebem um `Scheduler` como argumento.

#### subscribeOn

![subscribeOn](/images/programacao-reativa-parte-3-1.png)

O método [subscribeOn](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#subscribeOn-io.reactivex.Scheduler-) permite controlar em qual `Scheduler` a **emissão dos eventos** será realizada. Revisitando o exemplo anterior:

```java
Observable.create(emitter -> {

	System.out.println("Emitting on Thread " + Thread.currentThread().getId()); //thread em que o onNext está sendo emitido

	emitter.onNext("one");
	emitter.onNext("two");
	emitter.onComplete();

})
.subscribeOn(Schedulers.newThread()) // aqui estamos dizendo o Scheduler em que a emissão de eventos deve ocorrer
.subscribe(
		value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId()), //thread em que o subscribe está sendo executado
		Throwable::printStackTrace,
		() -> System.out.println("Receive OnCompleted on Thread " + Thread.currentThread().getId()));


System.out.println("Current thread: " + Thread.currentThread().getId()); //thread atual do programa

Thread.sleep(1000);

/*
output:

Current thread: 1
Emitting on Thread 11
Receive one on Thread 11
Receive two on Thread 11
Receive OnCompleted on Thread 11
*/
```

No exemplo acima, utilizamos o método [create](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#create-io.reactivex.ObservableOnSubscribe-) (já visto no [post anterior](/programacao-reativa-parte-2)) para criação do `Observable`, mas o comportamento do `subscribeOn` é o mesmo para qualquer outro método de criação. Vejamos o exemplo abaixo, usando o método de fábrica [just](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#just-T-):

```java
Observable.just("one", "two")
	.subscribeOn(Schedulers.newThread())
	.subscribe(
		value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId()),
		Throwable::printStackTrace,
		() -> System.out.println("Receive OnCompleted on Thread " + Thread.currentThread().getId()));


System.out.println("Current thread: " + Thread.currentThread().getId());

Thread.sleep(1000);

/*
output:

Current thread: 1
Receive one on Thread 11
Receive two on Thread 11
Receive OnCompleted on Thread 11
*/
```

Alguns métodos de criação do `Observable`, de natureza assíncrona, já operam naturalmente sobre *threads* diferentes da execução do programa; por exemplo, o método [interval](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#interval-long-java.util.concurrent.TimeUnit-).

```java
Observable.interval(1000, TimeUnit.MILLISECONDS)
	.subscribe(value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId()));

System.out.println("Current thread: " + Thread.currentThread().getId());

Thread.sleep(3000);

/*
output:

Current thread: 1
Receive 0 on Thread 11
Receive 1 on Thread 11
Receive 2 on Thread 11
*/
```

Usando o `subscribeOn` em conjunto com esses métodos, também é possível controlar o `Scheduler` utilizado; outra maneira é usar uma sobrecarga que permite customizar o `Scheduler` por parâmetro (de maneira consistente, outros métodos como [intervalRange](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#intervalRange-long-long-long-long-java.util.concurrent.TimeUnit-) também são sobrecarregados da mesma maneira):

```java
Observable.interval(1000, TimeUnit.MILLISECONDS, Schedulers.newThread())
	.subscribe(value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId()));

System.out.println("Current thread: " + Thread.currentThread().getId());

Thread.sleep(3000);

/*
output:

Current thread: 1
Receive 0 on Thread 11
Receive 1 on Thread 11
Receive 2 on Thread 11
*/
```

Em todos os exemplos acima, podemos perceber que os *subscribers* foram executados **na mesma thread** em que os eventos foram publicados. Também podemos customizar esse comportamento usando o `observeOn`.

#### observeOn

![observeOn](/images/programacao-reativa-parte-3-2.png)

O método [observeOn](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#observeOn-io.reactivex.Scheduler-) se refere à outra ponta do *pipeline* reativo, nos permitindo controlar em qual `Scheduler` o **consumo dos eventos** será realizado. O mesmo exemplo anterior:

```java
Observable.create(emitter -> {

	System.out.println("Emitting on Thread " + Thread.currentThread().getId()); //thread em que o onNext está sendo emitido

	emitter.onNext("one");
	emitter.onNext("two");
	emitter.onComplete();

})
.observeOn(Schedulers.newThread()) // aqui estamos dizendo o Scheduler em que o consumo de eventos deve ocorrer
.subscribe(
		value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId()), //thread em que o subscribe está sendo executado
		Throwable::printStackTrace,
		() -> System.out.println("Receive OnCompleted on Thread " + Thread.currentThread().getId()));


System.out.println("Current thread: " + Thread.currentThread().getId()); //thread atual do programa

Thread.sleep(1000);

/*
output:

Emitting on Thread 1
Current thread: 1
Receive one on Thread 11
Receive two on Thread 11
Receive OnCompleted on Thread 11
*/
```

No exemplo acima, os eventos foram emitidos na *thread* atual do programa, mas o consumo dos eventos, não. O exemplo com o método `just` demonstra o mesmo comportamento:

```java
Observable.just("one", "two")
	.observeOn(Schedulers.newThread())
	.subscribe(
		value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId()),
		Throwable::printStackTrace,
		() -> System.out.println("Receive OnCompleted on Thread " + Thread.currentThread().getId()));


System.out.println("Current thread: " + Thread.currentThread().getId());

Thread.sleep(1000);

/*
output:

Current thread: 1
Receive one on Thread 11
Receive two on Thread 11
Receive OnCompleted on Thread 11
*/
```

Os operadores também serão executados utilizando esse `Scheduler`:

```java
Observable.create(emitter -> {

	System.out.println("Emitting on Thread " + Thread.currentThread().getId()); //thread em que o onNext está sendo emitido

	emitter.onNext("one");
	emitter.onNext("two");
	emitter.onComplete();

})
.observeOn(Schedulers.newThread()) // aqui estamos dizendo o Scheduler em que o consumo de eventos deve ocorrer
.map(value -> {

	System.out.println("Map, on thread " + Thread.currentThread().getId()); //thread em que o operador map está sendo executado
	return value.toString().toUpperCase();
})
.subscribe(
		value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId()), //thread em que o subscribe está sendo executado
		Throwable::printStackTrace,
		() -> System.out.println("Receive OnCompleted on Thread " + Thread.currentThread().getId()));

System.out.println("Current thread: " + Thread.currentThread().getId()); //thread atual do programa

Thread.sleep(1000);

/*
output:

Emitting on Thread 1
Current thread: 1
Map, on thread 11
Receive ONE on Thread 11
Map, on thread 11
Receive TWO on Thread 11
Receive OnCompleted on Thread 11
*/
```

No [post anterior](/programacao-reativa-parte-2), insisti bastante na característica da **imutabilidade** dos `streams`; isso também é válido para o [subscribeOn] e [observeOn]. No exemplo anterior, o `map` devolve um novo `Observable` que parametrizamos com um `Scheduler` específico; poderíamos modificar também esse novo `Observable` para utilizar um outro `Scheduler`, encadeando operações em *threads* diferentes:

```java
Observable.create(emitter -> {

	System.out.println("Emitting on Thread " + Thread.currentThread().getId()); //thread em que o onNext está sendo emitido

	emitter.onNext("one");
	emitter.onNext("two");
	emitter.onComplete();

})
.observeOn(Schedulers.newThread())
.map(value -> {

	System.out.println("First map, on thread " + Thread.currentThread().getId()); //thread em que o operador map está sendo executado
	return "Hello, " + value;

})
.observeOn(Schedulers.newThread()) // aqui estamos modificando o Scheduler do novo Observable
.map(value -> {

	System.out.println("Second map, on thread " + Thread.currentThread().getId()); //thread em que o operador map está sendo executado
	return value.toString().toUpperCase();

})
.observeOn(Schedulers.newThread()) // novamente, estamos modificando o Scheduler onde os dados serão observados
.subscribe(
		value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId()), //thread em que o subscribe está sendo executado
		Throwable::printStackTrace,
		() -> System.out.println("Receive OnCompleted on Thread " + Thread.currentThread().getId()));

System.out.println("Current thread: " + Thread.currentThread().getId()); //thread atual do programa

Thread.sleep(1000);

/*
output:

Emitting on Thread 1
Current thread: 1
First map, on thread 11
First map, on thread 11
Second map, on thread 12
Second map, on thread 12
Receive HELLO, ONE on Thread 13
Receive HELLO, TWO on Thread 13
Receive OnCompleted on Thread 13
*/
```

Naturalmente, podemos combinar o `subscribeOn` e `observeOn` em um mesmo *pipeline*:

```java
Observable.create(emitter -> {

	System.out.println("Emitting on Thread " + Thread.currentThread().getId()); //thread em que o onNext está sendo emitido

	emitter.onNext("one");
	emitter.onNext("two");
	emitter.onComplete();

})
.subscribeOn(Schedulers.newThread())
.observeOn(Schedulers.newThread())
.map(value -> {

	System.out.println("Map, on thread " + Thread.currentThread().getId()); //thread em que o operador map está sendo executado
	return "Hello, " + value;

})
.subscribe(
		value -> System.out.println("Receive " + value + " on Thread " + Thread.currentThread().getId()), //thread em que o subscribe está sendo executado
		Throwable::printStackTrace,
		() -> System.out.println("Receive OnCompleted on Thread " + Thread.currentThread().getId()));

System.out.println("Current thread: " + Thread.currentThread().getId()); //thread atual do programa

Thread.sleep(1000);

/*
output:

Current thread: 1
Emitting on Thread 11
Map, on thread 12
Receive Hello, one on Thread 12
Map, on thread 12
Receive Hello, two on Thread 12
Receive OnCompleted on Thread 12
*/
```

Com o `Scheduler` e o auxílio dos métodos `subscribeOn` e `observeOn`, é quase trivial implementarmos processamentos assíncronos e comunicação entre diferentes *threads*. Usando a API "pura" do Java, esse código seria extremamente difícil de ser escrito, além de vulnerável a muitos e complicados erros.

## Processamento paralelo

Nos exemplos acima, introduzimos um comportamento assíncrono ao nosso código; conseguimos emitir e processar eventos em *threads* diferentes do segmento em que o programa está sendo executado. Mas ainda não introduzimos **paralelismo** ao nosso programa.

Como vimos até aqui, o conceito essencial de um `stream` é **uma sequência de eventos ordenados no tempo**; isso significa que, mesmo que nosso código processe eventos em uma *thread* diferente, ainda assim isso ocorrerá **na ordem em que os eventos forem emitidos**. Esse é o comportamento correto e esperado ao lidarmos com um `stream`, mas nem sempre será o desejado; no mais das vezes, processar os eventos em ordem faz sentido para o programa, e outras vezes, não.

Imaginemos um cenário em que os dados emitidos pelo `stream` são identificadores de, por exemplo, um usuário no modelo da nossa aplicação, e para cada identificador emitido queremos obter uma instância de um objeto que represente esse usuário:

```java
Observable.fromCallable(UUID::randomUUID) //gera um UUID randomico
	.repeat() //apenas para exemplo: esse operador re-emite os eventos do Observable original em sequência, indefinidamente
	.take(10) // obtêm os 10 primeiros elementos
	.subscribeOn(Schedulers.newThread()) // muda o Scheduler de emissão dos eventos
	.map(id -> findById(id)) // transforma cada uuid em um User
	.subscribe(user -> //implementa alguma logica com o User);
```

O método `findById(UUID id)` poderia ser algo como:

```java
private User findById(UUID id) {
	// obtêm o User de alguma forma, usando o id: consulta ao banco de dados, API externa, etc
	// o que nos importa aqui é que será uma operação bloqueante e lenta :(
	return null;
}
```

Com o `subscribeOn` (e o `observeOn`, onde fizer sentido) nós mudamos o contexto da *thread* de execução, mas ainda não introduzimos um processamento paralelo de fato; a operação do nosso *pipeline* continua bloqueante, apenas estamos bloqueando outra *thread*. Uma possibilidade para evitarmos isso poderia ser utilizar o [flatMap](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#flatMap-io.reactivex.functions.Function-), gerando um novo `Observable` para cada elemento de maneira *lazy*:

```java
Observable.fromCallable(UUID::randomUUID)
	.repeat()
	.take(10)
	.subscribeOn(Schedulers.newThread())
	.flatMap(id -> Observable.fromCallable(() -> findById(id))) // transforma cada uuid em um Observable que emite um User
	.subscribe(user -> //implementa alguma logica com o User);
```

Tecnicamente, essa poderia ser uma boa solução. O operador [flatMap] transforma cada elemento em um novo `Observable`, se subscrevendo a todos eles para capturar os valores emitidos (que serão reemitidos no novo `Observable`). Ainda assim, a criação do `Observable` através do método `fromCallable` não é assíncrona, e continuamos bloqueando a *thread* sobre a qual o `flatMap` está sendo executado; podemos contornar isso, modificando o `Scheduler` da emissão de eventos para cada novo `Observable` gerado:

```java
Observable.fromCallable(UUID::randomUUID)
	.repeat()
	.take(10)
	.subscribeOn(Schedulers.newThread())
	.flatMap(id ->
		Observable.fromCallable(() -> findById(id))
			.subscribeOn(Schedulers.io()))
	.subscribe(user -> //implementa alguma logica com o User);
```

Conseguimos! Porém...essa é uma abordagem que funciona, mas parece problemática e sujeita a erros; os detalhes a respeito da execução assíncrona do *pipeline* estão tomando um espaço desproporcional no nosso código, obscurecendo a lógica de transformação e operação dos dados.

Como dito antes, em um caso de uso como esse, a ordem dos valores emitidos não tem muita importância. O que queremos aqui é executarmos as operações (no nosso caso, buscar os usuários pelo seu identificador) **em paralelo**, e depois juntarmos todos os resultados. O código acima pode ser útil, mas não seria mais simples um método equivalente ao [parallel](https://docs.oracle.com/javase/8/docs/api/java/util/stream/BaseStream.html#parallel--), da API de [Stream](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html) do Java?

Naturalmente, o RxJava fornece uma maneira simples de fazermos isso :).

### (Um pouquinho de) Flowable

A versão 2.x do RxJava introduziu um novo objeto chamado [Flowable](http://reactivex.io/RxJava/javadoc/io/reactivex/Flowable.html). Esse objeto é equivalente a um `Observable`, mas vitaminado com esteróides. Ainda vamos falar bastante e carinhosamente do `Flowable` nesse post; por enquanto, vamos apenas estudar como esse objeto pode nos ajudar em relação ao paralelismo.

Para nossa alegria, o `Flowable` possui um método chamado [parallel](http://reactivex.io/RxJava/javadoc/io/reactivex/Flowable.html#parallel--) que, como o nome indica, paraleliza o processsamento do `stream`; esse "modo paralelo" é representado pelo objeto [ParallelFlowable](http://reactivex.io/RxJava/javadoc/io/reactivex/parallel/ParallelFlowable.html) (que é o retorno do método `parallel`). Apenas um conjunto restrito de operadores estão disponíveis nesse objeto (`map`, `flatMap`, `reduce`, `collect`, e alguns outros).

![parallel](/images/programacao-reativa-parte-3-3.png)

```java
ParallelFlowable<UUID> parallel = Flowable.fromCallable(UUID::randomUUID) // Flowable ao invés do Observable
	.repeat()
	.take(10)
	.parallel(); // esse método retorna um ParallelFlowable

parallel
	.runOn(Schedulers.newThread()) // Scheduler em que o processamento paralelo será executado; sem esse método, tudo será feito na thread corrente
	.map(id -> {

		System.out.println("Map, on thread " + Thread.currentThread().getId()); //thread em que o operador map está sendo executado
		return findById(id);

	})
	.sequential() // após fazermos o que desejávamos em paralelo, retornamos ao fluxo sequencial. não há garantia de ordem
	.subscribe(user ->
		System.out.println("Receive " + user + " on Thread " + Thread.currentThread().getId()) //thread em que o subscribe está sendo executado
	);

/*
output:

Map, on thread 11
Map, on thread 14
Map, on thread 13
Receive [User: 8a53d3c6-7334-4bc5-bfaf-692e5edf1588] on Thread 11
Map, on thread 12
Receive [User: 388d5a3c-2684-42f5-865c-9e02593ebbe8] on Thread 11
Map, on thread 12
Receive [User: b67db5b5-9587-4225-a3cd-bf5215c1e26b] on Thread 11
Receive [User: b839984c-58c1-466f-a9fb-157ddf4ab552] on Thread 11
Receive [User: 45de816f-265c-4d1a-afa6-379f6cf47f33] on Thread 11
Map, on thread 13
Receive [User: 5711c6a9-40ec-40e4-9aff-bd8963874f28] on Thread 13
Map, on thread 11
Receive [User: 04ff0281-6634-4ba3-9be0-23ea7bafa4b5] on Thread 11
Map, on thread 14
Receive [User: 6ef20386-ff22-4c24-b4fe-e249a3fd441b] on Thread 14
Map, on thread 11
Receive [User: 7e22f542-b1ae-48c5-86b7-d09946bf544b] on Thread 11
Map, on thread 12
Receive [User: 77f103a7-15ac-4e62-a0f8-cebd9873f4a3] on Thread 12
*/
```

Como podemos ver, as execuções da função enviada ao operador `map` foram feitas **em paralelo**, em *threads* diferentes; o nível de paralelismo é, por padrão, determinado pelo número de CPUs disponíveis (momento cultural: isso pode ser obtido em Java usando [Runtime.getRuntime().availableProcessors()](https://docs.oracle.com/javase/8/docs/api/java/lang/Runtime.html#availableProcessors--)). Se preferir, você pode determinar explicitamente o paralelismo da execução, usando [essa sobrecarga](http://reactivex.io/RxJava/javadoc/io/reactivex/Flowable.html#parallel-int-) do método `parallel`.

Ao obter uma instância do `ParallelFlowable`, um detalhe importante comentado no código acima é o método [runOn](http://reactivex.io/RxJava/javadoc/io/reactivex/parallel/ParallelFlowable.html#runOn-io.reactivex.Scheduler-), análogo ao `subscribeOn` e `observeOn`; esse método **deve** ser parametrizado com o `Scheduler` apropriado para o processamento em paralelo, caso contrário, tudo será executado na *thread* corrente.

Outro método importante é o [sequential](http://reactivex.io/RxJava/javadoc/io/reactivex/parallel/ParallelFlowable.html#sequential--):

![sequential](/images/programacao-reativa-parte-3-4.png)

Conforme o *marble diagram* demonstra, esse operador irá reordenar os elementos emitidos em diferentes *threads* em um nova sequência de eventos ordenados. Não há nenhuma garantia sobre a ordem dos elementos, e o novo `Flowable` devolvido por esse método coleta os elementos conforme eles são emitidos. O `ParallelFlowable` não possui o método `subscribe`, de modo que, para se subscrever aos eventos, você **deve** utilizar esse método.

Talvez nesse momento surja uma dúvida: por que o `Flowable` possui um "modo paralelo", e o `Observable` não? Porque, na versão 2.x, apenas o `Flowable` suporta **backpressure**, que é essencial para não sobrecarregar as *threads*.

Mas o que é "backpressure"?

## Backpressure (e mais Flowable)

O conceito de *backpressure* ("contra-pressão") é um dos pilares da programação reativa, e é suportado (de uma maneira ou de outra) por todas as ferramentas que suportam esse paradigma.

Em um fluxo reativo, temos dois atores principais: um produtor (`stream`) e um consumidor (`subscriber`). Como vimos até aqui, o paradigma reativo é baseado na geração de eventos, empurrados para um *pipeline* de operações, e por fim, igualmente empurrados para o consumidor. Porém, vimos que isso pode ocorrer em diferentes *threads*, o que implica diferentes velocidades; o que poderia acontecer, então, se **o produtor gerasse dados mais rapidamente do que o consumidor fosse capaz de processá-los?** (música de desastre soando ao fundo)

*Backpressure* é o remédio para essa situação. Essencialmente, essa palavra representa **uma maneira para que o consumidor avise ao produtor que ele não é capaz de lidar com o volume ou a velocidade dos eventos emitidos**.

Considere o seguinte exemplo, baseado em um código imperativo:

```java
Collection<String> elements = ... //obtêm uma coleção de elementos de alguma forma

Iterator<String> iterator = elements.iterator();

// percorre os elementos da coleção
while (iterator.hasNext()) {

	//obtem o elemento corrente da iteração;
	String element = iterator.next();

	//faz algo com o elemento obtido
}
```

O código acima fornece um *backpressure* "natural", pois os dados são **solicitados** pelo programa (*pull based*); se o método `next` for uma operação bloqueante, o programa irá esperar que essa operação termine para que a execução continue. A coleção não gera elementos mais rapidamente do que o código é capaz de processar, pelo simples fato de que o programa os solicita um de cada vez.

Na programação reativa, o inverso acontece: o modelo de programação é *push based*, onde os dados são empurrados para o programa; nosso código **recebe**, ao invés de solicitar os dados. Considere o exemplo abaixo:

```java
// emite um evento a cada millisegundo (!)
Observable.interval(1, TimeUnit.MILLISECONDS)
	.subscribe(element -> {
		try {
			// aguarda dois segundos...
			Thread.sleep(2000);

			System.out.println(element);

		} catch (Exception e) {}
	});
```

Acima, temos um consumidor mais lento do que a emissão de eventos. Nesse código, não ocorreria problema nenhum, pois vimos que, a não ser que digamos o contrário, a publicação e o consumo dos eventos ocorrem **na mesma thread**. Então, o primeiro `onNext` é bloqueado até que tudo seja executado, e só após isso o segundo evento é emitido, e assim sucessivamente. Se houvesse outro `Scheduler` envolvido no consumo dos eventos (via `observeOn`), nosso programa ainda funcionaria...até o momento em que fosse encerrado com um erro do tipo `OutOfMemoryError`!

Certamente não queremos que isso aconteça, certo? Queremos que, em momentos de pico, nosso software seja capaz de continuar a processar e responder. Em outras palavras, queremos que nosso software seja **resiliente**. Mas como?

### Backpressure in action :)

```java
Flowable.interval(1, TimeUnit.MILLISECONDS)
	.observeOn(Schedulers.newThread())
	.subscribe(element -> {
		try {
			Thread.sleep(2000);

			System.out.println(element);

		} catch (Exception e) {}
	});
```

O código acima irá gerar uma exceção do tipo [MissingBackpressureException](http://reactivex.io/RxJava/javadoc/io/reactivex/exceptions/MissingBackpressureException.html). Essa exceção indica exatamente a situação que temos em mãos e que vimos acima: o produtor tentou emitir um evento que o consumidor não é capaz de processar. Na versão 1.x do RxJava, o `Observable` também lançava essa exceção caso o consumidor fosse sobrecarregado, mas esse é um problema um tanto quanto obscuro e talvez inesperado. Afinal, nós vimos que o `Flowable` suporta *backpressure*, mas a exceção indica que o *backpressure* está "ausente". Por que? Porque não definimos a **política** do que deve ser feito caso o volume de eventos seja maior do que o tamanho da pilha interna, **que por padrão é 128 elementos** (esse valor é configurável e pode ser sobrescrito, inclusive para cada operador através de sobrecargas dos métodos. Para configurar o tamanho da pilha globalmente, veja como [aqui](http://reactivex.io/RxJava/javadoc/io/reactivex/Flowable.html#bufferSize--)).

Esse é um detalhe interessante, pois o *backpressure* nos dá o poder de implementarmos um comportamento a respeito dos eventos adjacentes. Afinal de contas, mesmo que o consumidor não seja capaz de processá-los, eventos **estão** sendo gerados; em um *software* convencional, essa sobrecarga iria assassinar nosso programa, mas agora temos as ferramentas para decidir o que deve ser feito.

Para começarmos, podemos converter nosso `Observable` em um `Flowable`, com o método [toFlowable](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#toFlowable-io.reactivex.BackpressureStrategy-).

```java
Flowable flowable = Observable.interval(1, TimeUnit.MILLISECONDS)
 	.toFlowable(???)
```

Esse método recebe como parâmetro um [BackpressureStrategy](http://reactivex.io/RxJava/javadoc/io/reactivex/BackpressureStrategy.html), que é um *enum* com as políticas possíveis de *backpressure* que podem ser aplicadas, e que vamos analisar abaixo.

#### Políticas de backpressure

#### missing

![missing](/images/programacao-reativa-parte-3-5.png)

Com a estratégia [MISSING](http://reactivex.io/RxJava/javadoc/io/reactivex/BackpressureStrategy.html#MISSING), basicamente desligamos o *backpressure* do `Flowable` criado. Eventos são emitidos respeitando o tamanho da pilha, e o consumidor deve lidar com qualquer sobrecarga. E se ele não conseguir? Adivinhe: `MissingBackpressureException`.

```java
Flowable<Long> flowable = Observable.interval(1, TimeUnit.MILLISECONDS)
			.toFlowable(BackpressureStrategy.MISSING);

flowable.observeOn(Schedulers.newThread())
	.subscribe(element -> {
		try {
			Thread.sleep(2000);

			System.out.println(element);

		} catch (Exception e) {}
	});

/*output:

io.reactivex.exceptions.MissingBackpressureException: Queue is full?!
*/
```

Mas haveria alguma motivação para utilizarmos essa estratégia, desabilitando o *backpressure*? Sim, como veremos mais adiante.

#### error

![error](/images/programacao-reativa-parte-3-6.png)

A estratégia [ERROR](http://reactivex.io/RxJava/javadoc/io/reactivex/BackpressureStrategy.html#ERROR), como o nome indica, irá lançar uma exceção do tipo `MissingBackpressureException` caso o consumidor não consiga mais processar eventos. Ela é útil caso queiramos que nosso *subscriber* seja imediatamente notificado sobre essa situação.

```java
Flowable<Long> flowable = Observable.interval(1, TimeUnit.MILLISECONDS)
			.toFlowable(BackpressureStrategy.ERROR);

flowable.observeOn(Schedulers.newThread())
	.subscribe(element -> {
		try {
			Thread.sleep(2000);

			System.out.println(element);

		} catch (Exception e) {}
	});

/*output:

io.reactivex.exceptions.MissingBackpressureException: could not emit value due to lack of requests
*/
```

#### buffer

![buffer](/images/programacao-reativa-parte-3-7.png)

O [BUFFER](http://reactivex.io/RxJava/javadoc/io/reactivex/BackpressureStrategy.html#BUFFER) irá configurar o `Flowable` para *armazenar* os eventos até que eles possam ser consumidos.

```java
Flowable<Long> flowable = Observable.interval(1, TimeUnit.MILLISECONDS)
			.toFlowable(BackpressureStrategy.BUFFER);

flowable.observeOn(Schedulers.newThread())
	.subscribe(element -> {
		try {
			Thread.sleep(2000);

			System.out.println(element);

		} catch (Exception e) {}
	});

/*output:

1
2
...
*/
```

No exemplo acima, não há `MissingBackpressureException`; os eventos são armazenados até que o *subscriber* possa processá-los.

#### drop

![drop](/images/programacao-reativa-parte-3-8.png)

Outra abordagem possível é simplesmente descartar os eventos excedentes, e essa estratégia é o [DROP](http://reactivex.io/RxJava/javadoc/io/reactivex/BackpressureStrategy.html#DROP). Essa estratégia irá descartar todos os eventos posteriores ao momento em que o tamanho máximo da pilha foi alcançado.

```java
Flowable<Long> flowable = Observable.interval(1, TimeUnit.MILLISECONDS)
			.toFlowable(BackpressureStrategy.BUFFER);

flowable.observeOn(Schedulers.newThread())
	.subscribe(element -> {
		try {
			Thread.sleep(100);

			System.out.println(element);

		} catch (Exception e) {}
	});

/*output (essa saída certamente irá variar):

1
2
3
...
125
127
...
9870 (os valores anteriores foram descartados!)
*/
```

O *output* da execução acima certamente será diferente caso você execute esse código, mas em algum ponto da sequência você perceberá que vários valores foram simplesmente "pulados" (na minha execução, a saída pulou do valor 127 para o 9870!); na verdade eles foram apenas descartados pelo `Flowable`. Essa estratégia é útil caso você possa se dar ao luxo de descartar elementos; afinal, dependendo do caso de uso, pode ser melhor conseguir lidar com alguns eventos do que com evento nenhum (que é o que acontecerá caso sua aplicação caia ;)).

#### latest

![latest](/images/programacao-reativa-parte-3-9.png)

Por último, o [LATEST](http://reactivex.io/RxJava/javadoc/io/reactivex/BackpressureStrategy.html#LATEST), que é sutilmente diferente do `DROP`. O detalhe é que essa estratégia garante que o **último evento** adicional não será descartado. A estratégia `DROP` não tem essa preocupação, descartando todos até que o consumidor possa voltar a consumí-los.

### onBackpressureXXX

O `Flowable` possui alguns métodos que permitem configurar diretamente a política de *backpressure* no próprio objeto. Esse é um caso de uso para a estratégia `MISSING`; pode fazer sentido você utilizar essa estratégia ao converter um `Observable` para um `Flowable`, e depois utilizar um desses métodos para **configurar explicitamente** como se dará o *backpressure* dentro do *pipeline* reativo.

#### onBackpressureDrop

![onBackpressureDrop](/images/programacao-reativa-parte-3-10.png)

#### onBackpressureBuffer

![onBackpressureBuffer](/images/programacao-reativa-parte-3-11.png)

#### onBackpressureLatest

![onBackpressureLatest](/images/programacao-reativa-parte-3-12.png)

## Processamento bloqueante - "The Dark Side of the Reactive Programming"

Muito do que se diz a respeito da programação reativa se refere a **processamento não bloqueante**, e, como vimos acima, os frameworks Rx fornecem uma sólida fundação para implementarmos esse tipo de lógica. O próprio modelo de programação declarativo também simplifica a implementação; ao invés do código imperativo, trabalhamos com funções que apenas recebem dados empurrados (através de parâmetros) e devolvem o resultado de uma computação, e se essa função é executada em uma *thread* separada, é um detalhe que não afeta a escrita do código.

Mas nem sempre isso é possível ou é o desejado, especialmente no caso do Java, que é uma linguagem imperativa; muitas vezes, ao invés de enviarmos uma função que será executada quando o valor estiver disponível, precisamos do valor *em si* (ou eventualmente de todos os valores gerados pelo `stream`). Isso é especialmente verdadeiro para compatibilidade com códigos já existentes ou biblotecas de terceiros.

Se esse for o caso, podemos usar os **operadores bloqueantes**. O nome indica claramente que o processamento do `stream` deve ser *bloqueado*, porque, embora por padrão um objeto reativo seja *single-thread*, isso é feito *implicitamente*; como vimos nos exemplos acima, se quisermos tornar nosso `stream` assíncrono, o *pipeline* reativo não é afetado: será sempre **push based**. E se quisermos alterar esse comportamento para um modelo bloqueante a fim de obter um valor específico do `stream`, isso deve ser feito **explicitamente**, através desses métodos.

### blockingFirst

![blockingFirst](/images/programacao-reativa-parte-3-5.png)

O operador [blockingFirst](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#blockingFirst--), como o nome indica, retorna o primeiro elemento emitido pelo `stream`. Se nenhum item foi emitido, uma exceção do tipo `NoSuchElementException` será lançada. Como dito antes, o retorno desse método é o **valor em si** extraído do `stream`, e não um novo `Observable` como os demais operadores reativos.

```java
String first = Observable.just("one", "two", "three")
	.map(String::toUpperCase)
	.blockingFirst();

System.out.println("First value is: " + first);

/*
output:

First value is: ONE
*/
```

Como comentei, o `blocking` no nome do método não é um detalhe; estamos dizendo explicitamente ao `Observable` que o processamento deve ser bloqueado a fim de retornar o primeiro valor. No exemplo acima, não há diferença (*single-thread* por padrão, lembram-se?), mas digamos que nosso `map` esteja sendo executado em *threads* separadas; essas *threads* **serão bloqueadas**, pois o `Observable` precisa aguardar que elas terminem a fim de gerar o retorno do método. Introduzindo o *observeOn* no código acima, teríamos:

```java
String first = Observable.just("one", "two", "three")
	.observeOn(Schedulers.newThread()) // aqui estamos dizendo ao Observable que queremos processar os elementos em outra thread
	.map(String::toUpperCase) // essa função será executada em uma thread separada
	.blockingFirst(); // para gerar o retorno desse método o Observable PRECISA aguardar as threads serem finalizadas

System.out.println("First value is: " + first);

/*
output:

First value is: ONE
*/
```

Existe uma [sobrecarga](http://reactivex.io/RxJava/javadoc/io/reactivex/Observable.html#blockingFirst-T-) desse operador que permite informar um valor *default*, caso o `Observable` não tenha emitido nenhum elemento (evitando o `NoSuchElementException`).

### blockingLast

![blockingLast](/images/programacao-reativa-parte-3-6.png)
