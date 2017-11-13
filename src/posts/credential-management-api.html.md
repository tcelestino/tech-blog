---
date: 2017-11-13
category: front-end
tags:
  - javascript
  - web
authors: [tcelestino]
layout: post
title: Credential Managament API
description:
---

Nos dias atuais, passamos bastante tempo navegando em nossos navegadores, hoje principalmente nos dispostivos móveis. E grande parte dos serviços possuem algum controle de acesso. Normalmente precisamos digitar um login (nome de usuário ou email) e uma senha. O principal fato aqui é que grande parte desse processo pode ser "chata" e ter que sempre ficar digitando essas informações. Existem diversos serviços/aplicativos que gerencia bastante esses dados, posso citar alguns como o LastPass, 1Password, bitwarden, Dashlane e principalmente os navegadores. Sim, os navegadores já oferecem recursos para gerenciarmos nossos dados. O Chrome, Firefox e o Safari, oferecem recurso nativos para podemos gerenciar nosso logins e senhas em diversos sites. Pois bem! Mas dai surge uma dúvida: como que fazemos para informar esses dados para os navegadores? Como que consigo integrar meu sistema de login com o navegador? Dai que surgiu a proposta da [Credential Management API](https://www.w3.org/TR/credential-management-1/). No exato momento que escrevo, apenas o Chrome (Android e desktop) já tem a API implementada. Os outros navegadores estão trabalhando na implementação.

O Credential Management API segue três pilares:

- Simplificar o fluxo de acesso;
- Permitir acesso com um toque com o seletor de contas;
- Salvar e gerenciar seus dados.

Existem diversas maneiras de melhorar o fluxo de uso do seu site com a Credential Managament API, facilitando o login automático, se o usuário tiver outras contas salvas no navegador, poderá escolher qual conta será utilizada a garantir de verdade o *logout*.

## Como usamos no Elo7

Aqui no Elo7, já utilizamos a Credential Management API no sistema de login na versão para dispositivos móveis do marketplace (conto logo, logo o problema com a implementação na versão desktop) e segundo dados que obtemos através do Google Analytics, observamos que muitos usuários estão usando o recurso, que facilita bastante o processo de autenticação em nosso sistema. Mas deixamos de conversa e vamos a implementação!

### Obtendo informações do usuário

Como grande maioria das API's Javascript lançadas hoje, precisamos garantir a segurança. Ou seja, para usar a API você vai precisar ter um servidor com uma conexão segura, em palavras curtas precisa ter o *https* habilitado no seu servidor. Você pode usar diversos serviços para rodar local, eu recomendo o [ngrok](https://ngrok.com/) ou utilizar o Heroku. Esse último que estou usando do nosso exemplo.

A primeira coisa que precisamos garantir se a API está disponível no navegador.

```javascript
	if ('credentials' in navigator) {
		let cred = new PasswordCredential({
			id: 'login',
			password: 'senha'
		});

		navigator.credentials.store(cred).then(() => console.log('Dados salvos')).catch(() => console.log('Não possível salvar os dados'););
	}
```

Nota-se que usamos um objeto chamado `PasswordCredential`. É com ele qu

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
	<meta charset="UTF-8">
	<title>Usando Credential Managament API</title>
</head>
<body>
	<form action='/auth' class='form-login'>
		<fieldset>
			<legend>Login</legend>
			<label for='name'>
				Nome:
				<input type='text' name='name' id='name'>
			</label>
			<label for='pass'>
				Senha:
				<input type='password' name='pass' id='pass'>
			</label>
			<button>Logar</button>
		</fieldset>
	</form>
	<script>
		if (!'credentials' in 'navigator') {
			console.log('Seu navegador não tem suporte');
			return;
		}

		document.querySelector('.form-login').addEventListener('submit', () => {
			var cred = new PasswordCredential({
				id: ''
				password: ''
			});

			navigator.credentials.store(cred).then(() => {}).catch(() => {});
		});
	</script>
>>>>>>> Stashed changes
</body>
</html>
```

## Nem tudo são flores

Por mais que a API venha para facilitar o gerenciamento de contas, ela ainda não funciona 100% no desktop. Principalmente em relação a sessão. Nos testes que realizamos no Elo7... [contar o problema - ver com Aline/Vasco o que aconteceu]
