---
date: 2017-02-01
category: back-end
layout: post
title: Subindo uma API REST em Clojure
description: 
author: ericdallo
tags:
  - API
  - REST
  - clojure
  - back-end
---

## Motivação

com isso em mente, vamos subir uma API com um CRUD de posts de um blog, [clojure7](https://github.com/ericdallo/clojure7), totalmente restful.

Para quem programa ou já programou em clojure, deve ter esbarrado no [Leiningen](https://leiningen.org). Ele é um gerenciador de dependências e tasks, assim como o *gradle* e *maven* para o "javeiros", ele pode ser usado para construir a hierarquia de seu novo projeto, rodar sua aplicação com plugins e entre outros.
Vamos utilizar um plugin dele chamado **compojure**, que irá criar a hierarquia e arquivos básicos para nossa aplicação.

## Setup

[Compojure](https://github.com/weavejester/compojure) é uma biblioteca (não um framework) baseado no [Ring](https://github.com/ring-clojure/ring), uma outra biblioteca que consegue manipular a **request** e **response**, parecido com a especificação **Servlet** do java. A diferença é que o compojure permite você gerenciar as rotas da sua aplicação mais facilmente, para os rubistas, algo semelhante com o `routes.rb` do *Rails*.

Caso tenha dúvidas de como o _ring_ funciona, sugiro a leitura dos conceitos do mesmo, [aqui](https://github.com/ring-clojure/ring/wiki/Concepts)

Vamos começar criando o projeto a partir do *Leiningen*:

```bash
lein new compojure clojure7
``` 

Ao rodar este comando, o *lein* irá criar alguns arquivos para nós:

* __project.clj__ - arquivo de configrução do projeto, parecido com o `build.gradle` ou `pom.xml`
* __resources/__  - pasta onde serão guardados arquivos como assets, templates html e migrações de banco
* __src/__        - pasta contendo todo o código clojure da aplicação
* __test/__       - pasta contendo os testes da aplicação


Vamos adicionar algumas dependencias no arquivo `project.clj`

* [ring-json](https://github.com/ring-clojure/ring-json) - Permite lidarmos com requisições que contenham _json_ e facilita as respostas da aplicação em _json_.
* [korma](http://sqlkorma.com/) - Talvez uma das minhas _libs_ favoritas em clojure, um [ORM](https://en.wikipedia.org/wiki/Object-relational_mapping) que mapeia nossos modelos clojure em modelos relacionais no banco de dados.
* [mysql](https://github.com/clojure/java.jdbc) - Driver do mysql para clojure.

As dependencias da aplicação ficarão assim:

```clojure
:dependencies [[org.clojure/clojure "1.8.0"]
               [compojure "1.5.2"]
               [ring/ring-defaults "0.2.1"]
               [ring/ring-json "0.4.0"]
               [korma "0.4.3"]
               [mysql/mysql-connector-java "5.1.6"]]

```

Ainda neste mesmo arquivo, podemos encontrar a configuração do `ring`: 

```clojure
:ring {:handler clojure7.handler/app}
```

A linha acima mostra que temos um **handler**, um arquivo que deverá lidar com cada roda da aplicação, e o namespace apontando para o mesmo.

Ao abrirmos o `src/clojure7/handler.clj`, vamos alterar o _bind_ dos parâmetros do _ring_ para _json_ e dizer ao _middleware_ dele que após passar pela nossa rota, transformar os dados em _json_ para a resposta.

```clojure
(ns clojure7.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.json :refer [wrap-json-response wrap-json-body]]))

(def app
  (-> all-routes
      wrap-json-response
      wrap-json-body))
```

Neste mesmo arquivo, teremos as definições de rotas:
```
(defroutes all-routes
  (GET "/" [] "Hello World")
  (route/not-found "Not Found"))
```

Com o Compojure, temos a definição da nossa rota com o `defroutes`, onde podemos passar uma lista de rotas para ele. Podemos ver que já temos uma rota *GET* para a raiz da aplicação que retornará uma _String_ no corpo da resposta, e outra que caso não encontre nenhuma rota definida deste método, exiba a página de 404, "Not Found".

## Banco de dados

Assim como no *Ruby on Rails*, podemos ter migrações de banco de dados, neste post não irei demonstrar, talvez em um próximo, mas caso queira aprender, sugiro o uso do [migratus](https://github.com/yogthos/migratus), outra _lib_ excelente.
Criaremos a nossa tabela `post` no nosso banco de dados mysql:

```sql
CREATE TABLE post (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `category` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
);
```
Vamos criar o arquivo `src/clojure7/db.clj` contendo as configurações do banco de dados:

```clojure
(ns clojure7.db
  (:use korma.db))

  (defdb db (mysql
            { :classname "com.mysql.jdbc.Driver"
              :subprotocol "mysql"
              :subname "//localhost/clojure7"
              :user "root"
              :password ""}))
```

## Recursos

Se tratando de _REST_, nosso modelo `post` é um recurso, então vamos mapea-lo no arquivo `src/clojure7/post/post.clj`:

```clojure
(ns clojure7.post.post
  (:require [korma.db :refer :all]
            [korma.core :refer :all]
            [clojure7.db :refer :all]))

(defentity post)
```

Podemos observar que com o `defentity` transformamos o objeto `posts` em uma entidade gerenciada pelo **korma**, agora podemos manipular os dados da tabela através do clojure, então vamos criar os métodos para cada operação do _CRUD_:

```clojure
(defn find-all []
  (select post))

(defn find-by-id [id]  
    (select post
      (where {:id id})
      (limit 1)))

(defn create [name category]
  (insert post
    (values {:name name :category category})))

(defn update-by-id [id name category]
  (update post
    (set-fields {:name name :category category})
    (where {:id id})))

(defn delete-by-id [id]
  (delete post
    (where {:id id})))
```


Criaremos agora as rotas para alterar nosso recurso `post`:

`src/clojure7/handler.clj`
```clojure
(defroutes all-routes
  (GET "/posts" [] 
    (post/find-all))
  (POST "/posts" req
    (let [name (get-in req [:body "name"])
          category (get-in req [:body "category"])]
          (post/create name category)))
  (GET "/posts/:id" [id] 
    (post/find-by-id id))
  (PUT "/posts/:id" req
    (let [id (read-string (get-in req [:params :id]))
          name (get-in req [:body "name"])
          category (get-in req [:body "category"])]
          (post/update-by-id id name category)
          (post/find-by-id id)))
  (DELETE "/posts/:id" [id] 
    (post/delete-by-id id)
    (str "Deleted post " id))
  (route/not-found "Not Found"))
```
## Subindo a aplicação

Podemos agora subir nossa aplicação com o seguinte comando ``lein ring server``, por padrão ele irá subir na porta 3000.

Criando um `post`:

```bash
curl -X POST localhost:3000/posts -H "Content-Type: application/json" -d '{"name":"Clojure com o Simbal", "category":"cool-posts"}'
```

Editando um `post`:

```bash
curl -X PUT localhost:3000/posts/1 -H "Content-Type: application/json" -d '{"name":"Clojure com o Greg", "category":"other-posts"}'
```

Encontrando um `post`:

```bash
curl -X GET localhost:3000/posts/1
```

Removendo um `post`:

```bash
curl -X DELETE localhost:3000/posts/1
```

Gostou do post? tem alguma dúvida? alguma crítica? Comenta aqui em baixo :)
Espero que tenha despertardo, para quem nâo conhece, aquela curiosidade que todo *dev* tem quando descobre que existe outra maneira de subir uma API REST nos seus novos projetos :D