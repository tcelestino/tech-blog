---
date: 2017-01-30
category: back-end
tags:
  - sql
  - optimization
author: victorkendy
layout: post
title: Otimização de queries lentas em bancos relacionais
description: O banco relacional é uma das ferramentas mais utilizadas para o armazenamento de dados em aplicações, porém sem o devido cuidado, a performance dessas ferramentas pode sofrer caso os dados sejam inseridos sem o devido cuidado. Nesse post teremos uma introdução prática aos índices como uma forma de otimização de buscas.
---

Quando começamos a desenvolver um novo sistema, a performance do banco de dados parece não ser um problema muito importante,
mas com o aumento do número de usuários e, consequentemente, dos dados que precisam ser armazenados, queries que executavam
em milisegundos passam a demorar segundos ou até mesmo minutos para serem executadas. Para ilustrar esse problema, vamos
utilizar um exemplo simples.

Imagine que precisamos desenvolver um cadastro simples de compradores para um comércio eletrônico, nesse caso, poderíamos
utilizar a tabela gerada pelo seguinte comando (Todos os exemplos desse artigo serão feitos no mysql, mas os conceitos
apresentados funcionam para qualquer banco relacional):

```sql
CREATE TABLE usuario (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  nome varchar(100) NOT NULL,
  data_nascimento datetime NOT NULL,
  PRIMARY KEY(id)
) ENGINE=InnoDB;
```
Precisamos listar os 20 primeiros usuários que começam, por exemplo, com a letra `A` ordenados pela data de nascimento para uma campanha de marketing que
será realizada pelo site, esse problema pode ser resolvido pela seguinte sql:
```sql
SELECT * FROM usuario WHERE nome LIKE 'A%' ORDER BY data_nascimento limit 20;
```
Ao executarmos esse comando no banco de dados de desenvolvimento, que contém apenas 100 usuários, vimos que o tempo de execução é de 1ms e,
portanto, colocamos essa query em produção. Mas assim que ela começa a ser utilizada com os dados reais, vemos que o estado do banco de dados
passa a deteriorar: A CPU fica perto de 100% e o banco não para de fazer leituras do disco.

## O comando EXPLAIN

Para descobrirmos o que aconteceu, podemos pedir para o banco de dados mostrar o plano de execução da query, uma estimativa do que vai ser feito
quando a query for executada com os dados atuais, utilizando o comando [EXPLAIN](https://dev.mysql.com/doc/refman/5.7/en/explain.html):

```sql
EXPLAIN SELECT * FROM usuario WHERE nome LIKE 'A%' ORDER BY data_nascimento limit 20;
```
Essa é a saída do comando:

```
+----+-------------+---------+------+---------------+------+---------+------+------+-----------------------------+
| id | select_type | table   | type | possible_keys | key  | key_len | ref  | rows | Extra                       |
+----+-------------+---------+------+---------------+------+---------+------+------+-----------------------------+
|  1 | SIMPLE      | usuario | ALL  | NULL          | NULL | NULL    | NULL |  100 | Using where; Using filesort |
+----+-------------+---------+------+---------------+------+---------+------+------+-----------------------------+
```
Nessa saída temos duas colunas que ajudam a explicar a performance da query: `type` e `rows`.

A coluna `type` indica o tipo de query que será executada, no caso ALL significa que todas as linhas da tabela precisam ser verificadas para produzir
o resultado (esse comportamento é conhecido como *full table scan*). No caso em que a tabela é pequena, um full table scan não afeta a performance do sistema,
mas assim que a quantidade de informações cresce, o banco de dados é forçado a ler possivelmente milhões de registros para gerar o resultado da busca.

Já `rows` indica uma estimativa para o número de linhas que serão lidas pelo banco para atender a query. É importante ressaltar que o número é apenas
uma estimativa, que pode ser maior ou menor do que o número de linhas que serão de fato lidas quando a query for executada. Como o type da query é `ALL`,
`rows` indicará o número aproximado de linhas da tabela usuario.

Pelas informações disponibilizadas pelo `EXPLAIN`, podemos ver que a performance da query só vai piorar conforme o número de registros na tabela aumenta.

## Utilizando índices para melhorar a performance

Agora que sabemos que o problema de performance da query é causado pelo full table scan em uma tabela muito grande, podemos otimizar a query utilizando índices.

Existem dois principais tipos de índice mais utilizados pelos bancos relacionais:

 - Árvores B+ (BTREE): Esse índice mantém os dados indexados em orderm crescente, dessa forma ele pode ser utilizado em buscas que contenham condições de igualdades
 ou intervalos (buscas utilizando >=, >, <=, < ou BETWEEN).

 - Hash: Esse índice mantém os dados em uma tabela de hash, portanto ele consegue ajudar apenas em buscas de igualdade.

No MySQL, dependendo da configuração, o único tipo de índice disponível é o BTREE que pode ser criado utilizando o seguinte comando:

```sql
CREATE INDEX nome_do_indice ON nome_da_tabela (coluna_indexada1,coluna_indexada2,...);
```

Como queremos otimizar uma busca na coluna `nome` da tabela `usuario`, podemos criar o seguinte índice:

```sql
CREATE INDEX usuario_nome ON usuario (nome);
```
Esse comando criará um índice do tipo BTREE (padrão) na tabela usuario. Após a criação do índice, podemos executar novamente o explain:

``` TODO
+----+-------------+---------+------+---------------+--------------+---------+-------+------+-----------------------------+
| id | select_type | table   | type | possible_keys | key          | key_len | ref   | rows | Extra                       |
+----+-------------+---------+------+---------------+--------------+---------+-------+------+-----------------------------+
|  1 | SIMPLE      | usuario | ref  | usuario_nome  | usuario_nome | 102     | const |    5 | Using where; Using filesort |
+----+-------------+---------+------+---------------+--------------+---------+-------+------+-----------------------------+
```

Repare que dessa vez o tipo de query mudou de `ALL` para `ref`, o que indica que o banco de dados não está mais fazendo um full table
scan, além disso, agora temos mais duas colunas interessantes:

 - possible_keys: Indica quais são os possíveis índices que o banco pode usar para realizar a busca.

 - key: Indica qual é a chave que será de fato utilizada na execução da busca, ou NULL para full table scan.

Observe também que o valor da coluna `rows` agora é uma fração número de linhas da tabela, o que indica que agora o banco precisa ler menos
registros para gerar o resultado final.

## Utilizando índices para a ordenação

Com a criação do índice, a query passou a scannear apenas as linhas que contém usuários que começam com a letra 'A', mas se o banco tiver muitos usuários,
mesmo essa busca menor ainda vai ser pesada, pois o resultado ainda precisa ser ordenado. Podemos verificar que o MySQL fará a ordenação da query pelo valor
`Using filesort` da coluna `Extra` do comando `EXPLAIN`.

Assim como as condições do `WHERE`, a ordenação também pode ser otimizada através de índices. Como os dados do índice do tipo BTREE são mantidos ordenados,
essa ordenação pode ser utilizada pelo banco se as colunas do `order by` estiverem presentes no índice. No exemplo desse post, a ordenação é feita
pela coluna `data_nascimento`, então o índice precisa conter as colunas nome (para a condição do WHERE) e data_nascimento (para a ordenação).

```sql
DROP INDEX usuario_nome ON usuario;
CREATE INDEX usuario_nome ON usuario (nome, data_nascimento);
```
Depois dessa modificação, podemos verificar que a saída do EXPLAIN agora não contém o `Using filesort`, ou seja, o banco não precisa mais calcular a ordenação
dos dados, ele pode usar a ordenação do índice.

Repare que as colunas do índice utilizado no exemplo foram declaradas em uma ordem específica `nome` seguido por `data_nascimento`, essa ordem das colunas do índice
é importante, pois dependendo da ordem, o índice pode ou não ser utilizado. Para ilustrar isso, vamos recriar o índice invertendo a ordem dos campos:
```sql
DROP INDEX usuario_nome ON usuario;
CREATE INDEX usuario_nome ON usuario (data_nascimento, nome);
```
Ao executarmos o EXPLAIN nessa query, podemos ver que o índice agora não é mais utilizado, o banco volta a fazer o full table scan. Isso acontece pois, como mencionado
anteriormente, os dados do índice são guardados ordenados, então teremos uma ordenação primária pela data de nascimento e uma secundária pelo nome. Como usuários que tem
nome começando pela letra A podem nascer em qualquer momento do ano, para fazer a query o banco de dados teria que ler o índice inteiro (equivalente ao full table scan).
Como uma regra geral, os índices devem ser criados colocando-se primeiro os atributos utilizados para filtros e depois os da ordenação.

## Cuidados com índices

A utilização de índices tem o potencial de melhorar muito a performance de uma aplicação que depende de um banco de dados relacional, mas alguns cuidados devem ser tomados
em seu uso:

 - Índices fazem com que inserts e updates na tabela indexada fiquem mais lentos. Como o banco é obrigado a manter uma estrututra de dados extra com uma parte dos dados inseridos,
 todo insert ou update precisa também atualizar os dados do índice.

 - Índices ocupam espaço em disco e na memória do banco de dados, portanto crie-os de acordo com a necessidade da aplicação. Não adianta tentar criar índices para todas as
 combinações possíveis de campos da tabela.

 - Utilize os campos mais a esquerda na declaração do índice em suas queries. O índice criado como exemplo nesse post, `CREATE INDEX usuario_nome ON usuario (nome, data_nascimento)`,
 pode ser utilizado para otimizar queries que filtram apenas `nome` ou `nome` e `data_nascimento`, mas se tentarmos filtrar apenas por `data_nascimento`, o banco fará um full table scan.

 - O índice só é usado para ordenação quando todos os campos mais a esquerda na declaração do índice são utilizados como filtros na query. No exemplo, o índice pode ser utilizado em
 ordenações por `nome` em qualquer caso, ou por data_nascimento se o nome for utilizado no filtro.

 - No MySQL, o índice não é utilizado em buscas em que a condição no campo do índice é <> (diferente). Por exemplo, se a condição fosse `nome <> 'Alberto'` o índice não seria utilizado.
