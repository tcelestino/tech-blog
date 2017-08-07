---
date: 2015-11-16
category: back-end
layout: post
title: 'Optimização de de busca por faixas'
description: 
authors: [ftfarias]
tags:
  - algorítimos
  - back-end
  - tech-talk
---

#Procura de valores em faixas (ranges) de valores

Recentemente minha equipe fez algumas análises de fretes e um dos desafios foi classificar todos os fretes de 2016 nas faixas do correio. 

Os correios separam as regiões do Brasil em várias categorias: Locais, Divisa, Capitais, Interior. Cada um destes é subdividido em grupos, de 1 a 4 ou de 1 a 6

Para descobrir qual a categoria de um frete, temos que consultar diversas tabelas, em geral em um formato csv ou planilha:

```
AC,ACRELANDIA,69945-000,69949-999,AC,ACRELANDIA,69945-000,69949-999,L4
AC,ASSIS BRASIL,69935-000,69939-999,AC,ASSIS BRASIL,69935-000,69939-999,L4
AC,BRASILEIA,69932-000,69933-999,AC,BRASILEIA,69932-000,69933-999,L4
...
SP,SOROCABA,18000-001,18109-999,SP,VOTORANTIM,18110-001,18119-999,L4
SP,SUD MENNUCCI,15360-000,15369-999,SP,SUD MENNUCCI,15360-000,15369-999,L4
SP,SUMARE,13170-001,13182-999,MG,EXTREMA,37640-000,37649-999,L3

```

Esta tabelas tem entre 15 mil e 25 mil entradas, cada entrada com um faixa de CEPs de entrada e uma faixa de CEPs de saída. 

O problem foi processar todos do dados de 2016 e classificar todos os fretes nas faixas acima. Estamos falando de alguns milhões de pedidos...

### Os dados

O carregamento dos dados é trivial, diretamento do CSV:

```
# faixas_ceps_divisa é um dicionário, com as faixas como chave e o código como valor
faixas_ceps_divisa = {}
with open('divisas.csv','r', encoding='utf_8') as input_file:
    next(input_file)
    next(input_file)
    input_csv = csv.reader(input_file, delimiter=',', quotechar='"')
    for i,t in enumerate(input_csv):
#         if i > 10:
#             break
#         print(t)
        f1_inicio = int(t[2].replace('-',''))
        f1_fim = int(t[3].replace('-',''))
        f2_inicio = int(t[6].replace('-',''))
        f2_fim = int(t[7].replace('-',''))
        faixa = t[8]
        faixas_ceps_divisa[(f1_inicio,f1_fim,f2_inicio,f2_fim)] = faixa  
```

```
print(len(faixas_ceps_divisa))
24304
```

```
print(list(faixas_ceps_divisa)[:10])
[(75430000, 75439999, 70000001, 72799999), (19800001, 19819999, 87110001, 87119999), (86730000, 86749999, 12200001, 12249999), (87560000, 87564999, 12630000, 12689999), (37890000, 37899999, 17200001, 17229999), (37472000, 37473999, 7400001, 7499999), (87780000, 87789999, 11600000, 11629999), (27300001, 27399999, 37200000, 37209999), (87380000, 87389999, 13160000, 13164999), (89250001, 89269999, 83000001, 83189999)]
```

```
faixas_ceps_divisa[(75430000, 75439999, 70000001, 72799999)]
'E4'
```

### Força bruta

A primeira abordagem foi simples: carregamos as tabelas em memória e faziamos uma busca por força bruta:

```
def is_cep_divisa(cep1,cep2):
    r = [y for x,y in faixas_ceps_divisa.items() if x[0]<= cep1 <=x[1] and x[2]<= cep2 <=x[3]] 
    if len(r) == 1:
            return r[0]
    else:
        return None
​
​
assert is_cep_divisa(57935000,53520001) == 'E4'
assert is_cep_divisa(32000000,12345001) == None
```

```
%timeit is_cep_divisa(57935000,53520001)
7.66 ms ± 539 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
```

```
%timeit is_cep_divisa(32000000,12345001)
6.37 ms ± 602 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
```

Como vemos, a performance não é tão ruim para um caso, mas estamos interando a lista inteira. Poderiamos parar assim que encontramos um faixa de frete


### Força bruta 2

```
def is_cep_divisa(cep1,cep2):
    for x,v in faixas_ceps_divisa.items():
        if x[0]<= cep1 <=x[1] and x[2]<= cep2 <=x[3]:
            return v
    else:
        return None


assert is_cep_divisa(57935000,53520001) == 'E4'
assert is_cep_divisa(32000000,12345001) == None
```

```
%timeit is_cep_divisa(57935000,53520001)
3.66 ms ± 183 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
```

```
%timeit is_cep_divisa(32000000,12345001)
5.83 ms ± 245 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
```

Como vemos, a performance melhora um pouco, mas depende muito da posição na lista e vamos processar milhões de registros. 

Quando testamos esta versão, o tempo de processamento ficou em ~ 10 horas.

### Procurando uma solução

Após 2 horas procurando por alguma solução para o problema, não achamos nenhum solução pronta. Mas um tipo de problema similar me chamou a atenção: In


