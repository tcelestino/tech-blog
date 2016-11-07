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
---

##
Começamos a utilizar o _Spark_ no **Elo7** para extrair métricas em tempo real do site de forma assíncrona, evitando assim a necessidade de retirar métricas a partir do banco utilizado pelo site, para isso enviamos eventos a partir do nosso **marketplace**, exemplo:

Após a produção do eventos é necessário o desenvolvimento de consumidores, esses consumidores são os nossos `jobs` do _Spark_. Nossos `jobs` possuem `N` _tasks_. Quando iniciamos o desenvolvimento dos nossos `jobs` o nosso código era mais ou menos assim:
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

Dessa forma possuíamos uma "injeção de dependência" de uma forma "tosca" para as configs do banco. Mas e se quiséssemos injetar outras classes? Para injetar outras classes seria necessário fazer algo assim:
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

#
Para ajudar nosso problema de injeção de dependência criamos um projeto chamado **Nightfall** que utiliza [Netflix Governator](https://github.com/Netflix/governator/wiki) e [Google Guava](https://github.com/google/guava/wiki) para prover a injeção, com isso podemos injetar as classes necessárias diretamente na _task_ evitando instanciar **todas** as classes que precisamos no `Job`. Além disso não precisamos mais controlar o ciclo de vida das mesmas, deixando que o `guava` cuide disso. Exemplo de como fica o código com **Nightfall**:
```java
@KafkaSimple
public class KafkaSimpleTest {

    public static void main(String[] args) {
        NightfallApplication.run(KafkaSimpleIntegrationTest.class, args);
    }
}
```
Muito mais simples não?

