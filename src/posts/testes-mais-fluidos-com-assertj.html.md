---
date: 2018-01-29
category: back-end
tags:
  - java
  - tdd
  - assertj
authors: [fabioueno]
layout: post
title: Testes mais fluídos com AssertJ
description: Diversos posts falam sobre a importância dos testes, mas o foco aqui será como melhorar a compreensão e legibilidade de nossos testes utilizando o AssertJ!
---

Em um [_post_](https://engenharia.elo7.com.br/a-cultura-por-tras-do-time-fora-de-serie) anterior, o Leonardo Souza explicou como é a cultura da empresa e comentou sobre o _hackday_, um dia em que os desenvolvedores podem trabalhar em suas próprias ideias. Eu entrei para a empresa em outubro e nos meus primeiros meses fiquei auxiliando nas ideias de outras pessoas, pois ainda não tinha nenhuma ideia. Pouco tempo depois, a ThoughtWorks lançou a décima-sétima edição do seu radar e, para minha surpresa, na área de linguagens e _frameworks_ para se adotar estava apenas Python 3. Na área seguinte, para testar, estava o [**AssertJ**](http://joel-costigliola.github.io/assertj), então decidi dar uma olhada nele.

## Motivação

A primeira coisa que pensei foi: qual é a vantagem em utilizá-lo? Logo de cara, o radar nos informa que o _framework_ em questão fornece uma interface fluída para asserções. Mas o que é uma interface fluída? [Martin Fowler](https://martinfowler.com/bliki/FluentInterface.html) mostra um exemplo e comenta um pouco, mas, em resumo, é uma forma de escrever nosso código tentando nos aproximar da maneira como escrevemos no dia-a-dia.

Depois disso, resolvi dar uma olhada no código, de fato. Vamos supor que temos um cenário de teste em que queremos verificar se a variável `a` é igual à variável `b`.

### JUnit

Utilizando apenas JUnit ficaríamos com o seguinte código:

```java
assertEquals(b, a);
```

E teríamos a seguinte importação:

```java
import static org.junit.Assert.assertEquals;
```

Essa asserção sempre me incomodou, pois eu não gostava de escrever primeiro o valor esperado e, só depois, o valor real. Felizmente isso não foi algo frequente no meu time, pois usamos o [Hamcrest](http://hamcrest.org). Aí entrou um outro ponto: qual a vantagem do AssertJ sobre o que já usamos?

### Hamcrest

Para isso, vamos reescrever o teste acima, usando o que o time já estava acostumado:

```java
assertThat(a, equalTo(b));
```

E os `import`s:

```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
```

É possível observar que agora escrevemos na ordem que esperamos, ou seja, primeiro o valor real, depois o esperado. Um outro ponto é que aumentamos o número que `import`s para dois, mas isso é totalmente aceitável.

### AssertJ

E, finalmente, como ficaria com o AssertJ?

```java
assertThat(a).isEqualTo(b);
```

E teríamos o seguinte `import`:

```java
import static org.assertj.core.api.Assertions.assertThat;
```

Duas coisas que me chamaram a atenção:

1. A asserção ficou ainda melhor do que com Hamcrest (no meu ponto de vista).
2. Temos uma linha de importação a menos.

Mas, sendo sincero, quem se importa quanto à quantidade de linhas de importação? A IDE já nos auxilia e as faz de forma rápida com algum atalho. Como o propósito não é esse, mas escrever nossos testes de forma mais simples e fáceis de entender, achei que o _framework_ cumpria o que prometia. Além disso, procurando por "Hamcrest vs AssertJ" no Google é possível ver que este vem ganhando cada vez mais espaço.

Um ponto importante é que mesmo fazendo as alterações ainda é necessário aprovação do(s) time(s) envolvido(s). Dito isso, eu optei por testá-lo e comecei a migrar todas as minhas classes de teste, até chegar o momento em que não era mais necessário manter a dependência do Hamcrest.

## Migrando os testes

Para converter todos os testes do JUnit para o AssertJ, o próprio site oficial contém uma [seção](http://joel-costigliola.github.io/assertj/assertj-core-converting-junit-assertions-to-assertj.html), onde é possível fazer o _download_ de um _script_, que faz as alterações automaticamente. Entretanto, para ter certeza que aprendi a utilizar o _framework_ e conhecer um pouco mais de suas _features_, optei por fazer todo o processo manualmente. Felizmente não temos mais do que 58 classes de teste no projeto em questão.

### Adicionando a dependência

O primeiro passo foi adicionar a dependência ao projeto, como usamos Gradle:

```java
testCompile 'org.assertj:assertj-core:3.9.0'
```

> Obs: Para a versão 3.x é necessário Java 8 ou superior. Caso tenha o Java 7, use a versão 2.x. Se tiver Java 6, opte pela versão 1.x.

> Obs 2: No [_quick start_](http://joel-costigliola.github.io/assertj/assertj-core-quick-start.html) é possível encontrar o código para o Maven.

### Alterando o primeiro teste

Cada _commit_ meu alterava uma única classe de teste, então vamos para a primeira classe, responsável por verificar se, dado um código, há um tipo de mensagem associada ou não. Um código válido, por exemplo, é 1, enquanto que 99 é inválido. Nosso teste antes, estava da seguinte forma:

```java
public class MessageTypeTest {

    @Test
    public void should_return_present_when_message_type_is_valid() {
        Optional<MessageType> messageType = MessageType.fromCode(1);

        assertTrue(messageType.isPresent());
        assertEquals(1, messageType.get().getCode());
    }

    @Test
    public void should_return_empty_when_message_type_is_not_valid() {
        Optional<MessageType> messageType = MessageType.fromCode(99);

        assertFalse(messageType.isPresent());
    }
}
```

No primeiro exemplo, vimos que onde aparece `assertEquals()`, trocamos por `assertThat().isEqualTo()`, então essa foi a primeira mudança que fiz:

```java
public class MessageTypeTest {

    @Test
    public void should_return_present_when_message_type_is_valid() {
        Optional<MessageType> messageType = MessageType.fromCode(1);

        assertTrue(messageType.isPresent());
        assertThat(messageType.get().getCode()).isEqualTo(1);
    }

    @Test
    public void should_return_empty_when_message_type_is_not_valid() {
        Optional<MessageType> messageType = MessageType.fromCode(99);

        assertFalse(messageType.isPresent());
    }
}
```

Com o que já vimos, poderíamos alterar as asserções _booleanas_, ficando com `assertThat(messageType.isPresent()).isEqualTo(true)` (ou `false` no segundo caso). Mas o _framework_ nos disponibiliza dois métodos para isso, o `isTrue()` ou `isFalse()`, então podemos refatorar tudo, ficando com o código final abaixo:

```java
public class MessageTypeTest {

    @Test
    public void should_return_present_when_message_type_is_valid() {
        Optional<MessageType> messageType = MessageType.fromCode(1);

        assertThat(messageType.isPresent()).isTrue();
        assertThat(messageType.get().getCode()).isEqualTo(1);
    }

    @Test
    public void should_return_empty_when_message_type_is_not_valid() {
        Optional<MessageType> messageType = MessageType.fromCode(99);

        assertThat(messageType.isPresent()).isFalse();
    }
}
```

### Próximos testes

A maioria dos testes continha asserções simples, como `assertEquals()`, `assertTrue()`, `assertFalse()`, `assertNull()` e `assertNotNull()`. Todas elas podem ser facilmente substituídas por, respectivamente:

- `assertThat().isEqualTo()`;
- `assertThat().isTrue()`;
- `assertThat().isFalse()`;
- `assertThat().isNull()`;
- `assertThat().isNotNull()`.

Conhecendo um pouquinho de inglês essa tarefa fica um pouco mais intuitiva.

Mas a migração começa a ficar um pouco mais interessante quando começamos a mexer com coleções e _streams_.

Uma das classes, `ConversationDAOIntegrationTest` continha métodos que verificavam o conteúdo de listas de conversas. Como podemos filtrar por mensagens não arquivadas, por exemplo, temos que verificar se determinada conversa está presente ou não numa listagem. Nosso teste estava assim:

```java
public class ConversationDAOIntegrationTest {

    @Test
    public void should_filter_active_conversations() {
        // Código omitido para manter a simplicidade...

        List<GroupParticipation> result = groups.getResults();

        assertThat(result, contains(activeParticipation));
        assertThat(result, not(contains(archivedParticipation)));
    }
}
```

Repare que estávamos usando Hamcrest aqui! Observe, também, que precisamos ficar encadeando chamadas de métodos para verificar se a lista não contém determinado elemento. Um pouco ruim, não? Com AssertJ, podemos fazer assim:

```java
public class ConversationDAOIntegrationTest {

    @Test
    public void should_filter_active_conversations() {
        // Código omitido para manter a simplicidade...

        List<GroupParticipation> result = groups.getResults();

        assertThat(result).contains(activeParticipation);
        assertThat(result).doesNotContain(archivedParticipation);
    }
}
```

Um pouco melhor, certo? Olhando um pouco mais o [Javadoc](http://joel-costigliola.github.io/assertj/core-8/api/index.html), vi que há outros métodos, um deles chamado de `containsExactly()`, que verifica se o grupo possui o elemento passado como parâmetro e nada mais, em ordem! Nesse caso não há problema, pois temos apenas um único parâmetro, caso tivéssemos mais de um e a ordem não importasse, poderíamos usar ainda o `containsExactlyInAnyOrder()`. Usando o método que acabamos de descobrir, temos o seguinte:

```java
public class ConversationDAOIntegrationTest {

    @Test
    public void should_filter_active_conversations() {
        // Código omitido para manter a simplicidade...

        List<GroupParticipation> result = groups.getResults();

        assertThat(result).containsExactly(activeParticipation);
    }
}
```