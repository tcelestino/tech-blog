---
date: 2017-04-17
category: back-end
tags:
  - java
  - mockito
  - tdd
author: ljtfreitas
layout: post
title: Testes de código com Mockito (2) - Novidades da nova versão
description: Há algum tempo, escrevi sobre o funcionamento e os principais recursos do Mockito. Neste post, vamos conhecer as novidades da nova versão do framework.
---
Há algum tempo, escrevi um [post](/testes-codigo-mockito) sobre o funcionamento e os principais recursos do [Mockito](http://site.mockito.org/). Na ocasião em que o post foi escrito, a versão 2 do framework ainda estava em beta, e, nesse tempo, não apenas foi [oficialmente lançada](https://github.com/mockito/mockito/wiki/What%27s-new-in-Mockito-2) como ocorreram vários releases subsequentes (no momento em que escrevo, a última versão é a 2.7.22).

Neste post, vou demonstrar as principais novidades e funcionalidades dessa nova versão.

## Construção de mocks/proxy de objetos e classes final
A principal alteração interna da versão 2 do Mockito foi a mudança da biblioteca utilizada para construção de mocks/proxificação de objetos. Para entendermos melhor essa mudança, cabe perguntar: o que raios é um proxy?

Sem me estender muito na explicação, "proxy" é um design pattern que permite colocar um objeto "espelho" à frente de outro, que implemente a mesma interface (interface = conjunto de métodos expostos do objeto). Esse objeto "espelho" (que é a instância efetivamente usada no código) é capaz de interceptar as chamadas de método realizadas, capturando os metadados do método invocado e os argumentos enviados. O proxy é capaz de realizar tratamentos específicos para algum método em particular, ou manipular os argumentos antes de invocar o método no objeto "verdadeiro", e eventualmente até mesmo cancelar a invocação. Normalmente, isso é implementado utilizando algum recurso fornecido pela própria linguagem.

No caso do Java, proxys são um elemento fundamental em frameworks de mock. TODOS os mocks gerados pelo Mockito são proxies da classe que está sendo "mockada". No meu primeiro post, eu disse que uma definição fundamental da palavra "mock" é que se trata de um **objeto gerado em tempo de execução**; em Java, isso ocorre literalmente, porque um proxy é, com efeito, bytecode gerado em tempo de execução :).

A API padrão do Java permite a geração de proxies [apenas para interfaces](https://docs.oracle.com/javase/7/docs/api/java/lang/reflect/Proxy.html#getProxyClass); essa limitação era contornada com o uso de algumas coisas complicadas como instrumentação de código, manipulação de bytecode e compilação em runtime. As bibliotecas que se destacam na comunidade Java para esse tipo de trabalho são o [CGLIB](https://github.com/cglib/cglib) e o [javassist](https://github.com/jboss-javassist/javassist), utilizados em vários frameworks (como o Spring e o Hibernate).

O Mockito, desde a primeira versão, usava o CGLIB como ferramenta de construção de mocks; a partir da versão 2, a biblioteca utilizada passou a ser o [ByteBuddy](http://bytebuddy.net/). As principais justificativas para a mudança são que o CGLIB, de fato, tem algumas limitações em relação ao bytecode gerado nas versões mais recentes do Java, além do ByteBuddy permitir a correção de alguns bugs de longa data do Mockito (que não eram passíveis de correções por limitações do CGLIB).

Mas, apesar de realmente ser uma mudança de alto impacto, o que isso muda para os nossos testes? A princípio, nada. Como a construção de mocks/proxies de objetos é feita internamente pelo Mockito, a maneira como os mocks são gerados não tem nenhum efeito direto sobre a maneira como nossos testes são escritos. Não obstante, essa mudança teve o efeito positivo de introduzir uma novidade, ainda que em caráter experimental: permitir mockar classes *final*! :)

```java
public final class Sample {

	public final String bla() {
		return "bla";
	}
}

public class SampleTest {

	@Test
	public void test() {
		Sample sampleMock = Mockito.mock(Sample.class);
		when(sampleMock.bla()).thenReturn("foo");

		String output = sampleMock.bla();

		assertEquals("foo", output);
	}
}
```

Nas versões 1.x do Mockito, o teste acima simplesmente não funcionaria, pois seria impossível mockar a classe Sample ou mesmo o método "bla()". Isto porquê o mecanismo de proxy do CGLIB se baseia em criar, em tempo de execução, uma subclasse do objeto proxificado; como não é possível criar uma subclasse de uma classe *final*, ou sobrescrever um método marcado como *final*, não era possível implementar um teste como o do exemplo acima.

Como dito antes, essa funcionalidade em particular está em fase de testes pelo framework. Para habilitá-la, você deve ativar um mecanismo interno do Mockito semelhante ao [ServiceLoader](https://docs.oracle.com/javase/8/docs/api/java/util/ServiceLoader.html) do Java:
- no seu classpath de teste, crie uma pasta chamada mockito-extensions, e dentro dela um arquivo chamado org.mockito.plugins.MockMaker (se o seu projeto utiliza Maven ou Gradle, por exemplo, o local desse arquivo seria "src/test/resources/mockito-extensions/org.mockito.plugins.MockMaker")
- o conteúdo desse arquivo deve ser uma única linha contendo: **mock-maker-inline**

A presença desse arquivo irá sobrescrever o [MockMaker](http://static.javadoc.io/org.mockito/mockito-core/2.7.22/org/mockito/plugins/MockMaker.html) padrão utilizado pelo Mockito. Essa interface foi projetada para servir como um ponto de extensão do framework, permitindo customizar a maneira como os mocks são criados.

Com a configuração acima, o Mockito irá utilizar uma implementação especialmente projetada para usar uma combinação de subclasses e instrumentação (através de um Java Agent). Mas não se preocupe: essas complexidades de baixo nível são invisíveis para o teste, e finalmente seremos capazes de mockar nossas classes e métodos *final* (como o exemplo acima)!

Para mais detalhes: [Mock the unmockable](http://static.javadoc.io/org.mockito/mockito-core/2.8.47/org/mockito/Mockito.html#Mocking_Final)

## Stubs não utilizados
Um dos objetivos dessa versão do Mockito é ajudar os desenvolvedores a escrever testes melhores. Um dos pontos de atenção para manter os testes limpos e fáceis de entender é evitar código não utilizado, como configurações de mocks que não são usados na execução do programa. Vejamos um exemplo:

```java
public class Dictionary {

	private final Translator translator;

	public Dictionary(Translator translator) {
		this.translator = translator;
	}

	public String get(String word) {
		return translator.translate(word);
	}
}
```

E nosso teste:

```java
@RunWith(MockitoJUnitRunner.class)
public class DictionaryTest {

	@Mock
	private Translator translator;

	@InjectMocks
	private Dictionary dictionary;

	@Test
	public void test() {
		String word = "ola";

		when(translator.translate(word)).thenReturn("hello");

		String output = dictionary.get(word);

		assertNotNull(output);
	}
}
```

Nossa classe Dictionary, no método "get", utiliza uma instância do Translator (uma interface; a implementação do Translator não é relevante para nós) para "traduzir" a palavra enviada como parâmetro. Utilizamos o Mockito para configurar o método "translate" do Translator, para devolver a String "hello" quando o método for invocado com a palavra "word". O teste apenas verifica se a resposta do método é não-nula (um teste frágil mas atende nosso exemplo por hora). O teste acima passaria sem problema. Mas, e se nosso código fosse modificado da seguinte forma:

```java
public class Dictionary {

	private final Translator translator;

	public Dictionary(Translator translator) {
		this.translator = translator;
	}

	public String get(String word) {
		return "ooops";
	}
}
```

Perceba que o método "get" não utiliza mais o Translator. Este seria um bug que nosso teste não detectaria, por dois motivos: 1) o teste apenas confirma que a saída do método é uma String não-nula, o que continua acontecendo, e 2) o teste não verifica se o mock foi efetivamente invocado (usando o Mockito.verify). O ponto que quero ressaltar aqui é que a detecção do bug, nesse caso, **depende do teste estar bem escrito**. Isso pode parecer apenas senso comum, mas é muito fácil deixar passar esse tipo de detalhe, às vezes por simples desatenção momentânea, por não realizarmos completamente o ciclo do TDD (red-green-refactor), ou por simples desconhecimento de eventuais recursos dos frameworks envolvidos.

Por outro lado, a mudança que realizamos acima também poderia ser uma refatoração válida: digamos que nosso Dictionary realmente não irá mais utilizar o Translator e irá implementar sua lógica interna de outro modo. Em nosso teste, teríamos um mock não utilizado, com a configuração desnecessária poluindo o código. Agora, o Mockito é capaz de detectar esse tipo de situação.

Se executarmos novamente nosso DictionaryTest (após a mudança acima na classe Dictionary), teríamos como saída do teste:

![mockito-2-output-unused-stub](../images/mockito-2-output-unused-stub.png)

O teste irá passar, mas será exibido no relatório do Junit a seguinte mensagem:

```java
org.mockito.exceptions.misusing.UnnecessaryStubbingException:
Unnecessary stubbings detected in test class: DictionaryTest
Clean & maintainable test code requires zero unnecessary code.
Following stubbings are unnecessary (click to navigate to relevant line of code):
  1. -> at com.elo7.mockito.sample.DictionaryTest.test(DictionaryTest.java:25)
Please remove unnecessary stubbings or use 'silent' option. More info: javadoc for UnnecessaryStubbingException class.
	at org.mockito.internal.runners.StrictRunner.run(StrictRunner.java:49)
	at org.mockito.junit.MockitoJUnitRunner.run(MockitoJUnitRunner.java:161)
	at org.eclipse.jdt.internal.junit4.runner.JUnit4TestReference.run(JUnit4TestReference.java:86)
	at org.eclipse.jdt.internal.junit.runner.TestExecution.run(TestExecution.java:38)
	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.runTests(RemoteTestRunner.java:459)
	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.runTests(RemoteTestRunner.java:678)
	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.run(RemoteTestRunner.java:382)
	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.main(RemoteTestRunner.java:192)

```

Além da mensagem bastante explicativa, o erro também inclui a linha do arquivo com a configuração desnecessária do mock. Reforçando: essa mensagem de "stubs não utilizados" será exibida **apenas se o teste passar** (essa decisão foi justificada pela equipe do Mockito tendo em mente que, se o teste falhar, exibir a mensagem de falha em conjunto com o erro relativo aos stubs poderia gerar confusão ao usuário).

Então, agora temos o recurso do Mockito nos ajudar a limpar o código de teste (se for o caso), indicando configurações de mocks (os tais "stubs") não utilizados. Mas e se o teste ainda não estiver passando? Um problema em potencial poderia ser uma eventual configuração incorreta do mock; ou seja, o mock está sendo utilizado no código mas não da maneira como foi "stubado". Digamos, algo assim:

```java
public class Dictionary {

	private final Translator translator;

	public Dictionary(Translator translator) {
		this.translator = translator;
	}

	public String get(String word) {
		return translator.translate(word);
	}
}
```

Novamente, nosso teste:

```java
@RunWith(MockitoJUnitRunner.class)
public class DictionaryTest {

	@Mock
	private Translator translator;

	@InjectMocks
	private Dictionary dictionary;

	@Test
	public void test() {
		String word = "ola";

		when(translator.translate(word)).thenReturn("hello");

		String output = dictionary.get("other word");

		assertNotNull(output);
	}
}
```

O teste acima irá falhar. A resposta do método "get" do Dictionary será *null*, porque configuramos o Translator para devolver "hello" **somente** quando o método "translate" for invocado com o parâmetro "ola", o que não foi o caso já que enviamos a String "other word". O Mockito também é capaz de nos auxiliar nessa situação, indicando que o mock não foi invocado como foi configurado. Ao rodar o teste acima, a seguinte mensagem será printada no console:

```java
[MockitoHint] DictionaryTest.test (see javadoc for MockitoHint):
[MockitoHint] 1. Unused... -> at com.elo7.mockito.sample.DictionaryTest.test(DictionaryTest.java:25)
[MockitoHint]  ...args ok? -> at com.elo7.mockito.sample.Dictionary.get(Dictionary.java:12)
```

Nessa mensagem, o Mockito incluiu o ponto do código onde o mock é configurado, e o ponto onde está sendo utilizado (incorretamente ou, no mínimo, de modo diferente do que foi configurado). Esse relatório é extremamente útil, principalmente para testes mais complexos (casos em que os programadores, invariavelmente, debugam o código para encontrar o problema). Ao contrário do exemplo anterior, esse relatório de "stubs mal utilizados", se for o caso, será exibido no console (fora da saída do Junit) **somente quando o teste falhar**.

Caso prefira não utilizar a verificação de "stubs não utilizados" (habilitado por padrão), você pode usar o Mockito no modo "silencioso":

```java
@RunWith(MockitoJUnitRunner.Silent.class)
public class DictionaryTest {
}
```

## Matchers do Hamcrest
Uma dor de cabeça recorrente das versões 1.x do Mockito era o conflito de versões do [Hamcrest](http://hamcrest.org/JavaHamcrest/), uma biblioteca de *argument matchers*. Esses conflitos ocorriam porque o Mockito dependia explicitamente do Hamcrest (em função do método [Matchers.argThat](http://static.javadoc.io/org.mockito/mockito-core/1.10.19/org/mockito/Matchers.html#argThat(org.hamcrest.Matcher)), que aceita como parâmetro um matcher), mas as classes principais do Hamcrest são carregadas dentro do jar do JUnit (para serem utilizadas no método [Assert.assertThat](http://junit.org/junit4/javadoc/latest/org/junit/Assert.html#assertThat(T,%20org.hamcrest.Matcher))), o que eventualmente gerava um pequeno e clássico "classpath hell" (já que o Mockito dependia de uma versão e o JUnit de outra).

Essa dependência foi removida e o método *Matchers.argThat* (que recebia como parâmetro um matcher do Hamcrest) foi depreciado. Se quiser utilizar o Hamcrest no seu projeto, você mesmo deve incluí-lo no seu classpath de testes, e utilizar a nova classe [MockitoHamcrest](http://static.javadoc.io/org.mockito/mockito-core/2.8.47/org/mockito/hamcrest/MockitoHamcrest.html).

A respeito da depreciação do método *Matchers.argThat*: na verdade, a classe Matchers foi inteiramente depreciada. Essa classe era extendida pela classe Mockito (a classe principal do framework), que na versão 2, passa a extender a classe [ArgumentMatchers](http://static.javadoc.io/org.mockito/mockito-core/2.8.47/org/mockito/ArgumentMatcher.html).

## Answers.RETURNS_SELF
No meu post anterior, explorei a abstração [Answer](http://static.javadoc.io/org.mockito/mockito-core/2.8.47/org/mockito/stubbing/Answer.html) e as várias opções possíveis para configurar a resposta dos métodos de um mock. Na versão 2, o Mockito introduziu uma nova opção chamada [RETURNS_SELF](http://static.javadoc.io/org.mockito/mockito-core/2.8.47/org/mockito/Answers.html#RETURNS_SELF), que é particularmente útil para testes envolvendo Builders.

```java
@RunWith(MockitoJUnitRunner.class)
public class SomeTest {

	@Mock(answer = Answers.RETURNS_SELF)
	private Builder builder;

}
```
O comportamento dessa resposta é: se algum método **não configurado** desse mock for invocado,

* Se o retorno do método for algum tipo **igual à classe ou superclasse** do mock, retorna a **mesma instância** do mock;
* Para qualquer outro caso, seguirá o mesmo comportamento da configuração padrão do Mockito ([RETURNS_DEFAULTS](http://static.javadoc.io/org.mockito/mockito-core/2.8.47/org/mockito/Mockito.html#RETURNS_DEFAULTS)).

Considere o exemplo abaixo, extraído da documentação:

```java
public class HttpBuilder {

	private String uri;

	private List<String> headers;

	public HttpBuilder() {
		this.headers = new ArrayList<>();
	}

	public HttpBuilder withUrl(String uri) {
		this.uri = uri;
		return this;
	}

	public HttpBuilder withHeader(String header) {
		this.headers.add(header);
		return this;
	}

	public String request() {
		return uri + headers.toString();
	}
}

public class HttpRequestWithHeaders {

	private final HttpBuilder builder;

	public HttpRequestWithHeaders(HttpBuilder builder) {
		this.builder = builder;
	}

	public String execute(String uri) {
		return builder.withUrl(uri)
				.withHeader("Content-type: application/json")
				.withHeader("Authorization: Bearer")
				.request();
	}
}
```
E o teste:

```java
@RunWith(MockitoJUnitRunner.class)
public class SomeTest {

	@Mock(answer = Answers.RETURNS_SELF)
	private HttpBuilder builder;

	@Test
	public void test() {
  		HttpRequesterWithHeaders requester = new HttpRequestWithHeaders(builder);

  		String response = "StatusCode: 200";

  		when(builder.execute()).thenReturn(response);

  		assertThat(requester.request("URI")).isEqualTo(response);
	}
}
```

## E mais mudanças...
* A nova versão é compatível apenas com Java 6 ou superior (a versão 1.x é compatível com Java 5)

* Os matchers *anyX()* (anyString(), anyInt(), etc) e *any(AlgumTipo.class)* passam a **rejeitar valores nulos**. Exemplos:
```java
public interface Translator {

	String translate(String word);

}

@RunWith(MockitoJUnitRunner.class)
public class SomeTest {

	@Mock
	private Translator translator;

	@Test
	public void test() {
		translator.translate(null);

		verify(translator).translate(anyString()); // falha -> null não é "qualquer String"
		verify(translator).translate(any()); // sucesso -> null é "qualquer"
	}
}
```

* O método *getArgumentAt*, da classe [InvocationOnMock](http://static.javadoc.io/org.mockito/mockito-core/2.8.47/org/mockito/invocation/InvocationOnMock.html) foi renomeado e teve sua assinatura alterada para inferir o tipo de retorno de forma implícita (ao invés de receber um argumento do tipo Class). Esse mudança é muito importante caso você implemente respostas customizadas. Também foram criadas novas [Answers](http://static.javadoc.io/org.mockito/mockito-core/2.8.47/org/mockito/stubbing/Answer1.html) para métodos com múltiplos argumentos.

* Para fins de depuração, caso você queira visualizar todas as invocações do seu mock, você pode utilizar o novo método [MockingDetails.printInvocations](http://static.javadoc.io/org.mockito/mockito-core/2.8.47/org/mockito/MockingDetails.html#printInvocations()):

```java
@RunWith(MockitoJUnitRunner.class)
public class SomeTest {

	@Mock
	private Translator translator;

	@Test
	public void test() {
		translator.translate("ola");

		System.out.println(Mockito.mockingDetails(translator).printInvocations());
	}
}
```

A saída no console:
```java
[Mockito] Interactions of: translator
 1. translator.translate("ola");
  -> at com.elo7.mockito.sample.SomeTest.test(SomeTest.java:17)
```

## Conclusão
O Mockito é um dos principais, e talvez o mais utilizado, frameworks para mocks disponíveis na linguagem Java, muito devido à simplicidade na sua utilização e grande número de recursos. A versão 2.x manteve essa linha de implementação, além de trazer novos e interessantes funcionalidades para ajudar os desenvolvedores a escrever mais e melhores testes. Nesse post, cobri as principais mudanças e novidades da nova versão. Espero que tenha gostado, e que este post seja útil para você. Em caso de dúvidas ou críticas, sinta-se à vontade para utilizar a caixa de comentários!
