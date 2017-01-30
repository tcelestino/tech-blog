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

Como a própria página do projeto sugere, um código do Terraform, independente de tamanho, desde que seja executável, é chamado de *Terraform configuration*. Seguindo essa sugestão, nessa série de *posts* vamos chamar um código de Terraform de *configuration* (apesar de internamente chamarmos de 'módulo', pra facilitar :P).

Conforme foi citado no [primeiro post](http://engenharia.elo7.com.br/terraformando-tudo-1/), o Terraform utiliza uma linguagem proprietária chamada HCL (*Hashicorp Configuration Language*). A seguir, temos um exemplo de *configuration* mínimo que pode ser executado com o Terraform. Alguns detalhes estão em formato de comentário no código: 

`ec2.tf`
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

# Criando um security-group para essa instância
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

