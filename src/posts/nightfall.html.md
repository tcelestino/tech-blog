---
title: 'Nightfall - Injetando dependências no Spark (Parte 1)'
date: 2016-11-07
category: back-end
layout: post
description: .
author: gadsc
tags:
  - spark
  - big data
  - dependency injection
  - java
  - kafka
---

## O início
Começamos a utilizar o _Spark_ no **Elo7** para extrair métricas em tempo real do site de forma assíncrona, evitando assim a necessidade de retirar métricas a partir do banco de dados utilizado pelo site, para isso enviamos eventos a partir do nosso **marketplace**, exemplo:

![Alt "Exemplo de arquitetura"](../images/nightfall-1.png)

Após a produção do eventos é necessário o desenvolvimento de consumidores, esses consumidores são os nossos `jobs` do _Spark_. Nossos `jobs` possuem várias _tasks_ que cada uma processa um tipo de evento de uma forma específica. Quando iniciamos o desenvolvimento dos nossos `jobs` o nosso código era mais ou menos assim:
- Job
```java
public class MyJob {

    private static final Logger LOGGER = LoggerFactory.getLogger(MyJob.class);

    public static void main(String[] args) {
    	MyJobConfiguration config = new MyJobConfiguration(args);
        JavaStreamingContext context = null;

        try {
            if (config.getSparkCheckpoint().isPresent()) {
                context = JavaStreamingContext.getOrCreate(
                        config.getSparkCheckpoint().get(),
                        (Function0<JavaStreamingContext>) () -> MyJob.createContext(config));
            } else {
                context = MyJob.createContext(config);
            }
            context.start();
            context.awaitTermination();
        } catch (Exception e) {
            LOGGER.error("Error while processing stream", e);
            throw e;
        } finally {
            if(context != null) {
                context.stop(true, true);
            }
        }
    }

    @SuppressWarnings("unchecked")
    private static JavaStreamingContext createContext(MyJobConfiguration config) {
        LOGGER.info("Creating new Java Streaming Context");

        // Sparks configurations
        SparkConf sparkConf = new SparkConf();
        sparkConf.set("spark.streaming.stopGracefullyOnShutdown", "true");
        sparkConf.set("spark.streaming.receiver.writeAheadLog.enable", config.isWriteAheadLogEnabled());

        // Spark stream configuration
        JavaStreamingContext context = new JavaStreamingContext(sparkConf, config.getBatchInterval());
        Optional<String> checkpoint = config.getSparkCheckpoint();

        Type type = new TypeToken<DataPoint<String>>() {}.getType();

        // Kafka connection
        JavaDStream<DataPoint<String>> stream = KafkaUtils.createStream(
                context,
                config.getKafkaZookeeper(),
                config.getKafkaGroupId(),
                config.getKafkaTopics(),
                StorageLevel.MEMORY_AND_DISK_SER())
                .map(item -> (DataPoint<String>) JsonParser.fromJson(item._2(), type)).filter(item -> item != null)
                .persist(StorageLevel.MEMORY_AND_DISK_SER());

        // DB Configs
        DataBaseConfiguration dbConfig = config.getDataBaseConfiguration();

        // Tasks that my job will run
        Arrays.asList(
                new MyTask(config)
        ).stream().forEach(processor -> processor.process(stream));

        // Load checkpoint
        checkpoint.ifPresent(context::checkpoint);

        return context;
    }
}
```

Dessa forma possuíamos uma "injeção de dependência" de uma forma "tosca" para as configs do banco e do job. Mas e se quiséssemos injetar outras classes? Para "injetar" outras classes seria necessário fazer algo assim:
```java
	@SuppressWarnings("unchecked")
    private static JavaStreamingContext createContext(MyJobConfiguration config) {
        LOGGER.info("Creating new Java Streaming Context");

        SparkConf sparkConf = new SparkConf();
        sparkConf.set("spark.streaming.stopGracefullyOnShutdown", "true");
        sparkConf.set("spark.streaming.receiver.writeAheadLog.enable", config.isWriteAheadLogEnabled());

        JavaStreamingContext context = new JavaStreamingContext(sparkConf, config.getBatchInterval());
        Optional<String> checkpoint = config.getSparkCheckpoint();

        Type type = new TypeToken<DataPoint<String>>() {}.getType();
        JavaDStream<DataPoint<String>> stream = KafkaUtils.createStream(
                context,
                config.getKafkaZookeeper(),
                config.getKafkaGroupId(),
                config.getKafkaTopics(),
                StorageLevel.MEMORY_AND_DISK_SER())
                .map(item -> (DataPoint<String>) JsonParser.fromJson(item._2(), type)).filter(item -> item != null)
                .persist(StorageLevel.MEMORY_AND_DISK_SER());

        DataBaseConfiguration dbConfig = config.getDataBaseConfiguration();
        MyFilter myFilter = new MyFilter(config);

        Arrays.asList(
                new MyTask(config),
                new OtherTask(config, myFilter)
        ).stream().forEach(processor -> processor.process(stream));

        checkpoint.ifPresent(context::checkpoint);

        return context;
    }
}
```

Ou seja para cada nova classe que nossa _task_ utilize precisamos instancia-la no `Job` um pouco ruim não acham?

## Simplificando as coisas
Para ajudar nosso problema de injeção de dependência criamos um projeto chamado **Nightfall** que utiliza [Netflix Governator](https://github.com/Netflix/governator/wiki) e [Google Guava](https://github.com/google/guava/wiki) para prover o contexto do **Spark**, injeção de dependência e configuração, com isso fica muito mais simples a criação de novos `jobs`, reutilizamos o código de criação do **Spark Context** e por fim podemos injetar as classes necessárias diretamente na _task_ evitando instanciar **todas** as classes que precisamos no `Job`, não precisamos mais controlar o ciclo de vida das mesmas, deixando que o `guava` cuide disso. Exemplo de como fica o código com **Nightfall**:
```java
@KafkaSimple
public class KafkaSimpleTest {

    public static void main(String[] args) {
        NightfallApplication.run(KafkaSimpleTest.class, args);
    }
}
```
Muito mais simples não? O código acima provê um `Job` **SparkStream** que utiliza uma conexão `Simple` com o `Kafka`.

## Criando um Stream
Agora que já sabemos o que nos motivou a criar o projeto **Nightfall** podemos ver como utiliza-lo para facilitar nossa vida :D
Digamos que temos um produtor de evento que envia um evento do tipo `ORDER_STARTED`
```json
{
	"type": "OrderStarted",
	"date": "2016-11-07T14:22:08.592-03:00",
	"payload": {
		"orderCreatedAt": "2016-11-02T18:00:50.798-03:00",
		"orderId": 1,
		"deviceFamily": "DESKTOP",
		"sellerName": "Vendedor 1",
		"buyerId": 3,
		"sellerId": 3,
		"products": [{
			"itemId": 1,
			"quantity": 3,
			"price": 500.00,
			"itemTitle": "Product 1"
		}],
		"access": "WEB_BROWSER",
		"totalPrice": 1500.00,
		"browser": "CHROME"
	}
}
```

Para consumir esse evento como um `Stream` ficaria mais ou menos assim:
```java
@KafkaSimple
public class OrderJob {

    public static void main(String[] args) {
        NightfallApplication.run(OrderJob.class, args);
    }
}

```
Após a criação do nosso job precisamos criar a task para processar a mensagem, utilizarei a implementação que usa `DataPoint` que é um contrato que criamos para padronizar a estrutura das mensagens:

```java
@Task
public class HelloWorldTask implements StreamTaskProcessor<DataPoint<String>> {
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = LoggerFactory.getLogger(HelloWorldTask.class);
	private static final String ORDER_STARTED = "OrderStarted";

	@Override
	public void process(JavaDStream<DataPoint<String>> dataPointsStream) {
		dataPointsStream
				.filter(dataPoint -> DataPointValidator.isValidForType(dataPoint, ORDER_STARTED))
				.foreachRDD(rdd -> {
					if (!rdd.isEmpty()) {
						rdd.foreachPartition(partition -> partition.forEachRemaining(this::log));
					}
				});
	}

	private void log(DataPoint<String> dataPoint) {
		LOGGER.info("######################## \n Order Started processed: {} \n ######################## ", dataPoint);
	}
}
```
Esse é um exemplo de task que processaria apenas os eventos de `OrderStarted`.

Agora que já sabemos como ele funciona e porque o criamos vamos à alguns exemplos, para qualquer exemplo de `Stream` precisaremos do _Kafka_, se você quer um exemplo de **Batch** [clique aqui]

- Siga as intruções do [Quick Start Kafka](https://kafka.apache.org/082/documentation.html#quickstart) para :
  1. Instalação e startup do mesmo. **OBS**: utilizar a versão 0.8.2 do _Kafka_.
  2. Crie um tópico no Kafka.
  3. Envar mensagens para o tópico criado.

Agora que possuímos o tópico criado podemos criar um stream para consumir as mensagens, para isso podemos utilizar a estrutura do `nightfall` e adicionar a task que criamos acima no sub-módulo `examples`.
Além de adicionar o `Job` e a `Task` precisaremos configurar o arquivo `nightfall.properties` também, ficaria mais ou menos assim:
```properties
# Kafka Consumer
kafka.brokers=localhost:9092
kafka.topics=${NOME_DO_TÓPICO_CRIADO}

# Kafka Offset
kafka.offset.persistent=false
kafka.cassandra.hosts=cassandra
kafka.cassandra.keyspace=kafka
kafka.cassandra.auto.migration=false
kafka.cassandra.user=
kafka.cassandra.password=
kafka.cassandra.datacenter=

# Stream Configurations
stream.batch.interval.ms=20000
stream.provider.converter=com.elo7.nightfall.di.providers.spark.stream.DataPointStreamContextConverter
stream.checkpoint.directory=/Users/developer/dev/tmp/examples/HelloWorldJob

# Monitoring config
reporter.statsd.host=localhost
reporter.statsd.port=8125
reporter.statsd.prefix=dev.spark
reporter.enabled=false
reporter.class=com.elo7.nightfall.di.providers.reporter.jmx.JMXReporterFactory
```

Após a configuração do arquivo localizado em `examples/src/main/resources` podemos adicionar executar o `Job` através do comando:
```shell
gradle 'jobs/example':run -PmainClass="${JOB_PACKAGE}.OrderJob"
```
É possível verificar a execução do job a partir dos logs, assim que ele terminar o `start` enviar o exemplo de `ORDER_STARTED`, se o job estiver correto será impresso o `json` nos logs do `job`, também poderá ser enviado outro tipo de evento e verificar que apenas o evento do tipo configurado na `Task` está sendo printado, se houver a necessidade de consumir um outro evento seria recomendado a criação de outra `Task`.

## Criando um Batch
Agora podemos criar nosso `Job`, `Task` e configurações para processar em `Batch` invés de `Stream` para isso precisaremos criar o seguinte job:
```java
@FileRDD
public class BatchOrderJob {

    public static void main(String[] args) {
        NightfallApplication.run(OrderJob.class, args);
    }
}

```
Precisamos criar a task também:
```java
@Task
public class BatchHelloWorldTask implements BatchTaskProcessor<DataPoint<String>> {
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = LoggerFactory.getLogger(HelloWorldTask.class);
	private static final String ORDER_STARTED = "OrderStarted";

	@Override
	public void process(JavaRDD<DataPoint<String>> dataPointsStream) {
		dataPointsStream
				.filter(dataPoint -> DataPointValidator.isValidForType(dataPoint, ORDER_STARTED))
				.foreachPartition(
					rdd.foreachPartition(partition -> partition.forEachRemaining(this::log))
				);
	}

	private void log(DataPoint<String> dataPoint) {
		LOGGER.info("######################## \n Order Started processed: {} \n ######################## ", dataPoint);
	}
}
```
Não podemos esquecer de criar as configurações que ficará assim:
```properties
# Batch Configuration
# File Configuration
file.s3.access.key=
file.s3.secret.key=
file.source=/tmp/nightfall

# Batch
batch.history.enabled=false

# Batch - Job History
batch.cassandra.hosts=cassandrar
batch.cassandra.port=9042
batch.cassandra.user=
batch.cassandra.password=
batch.cassandra.keyspace=kafka
batch.cassandra.datacenter=
batch.history.ttl.days=7
```
Por fim mas não menos importante precisaremos criar um arquivo compactado contendo os eventos para ser processado pelo `Batch`, pode ser um arquivo `txt` com os eventos e zipado, ele deve ser colocado no caminho especificado em `file.source`.
Para executar o `Batch` executamos o seguinte comando:
```shell
gradle 'jobs/example':run -PmainClass="${JOB_PACKAGE}.BatchOrderJob"
```
Podemos ver a impressão dos eventos que são do tipo `ORDER_STARTED` no log da aplicação :)

### É hora da revisão
Nesse post vimos o que nos motivou a criar o `Nightfall`, as configurações básicas para conseguir criar um `Stream` e um `Batch`. Por hoje é só pessoal mas iremos fazer uma série de posts para explicar mais usos do `Nigthfall`. Gostou? Se tiver algo para acrescentar/sugerir/duvida, deixe nos comentários e aguardem os próximos posts.