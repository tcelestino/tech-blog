---
title: 'Nightfall - Injetando dependências no Spark'
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


Começamos a utilizar o _Spark_ no **Elo7** para extrair métricas em tempo real do site de forma assíncrona, evitando assim a necessidade de retirar métricas a partir do banco de dados utilizado pelo site, para isso enviamos eventos a partir do nosso **marketplace**, exemplo:

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

#
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

1. Siga as intruções do [Quick Start Kafka](https://kafka.apache.org/082/documentation.html#quickstart) para instalação e startup do mesmo. **OBS**: utilizar a versão 0.8.2 do _Kafka_.












