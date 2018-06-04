---
date: 2016-10-10
category: back-end
tags:
  - java
  - spring boot
  - spring cloud config
  - micro serviços
  - infraestrutura

authors: [denis.oliveira]
layout: post
title: Properties dinâmicos com Spring Cloud Config
description: Spring Cloud Config permite que suas configs sejam atualizadas dinamicamente sem a necessidade de restart da aplicação, para um Cluster / ELB de máquinas ou apenas uma máquina. Isso possibilita mudanças de configuração sejam elas técnicas ou de negócio quase que instantaneamente.

---

## O problema existente hoje...

Bom, primeiramente posso dizer que pensei nesse tema, pois já presenciei algumas vezes problemas em ambiente de produção, devido a properties com **valores incorretos** ou mesmo **falta** deles por esquecimento.

Agora imagina isso ocorrendo, no final de um deploy no ambiente de produção, e pior, com os mesmos (properties) dentro da aplicação. Um novo deploy teria que ser feito em N máquinas. Caso o arquivo de properties estivesse fora da aplicação, externalizado, o mesmo teria que ser alterado em todas as máquinas e exigiria um stop e start de todas elas ou então um redeploy teria que ser executado.

Mas não apenas isso, poderia ter algum parâmetro relacionado ao negócio, como por exemplo, um valor X cobrado no frete, e que repentinamente teria que ser mudado e novamente não seria fácil de fazer.

Pensando em resolver esse problema, eis que surge o Spring Cloud Config. A idéia dele é simples. Um repositório de properties de forma centralizada e versionada, como por exemplo GitHub, GitLabs ou mesmo um arquivo local de properties (nesse último caso deve estar gerenciado pelo git), e que, ao mudar um ou mais parâmetros do arquivo, executando um commit e posteriormente um push, os mesmos fossem alterados dinamicamente (através de uma URI HTTP POST) na minha aplicação sem restart ou mesmo deploy e em todas as máquinas.

## Como funciona de forma geral

Abaixo a imagem ilustra de forma geral como o spring Cloud funciona.

![Funcionamento Spring Cloud](../images/spring-cloud-config-1.jpg)

Inicialmente temos o Config Server, que basicamente lê as configurações contidas em algum lugar, seja um arquivo (gerenciado pelo git), do GitHub ou GitLab e as disponibiliza para os microserviços ou outros tipos de aplicações. Qualquer mudança feita em um desses arquivos (commit), automaticamente fica disponível as aplicações clientes (microserviços). Porém para que o microserviço de fato use essa alteração sem restart é necesssário fazer uma chamada http post como veremos mais a frente.

## Vamos ao que interesse, ou seja, código

Chega de falatório e vamos ao código.

Primeiramente crie seu repositório de preferência no GitHub, seguindo a seguinte regra. O nome do seu arquivo de properties precisa
coincidir com o nome da aplicação cliente, setado normalmente no aplication.properties ou bootstrap.properties como “spring.application.name”.
Por exemplo:

```properties
spring.application.name=hello-world
```

Nesse exemplo, meu arquivo irá chamar-se hello-world.properties e realize o commit.

---

## Criando o Config Server

Uma vez criado o repositório, precisamos criar uma aplicação Spring Boot que será o Config Server.

### Usando o Spring Initializr

O ideal é que o Config Server seja um projeto Spring Boot independente de todas as outras aplicações existentes, visto que ele será responsável por gerenciar a configurações de todas elas.

Caso use o [Spring INITIALIZR](https://start.spring.io/) para criar um novo projeto spring, basta adicionar a opção **Config Server** que ele
irá gerar o projeto já configurado.

![Tela Spring Initializr](../images/spring-cloud-config-2.png)

### Adicionando manualmente em um projeto Spring já existente

Caso opte por essa segunda opção, basta adicionar as seguintes dependências. Essas dependências, servem tanto para o Config Server como para o client.

No Maven

```xml
   <dependencies>
       <dependency>
           <groupId>org.springframework.cloud</groupId>
           <artifactId>spring-cloud-config-server</artifactId>
       </dependency>
   </dependencies>

   <dependencyManagement>
       <dependencies>
           <dependency>
               <groupId>org.springframework.cloud</groupId>
               <artifactId>spring-cloud-dependencies</artifactId>
               <version>Finchley.M8</version>
               <type>pom</type>
               <scope>import</scope>
           </dependency>
       </dependencies>
   </dependencyManagement>

   ...
   <repositories>
       <repository>
           <id>spring-milestones</id>
           <name>Spring Milestones</name>
           <url>https://repo.spring.io/libs-milestone</url>
           <snapshots>
               <enabled>false</enabled>
           </snapshots>
       </repository>
   </repositories>
```

No Gradle

```groovy
dependencies {
   compile('org.springframework.cloud:spring-cloud-config-server')
}

dependencyManagement {
   imports {
       mavenBom "org.springframework.cloud:spring-cloud-dependencies:Finchley.M8"
   }
}

repositories {
   maven {
       url 'https://repo.spring.io/libs-milestone'
   }
}
```

Uma vez configurado as dependências, vamos criar o config server. Basta adicionar **@EnableConfigServer** em uma aplicação Spring Boot e pronto um config server está criado.

```java
@EnableConfigServer
@SpringBootApplication
public class ConfigServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ConfigServiceApplication.class, args);
    }
}
```

Feito isso precisamos configurar onde o config server irá buscar seus properties. Nesse caso irei no application.properties dele e setarei a propriedade com o local do meu repositório.

```properties
spring.cloud.config.server.git.uri=https://github.com/denis-schimidt/dynamic-configs
```

Dessa forma agora ele irá buscar através na URI  https://github.com/denis-schimidt/dynamic-configs/hello-world.properties os properties e a cada commit e push realizado, automaticamente detectará isso e disponibilizará as aplicações clientes.

Nesse momento se uma aplicação cliente fizesse stop e start, ela já teria seus properties atualizados. Porém a idéia é poder fazer isso sem stop e start, como veremos mais a frente.

Outro ponto importante, é que o config server sobrescreve todos os properties definidos na aplicação cliente (application.properties) e que também estejam no arquivo de properties no repositório, até mesmo server.servlet.context-path e server.port. Portanto vale sempre o que está no repositório.

É possível verificar seus properties carregados via http get (browser ou curl) pela URI ```http://localhost:<port>/<client-aplication-name>/<profile>```, como mostrado abaixo:

![Acessando Configs via CURL](../images/spring-cloud-config-3.png)


## Configurando o Config Server no client

Assim, finalmente chegamos a aplicação cliente, que utiliza os properties. As dependências são as mesmas mostradas acima.

A anotação **@RefreshScope** propicia essa atualização. Nesse caso o valor na property “message” será injetado do repositório e caso não encontre ou o Config server esteja fora o “Hello default” será usado.

```java
@RefreshScope
@RestController
public class HelloWorldController {
    @Value("${message:Hello default}")
    private String message;

    @GetMapping("/message")
    String getMessage() {
        return this.message;
    }
}
```

Pra atualizarmos o cliente sem stop start usamos o seguinte comando e ele responderá quais properties foram atualizados, como exibido abaixo:

```bash
### Chamada http post ao Actuator da aplicação cliente
curl -X POST localhost:8080/<client-application-context>/actuator/refresh -H "Content-Type: application/json"
```

```bash
### Resposta da chamada hhtp post, indicando o que foi atualizado
["config.client.version", "message"]
```

Uma vez feito isso, basta dar o famoso F5 na página da aplicação cliente e tudo estará atualizado dinamicamente.

## Testes Integrados

Podemos para finalizar, garantirmos com testes de integração, usando Spring Test, o funcionamento do mesmo, como mostra-se no exemplo a seguir. No teste ele inicialmente usa um valor previamente definido na aplicação cliente e através do TestPropertyValues, ConfigurableEnviroment e ContextRefresher pode-se validar se o valor de fato está sendo atualizado.

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class ConfigClientApplicationTest {

    @Autowired
    private ConfigurableEnvironment environment;

    @Autowired
    private HelloWorldController controller;

    @Autowired
    private ContextRefresher refresher;

    @Test
    public void contextLoads() {
        assertThat(controller.getMessage()).isNotEqualTo("Hello test");
        TestPropertyValues
            .of("message:Hello test")
            .applyTo(environment);
        assertThat(controller.getMessage()).isNotEqualTo("Hello test");
        refresher.refresh();
        assertThat(controller.getMessage()).isEqualTo("Hello test");
    }

}
```

## Conclusão

Podemos ver, nesse post de forma geral, como termos configurações dinâmicas usando o Spring Cloud Config em conjunto com aplicações Spring Boot e seus benefícios.

Caso queiram ver o código, o mesmo está disponibilizado no github [spring-cloud-config](https://github.com/denis-schimidt/spring-cloud-config/) e suas
[configurações](https://github.com/denis-schimidt/dynamic-configs)

Bom amigos é isso. Caso tenham dúvidas, sugestões estamos a disposição. Até a próxima.
