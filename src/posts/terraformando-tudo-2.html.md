---
title: Terraformando tudo - parte 2
date: 2017-01-30
category: devops
layout: post
description: Segundo post da série 'Terraformando Tudo', que conta a nossa tragetória em busca da codificação da nossa infraestrutura. Nesse post contamos o que fizemos para mitigar possíveis desastres e como controlamos N desenvolvedores mexendo em N Terraform configurations. Vamos lá?
author: lucasvasconcelos
tags:
  - devops
  - terraform
  - IaC
  - Infrastructure as Code
  - infra
---

Olá! 

Estamos aqui novamente para dar continuidade na série de *posts* *Terraformando Tudo*. Nesse segundo *post* da série, vamos falar mais um pouco sobre os códigos do [Terraform](https://terraform.io), ou *Terraform configuration* (como o próprio projeto chama uma porção de código executável do Terraform). Também vamos mostrar como o Terraform controla o estado de seus *resources* e como mitigamos as chances de desastres com muitas pessoas mexendo no nosso repositório de *configurations*.

## Terraform configurations

Como a própria página do projeto sugere, um código do Terraform, independente de tamanho, desde que seja executável, é chamado de *Terraform configuration*. Seguindo essa sugestão, nessa série de *posts* vamos chamar um código do Terraform de *configuration* (apesar de internamente chamarmos de 'módulo', pra facilitar :P).

Conforme foi citado no [primeiro post](http://engenharia.elo7.com.br/terraformando-tudo-1/), o Terraform utiliza uma linguagem proprietária chamada HCL (*Hashicorp Configuration Language*). A seguir, temos um exemplo de *configuration* mínimo que pode ser executado com o Terraform. Alguns detalhes estão em formato de comentário no código: 

`main.tf`
```python
# Define o provider que será utilizado e os parâmetros necessários
# No caso, usaremos a AWS na region us-east-1 e as credenciais, como não foram 
# explicitadas, irão ser obtidas de varáveis de ambiente ou do arquivo credentials do awscli
# (como default na maioria das bibliotecas da AWS)
provider "aws" {
  region = "us-east-1"
}

# Aqui estamos utilizando a funcionalidade de data-sources do Terraform, que traz 
# informações de recursos já existentes. Nesse caso, estamos obtendo informações 
# da versão mais recente do CoreOS stable da AWS
data "aws_ami" "coreos-stable-latest" {
  most_recent = true

  filter {
    name = "name"
    values = ["CoreOS-stable*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["595879546273"]
}

# Criando um security-group para a instância
resource "aws_security_group" "elo7-sg-example" {
  name = "elo7-example"
  description = "SG de exemplo para o post no Blog"
  vpc_id = "vpc-123456"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port       = "22"
      to_port         = "22"
      protocol        = "tcp"
      cidr_blocks = [ "192.168.10.0/21" ] 
  }

}


# Aqui, estamos definindo uma instância no EC2
resource "aws_instance" "elo7-ec2-example" {
  
  # Estamos referenciando o ID da AMI que foi setado no bloco anterior
  ami = "${data.aws_ami.coreos-stable-latest.id}"
  instance_type = "t2.small"
  key_name = "example-key"
  subnet_id = "subnet-123456"

  # Estamos referenciando o ID do security-group criado nesse mesmo arquivo
  # O Terraform cuidará de organizar as interdependências
  vpc_security_group_ids = [ "${aws_security_group.elo7-sg-example.id}" ]

  root_block_device {
    volume_type = "gp2"
    volume_size = "15"
    delete_on_termination = true
  }

  tags {
    "Name" = "elo7-ec2-example"
  }
}
```

Com o código acima, que pode ser chamado de *configuration*, conseguimos criar um *Security Group* e uma instância na região *us-east-1* da AWS. Podemos ver que o *pattern* para criação de recursos com o Terraform é sempre esse: `resource "tipo_do_resource" "nome_do_resource"`. 

Um outro detalhe é que, para ajudar na organização, poderíamos separar a criação desses *resources* em arquivos separados dentro do mesmo diretório, por exemplo: `main.tf`, `security-groups.tf` e `ec2.tf`. Isso não altera a maneira com que o Terraform irá executar seu código. 

Para aplicar o que está descrito no código são necessãrios 2 comandos:

`terraform plan`: Mostra um plano de execução, ou seja, diz o que será adicionado, o que será modificado e o que será removido da sua infra baseado no *configuration* encontrado no diretório onde esse comando é executado. Esse comando é opcional mas de extrema importância para sabermos se a mudança é realmente o que estamos esperando. Fizemos até um *wrapper* para que nunca seja aplicada uma mudança sem a execução do *plan*.
`terraform apply`: Aplica as mudanças de fato. Se não houve nenhuma modificação do momento do *plan*, as mudanças que foram mostradas por ele serão aplicadas nesse momento. 

## Estado de um *resource*

O Terraform controla o estado dos resources contidos em um *configuration* em um arquivo JSON. Tal arquivo deve ser manipulado **apenas** pelo próprio Terraform. Ele utiliza esse arquivo para fazer comparações entre o estado existente, o estado que o código espera e o estado existente no *provider* (AWS, no nosso caso). Por padrão, esse arquivo é criado na junto com os arquivos `.tf` e possui o nome `terraform.tfstate`

O estado dos resources criados no exemplo anterior fica desse jeito (várias linhas foram omitidas devido ao extenso tamanho do arquivo, tais linhas possuiam informações irrelevantes e/ou metadados usados apenas pelo Terraform): 

```javascript
{
    "version": 3,
    "serial": 4,
    "lineage": "95a8a54a-f153-435e-b5fa-df66fd3c2c57",
    "modules": [
        {
            "path": [
                "root"
            ],
            "outputs": {},
            "resources": {
                "aws_instance.elo7-ec2-example": {
                    "type": "aws_instance",
                    "depends_on": [
                        "aws_security_group.elo7-sg-example",
                        "data.aws_ami.coreos-stable-latest"
                    ],
                    "primary": {
                        "id": "i-0c2d521d1861a806d",
                        "attributes": {
                            "ami": "ami-7ee7e169",
                            "availability_zone": "us-east-1b",
                            "id": "i-123456",
                            "instance_state": "running",
                            "instance_type": "t2.small",
                            "key_name": "example_key",
                            "private_ip": "192.168.10.111",
                            "security_groups.#": "0",
                            "subnet_id": "subnet-123456",
                            "tags.%": "1",
                            "tags.Name": "elo7-ec2-example",
                            "user_data": "1c338728002999224f8c8283650db76768b34112",
                            "vpc_security_group_ids.#": "1",
                            "vpc_security_group_ids.3439610007": "sg-123456",
                        }
                    }
                },
                "aws_security_group.elo7-sg-example": {
                    "type": "aws_security_group",
                    "depends_on": [],
                    "primary": {
                        "id": "sg-123456",
                        "attributes": {
                            "description": "SG de exemplo para o post no Blog",
                            "egress.#": "1",
                            "egress.482069346.cidr_blocks.#": "1",
                            "egress.482069346.cidr_blocks.0": "0.0.0.0/0",
                            "egress.482069346.from_port": "0",
                            "egress.482069346.prefix_list_ids.#": "0",
                            "egress.482069346.protocol": "-1",
                            "egress.482069346.security_groups.#": "0",
                            "egress.482069346.self": "false",
                            "egress.482069346.to_port": "0",
                            "id": "sg-123456",
                            "ingress.#": "1",
                            "ingress.2063172013.cidr_blocks.#": "1",
                            "ingress.2063172013.cidr_blocks.0": "172.16.0.0/16",
                            "ingress.2063172013.from_port": "22",
                            "ingress.2063172013.protocol": "tcp",
                            "ingress.2063172013.security_groups.#": "0",
                            "ingress.2063172013.self": "false",
                            "ingress.2063172013.to_port": "22",
                            "name": "elo7-sg-example",
                        }
                    }
                },
                "data.aws_ami.coreos-stable-latest": {
                    "type": "aws_ami",
                    "depends_on": [],
                    "primary": {
                        "id": "ami-7ee7e169",
                        "attributes": {
                            "architecture": "x86_64",
                            "description": "CoreOS stable 1185.5.0 (HVM)",
                            "hypervisor": "xen",
                            "id": "ami-7ee7e169",
                            "image_id": "ami-7ee7e169",
                            "image_location": "595879546273/CoreOS-stable-1185.5.0-hvm",
                            "image_type": "machine",
                            "most_recent": "true",
                            "name": "CoreOS-stable-1185.5.0-hvm",
                            "state": "available",
                            "virtualization_type": "hvm"
                        }
                    }
                }
            },
            "depends_on": []
        }
    ]
}
```

É com esse estado que o Terraform decide o que ele deve fazer baseando-se no código e também no que já existe no *provider* (no nosso caso, na AWS). Também é possível gerar um estado de uma infra já existente no seu *provider* (mas isso ficará para um próximo *post* dessa série ;)).

O controle dos *resources* com esse mecanismo funciona muito bem, porém, logo de cara podemos ver um problema, certo? Vimos que ele gera um arquivo `terraform.tfstate` no diretório do *configuration* ao rodar o `terraform apply`, correto? Isso é gerado em *runtime* e se pensarmos de maneira distribuída, com vários desenvolvedores mexendo nos *configurations*, isso pode ser bem ruim. Afinal, se um outro desenvolvedor não possuir o estado atual dos *resources* de um determinado *configuration* ao executar um *apply*, para o Terraform aquela infra ainda não existe e ela será criada novamente (até onde for possível, pois *resources* não permitem duplicidade). Isso pode causar catástrofes em alguns casos, como um registro de DNS sendo sobrescrito e indisponibilizando alguma aplicação. E esse é um comportamento que queremos bem longe da gente.

A próxima seção discutirá sobre como mitigamos esse problema. 

## Estado centralizado

Se estamos falando de um estado, logo esperamos que ele seja consistente. Para tal, o estado deve ser armazenado em um local centralizado. E é isso que fizemos para nos ajudar com os problema que foi citado anteriormente.

A solução óbvia, baseando-se no que já foi visto - estamos lidando com código (IaC) e o estado do Terraform nada mais é que um JSON (ou seja, mais texto) - seria versionar o estado junto com o código da infraestrutura e assim ele ficar centralizado no repositório do nosso controle de versão. 
Apesar de parecer uma ideia legal de início, ela oferece um grande problema pra nós: trabalhamos com *branches*, e caso dois desenvolvedores abrirem uma *branch* cada um de um mesmo *configuration*, ao fazer um teste ou aplicar o que está na *branch*, o estado entre elas e a *master* vai ficar inconsistente, ou seja, voltamos ao problema do estado distribuído. Mesmo em um caso onde exista apenas uma *branch*, ao modificar o estado nela e fazer um *merge* na *master*, estaremos nós mesmos modificando o estado do Terraform e isso é errado (lembrem-se que no começo do Post foi dito que o estado só deveria ser manipulado pelo próprio Terraform, né?).

A melhor solução seria termos o estado do *configuration* guardado em um ponto central, onde independente da *branch* na qual os desenvolvedores estão fazendo alterações, um único estado será modificado. E o Terraform, como boa ferramenta que é, pode nos ajudar com isso.

Ele possui a funcionalidade chamada [*Remote State*](https://www.terraform.io/docs/state/remote/index.html) que, como o nome já diz, permite com que o estado seja guardado em um local remoto centralizado. O Terraform dá suporte a algumas ferramentas para armazenar o estado, como o [Consul](https://www.consul.io) e o [S3](https://aws.amazon.com/s3/pricing/) da AWS. 

Para nós, centralizar os estados dos *configurations* no S3 fez mais sentido. Conseguimos fazer isso rodando esse comando na raiz de um *configuration* (para facilitar nosso dia-a-dia temos *wrappers* em nossos ambientes que nos ajudam a criar/configurar novos *configurations*):

```python
$ terraform remote config \
    -backend=s3 -backend-config="bucket=${S3_BUCKET}" \
    -backend-config="key=${S3_OBJECT}" \
    -backend-config="region=${S3_BUCKET_REGION}"
``` 

Um *plus* do comando acima, é que ele funciona tanto para um novo *configuration* e para um cujo estado foi criado acidentalmente na estação local.

Com isso, automaticamente, a cada `plan` e/ou `apply` do Terraform nas estações de trabalho dos desenvolvedores um único arquivo de estado é modificado e conseguimos manter nosso estado em um local centralizado para cada *configuration*.

Uma dica para quem for utilizar o S3 como local de armazenamento para os estados é que o *bucket* tenha a opção de versionamento ativada, isso pode ajudar a corrigir possíveis inconsistências nos estados.

Uma outra grande vantagem que o uso de *Remote States* dá, é a possibilidade de referenciar os `outputs` de um *configuration* em outro sem correr riscos de alterações indevidas. Isso pode ser feito com o *resource terraform_remote_state*. 

Um exemplo de como pegamos os IDs das zonas do Route53 para podermos criar novos registros em um *configuration*:

```python
data "terraform_remote_state" "route53" {
    backend = "s3"
    config {
        bucket = "BUCKET_NAME"
        key = "BUCKET_NAME/route53/route53.tfstate"
        region = "BUCKET_REGION"
    }
}
```
Assim, conseguimos referenciar de maneira *read-only* o ID que precisamos para criação de um novo registro:

```python
resource "aws_route53_record" "dns-public-web-app" {  
  zone_id = "${data.terraform_remote_state.route53.zone01.id}"
  name = "public-web-app.elo7.com.br"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.public-web-app.private_ip}"]
}
```

## Limitações

Utilizar o *Remote State* com o Terraform alivia bastante os problemas de desenvolvimento paralelo dos *configurations* que foram citados até aqui. Porém, ainda devemos tomar alguns cuidados ao lidar com esse modelo. 

Temos o seguinte cenário de exemplo:
- *configuration*: `public-web-app`, que já possui uma série de *resources* criados, como instâncias, banco de dados, registros DNS, etc.

Desenvolvedores criam as seguintes *branches*:
- *Dev 1* cria branch: `adiciona-ALB`
- *Dev 2* cria branch: `adiciona-discos-para-logs`

Supondo que o *Dev 1* trabalhe em sua *branch* primeiro, e adiciona um ALB (Application Load Balancer) no *configuration* do `public-web-app`. Nesse momento, o estado desse *configuration* vai possuir informações sobre o ALB criado. 
O *Dev 2*, por sua vez, vai fazer suas alterações. Porém, no momento que ele criou sua *branch*, o código do ALB criado pelo *Dev 1* ainda não existia, mas tais informações existem no estado. Então, o *Dev 2* vai fazer suas alterações, e vai executar o `terraform plan`. 
O plano mostrado pelo Terraform para o *Dev 2*, dirá que os discos que ele adicionou serão provisionados e *attachados* nas instâncias pois, obviamente, tais *resources* não existiam no estado. Entretanto, algo estranho também aparecerá para o *Dev 2*: o Terraform o informará que irá remover um ALB, pois ele encontrou tal *resource* no estado e não no código. 

E agora? Como fizemos?

O Terraform não é capaz de controlar mudanças distribuídas (a Hashicorp possui uma versão Enterprise do Terraform que oferece esse controle centralizado). Então, a opção mais barata e direta é termos processos de uso da ferramenta:
- Quebramos os nossos *configurations* por aplicações (as vezes uma aplicação possui mais de um *configuration*, caso ela tenha muitas dependências): isso diminui bastante as chances de existirem dois desenvolvedores alterando o mesmo *configuration* concomitantemente;
- Caso a *branch* seja antiga, um *rebase* da *master* resolve o problema, pois novas alterações que já foram *mergeadas* são aplicadas na *branch* atual;
- Em último caso, utilizamos o argumento `-target=` do Terraform, que permite com que passamos exatamente quais resources queremos que sejam modificados. No caso do exemplo anterior, o *Dev 2* poderia apontar os seus discos no `-target=` e rodar um `terraform apply`. Assim, seus discos seriam criados e o ALB continuaria intacto.
- Vale salientar, também, que o que está sendo desenvolvido em uma *branch*, mesmo que aplicado, não é considerado "em produção". O ambiente de produção é considerado aquele que está na *master* do repositório, ou seja, um `terraform apply` na *master* não deve nunca causar nenhum dano às nossas aplicações.

## Conclusões

Nesse Post mostramos como o Terraform se organiza internamente com a infraestrutura que ele controla e como fazemos para trabalhar de uma maneira mais distribuída com ele. Também citamos alguns processo que usamos para diminuir os problemas que as limitações do modelo trazem. 

Por enquanto o método de trabalho descrito aqui está nos atendendo muito bem. Mas temos em mente que podemos chegar numa escala que ele não nos irá nos atender muito bem, nesse caso vamos pensar em outras abordagens, como desenvolver uma ferramenta interna para controle de modificações em paralelo ou até mesmo contratar o serviço oferecido pela Hashicorp.

Finalizamos, então, mais um Post da série Terraformando Tudo. Mas ela ainda não terminou! Voltaremos aqui em um próximo Post, mostrando como fazer com a infraestrutura que já existia! Podemos *"terraformá-la"*? Veremos!

