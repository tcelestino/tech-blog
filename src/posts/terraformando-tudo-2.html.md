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

É com esse estado que o Terraform decide o que ele deve fazer baseando-se no código e também no que já existe no *provider*. Também é possível gerar um estado de uma infra já existente no seu *provider* (mas isso ficará para um próximo *post* dessa série ;)).

O controle dos *resources* com esse mecanismo funciona muito bem, porém, logo de cara podemos ver um problema, certo? Vimos que ele gera um arquivo `terraform.tfstate` no diretório do *configuration* ao rodar o `terraform apply`, correto? Isso é gerado em *runtime* e se pensarmos de maneira distribuída, com vários desenvolvedores mexendo nos *configurations*, isso pode ser bem ruim. Afinal, se um outro desenvolvedor não possuir o estado atual dos *resources* de um determinado *configuration* ao executar um *apply*, para o Terraform aquela infra ainda não existe e ela será criada novamente (até onde for possível, pois existem valores únicos em alguns *resources*). E esse é um comportamento que queremos bem longe da gente.

A próxima seção discutirá sobre como mitigamos quase que totalmente esse problema. 

## Estado centralizado


