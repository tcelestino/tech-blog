---
date: 2018-01-08
category: front-end
tags:
  - javascript
  - web
  - web api
authors: [tcelestino]
layout: post
title: Credential Managament API
description: Conheça a Credential Managament API e veja como a implementá-la em seu projeto.
---

Hoje em dia passamos muito tempo em redes sociais, fóruns, blogs e sites de comércio eletrônico, sabemos então o quanto é chato ter que ficar anotando dados de login e senha deste serviços. E como você sabe, por questões de segurança, não devemos usar os mesmo dados para acessar diferentes serviços. Para resolver este problema, existem diversos aplicativos que gerenciam essas informações, como: [LastPass](https://www.lastpass.com), [1Password](https://1password.com/), [bitwarden](https://bitwarden.com/), [Dashlane](https://www.dashlane.com/), entre outros. Os principais navegadores do mercado também possuem recursos para fazer esse gerenciamento. Mas daí surge uma dúvida: como fazemos para informar esses dados para os navegadores? Como que consigo integrar meu sistema de login com o navegador? Para resolver essas perguntas (se existirem outras, podem deixar nos comentários), te apresento a [Credential Management API](https://www.w3.org/TR/credential-management-1/), API que pelo próprio nome já diz, faz o gerenciamento de suas credenciais (login e senha, por exemplo) através do navegador. No momento, apenas a versão do Chrome para desktop e Android possui a API implementada. Acredito que logo logo veremos em outros navegadores.

O Credential Management API segue três pilares:

- Permitir acesso com um toque com o seletor de contas;
- Salvar e gerenciar seus dados;
- Simplificar o fluxo de acesso.

Existem diversas maneiras de melhorar o fluxo de utilização do seu site com a Credential Managament API. Um exemplo seria facilitar o processo de login automático, caso o usuário tenha múltiplas contas registradas em seu navegador.

## Como usamos no Elo7

Antes de mostrar a implementação da API, queria exemplificar com utilizamos aqui no [Elo7](https://elo7.com.br).

Utilizamos a Credential Management API no sistema de login do Elo7 (na versão web mobile) e analisando os resultados através do Google Analytics, observamos que realmente nossos usuários utilizam este recurso, independente do seu nível de conhecimento.

![Alt "Gráfico do Google Analytics sobre o uso da Credential Management API"](../images/credential-management-api-1.png)
<div style="text-align: center; font-style: italic">Gráfico de uso da Credential Management API no Elo7</div>

Vamos deixar de conversa e partir para a implementação!

## Implementando a API

Como grande maioria das API's Javascript lançadas hoje em dia, precisamos garantir a segurança das informações. Ou seja, para usar a Credential Management API você precisa ter um servidor com uma conexão segura. Em outras palavras, é necessário que o protocolo *https* esteja habilitado em seu servidor.

A primeira coisa que precisamos verificar é se esta API está disponível em seu navegador. Importante: nos exemplos a seguir vou usar o ES2015. Caso não tenha conhecimento a respeito, recomendo a seguinte [leitura](https://github.com/lukehoban/es6features).

No exemplo, estou usando a seguinte estrutura HTML:

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Credential Management API example</title>
</head>
<body>
	<form id='login' method='POST' action='/auth/login'>
		<fieldset>
			<label>Email: <input type='email' name='name'></label>
			<label>Email: <input type='password' name='pass'></label>
		</fieldset>
		<input type='submit' value='Log in'>
	</form>
</body>
</html>
```

```javascript
'use strict';

(() => {
	if ('credentials' in navigator) {
		const form = document.forms.login;

		form.addEventListener('submit', () => {
			let cred = new PasswordCredential({
				id: form.elements[0].value, // email's field
				password: form.elements[1].value // password's field
			});

			navigator.credentials.store(cred).then(() => console.log('Data save success'))
				.catch(() => console.log('Your data were not saved'));
		});
	}
})();
```

No código acima, criamos uma instância do objeto `PasswordCredential` quando é feito um `submit` em um formulário, no qual passamos para este as informações preenchidas nos campos do formulário. Feito isso, chamamos o método `navigator.credentials.store()`, passando como argumento/parâmetro o objeto que criamos com `PasswordCredential`. Esse método retornará uma Promise. Caso você não saiba o que é uma Promise, recomendo ler a [documentação](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Global_Objects/Promise) disponível no [Mozilla Developer Network (MDN)](https://developer.mozilla.org/pt-BR/). Vale lembrar que, caso aconteça o `catch` o usuário irá logar no sistema, apenas as informações (email e senha) não serão gravadas.

## Recuperando as informações

Assim como salvamos, também podemos recuperar informações que já foram salvas. Para isso, vamos usar o método `navigator.credentials.get()`. Esse método retornará as informações que salvamos anteriormente no método `navigator.credentials.store()`. Caso não exista nenhuma informação, será retornado um `null`. Ou seja, você pode criar uma abordagem que faça o usuário cadastrar as informações caso o valor seja `null`, por exemplo.

```javascript
'use strict';

(() => {
	if ('credentials' in navigator) {
		const form = document.forms.login;

		form.addEventListener('submit', () => {
			let cred = new PasswordCredential({
				id: form.elements[0].value,
				password: form.elements[1].value
			});
			navigator.credentials.store(cred).then(() => console.log('Data save success')).catch(() => console.log('Your data were not saved'));
		});

		document.querySelector('.login').addEventListener('click', (evt) => {
			navigator.credentials.get({
				password: true,
				unmediated: true
			}).then((cred) => {
				if (cred) {
					// do something
				}
			});

			evt.preventDefault();
		});
	}
})();
```

**Observação:** existe um objeto construtor chamado `FederatedCredential`, mas não entraremos em detalhes nesse post. Caso queira ter mais detalhes, recomendo a [leitura](https://developer.mozilla.org/pt-BR/docs/Web/API/FederatedCredential).

Como podem observar, passamos para o `navigator.credentials.get()` duas informações:

- password: por padrão, o valor é `false`, por isso é preciso setar `true` para recuperar informações do `PasswordCredential`;
- unmediated: quando for `true`, habilita o login automático, sem precisar exibir a interface de seleção de contas.

![Alt "Seleção de multiplas contas usando a Credential Management API"](../images/credential-management-api-2.png)
<div style="text-align: center; font-style: italic">Seleção de multiplas contas usando a Credential Management API</div>

Podemos criar diversas abordagens, inclusive integrando com serviços de autenticação de terceiros como o [Google Sign-In](https://developers.google.com/identity/sign-in/web/sign-in) e [Facebook Login](https://developers.facebook.com/docs/facebook-login/). Para isso, existe o `federated`, no qual podemos informar em qual serviços será o fornecedor desses dados. Leia mais [aqui](https://developers.google.com/web/fundamentals/security/credential-management/retrieve-credentials).

Vamos alterar nosso código para melhorar o fluxo do usuário caso ele tenha diversas contas. Lembrando que isso é um exemplo e você pode criar a sua própria abordagem a partir das necessidades de seu projeto.

```javascript
'use strict';

(() => {
	if ('credentials' in navigator) {
		const form = document.forms.login;

		form.addEventListener('submit', function() {
			let cred = new PasswordCredential({
				id: form.elements[0].value,
				password: form.elements[1].value
			});

			navigator.credentials.store(cred).then(() => console.log('Data save success')).catch(() => console.log('Your data were not saved'));
		});

		document.querySelector('.login').addEventListener('click', (evt) => {
			navigator.credentials.get({
				password: true,
				unmediated: true
			}).then((cred) => {
				if (cred) {
					login(cred);
				} else {
					navigator.credentials.get({
						password: true,
						unmediated: false
					}).then((cred) => {
						if(cred) {
							login(cred);
						}
					}).catch((e) => { console.error(e) });
				}
			}).catch((e) => console.error(e));

			evt.preventDefault();
		});
	}
})()
```

Você pode ter percebido que adicionamos uma função `login` em nosso código. Mas o que vamos ter nela? Como sabe, precisamos fazer o usuário logar em nosso sistema, logo precisamos fazer uma requisição para o nosso sistema. Vou simular que temos uma rota que recebe essas informações.

```javascript
'use strict';

(() => {
	if ('credentials' in navigator) {
		const form = document.forms.login;

		var login = (cred) => {
			cred.idName = 'email';

			fetch('/auth/login', {
				method: 'POST',
				credentials: cred
			}).then((result) => {
				if (result.ok) {
					window.location = '/main/index';
				} else {
					alert('An error has occurred!');
				}
			}).catch((e) => {
				console.error(e);
			});
		};

		form.addEventListener('submit', function() {
			let cred = new PasswordCredential({
				id: form.elements[0].value,
				password: form.elements[1].value
			});

			navigator.credentials.store(cred).then(() => console.log('Data save success')).catch(() => console.log('Your data were not saved'));
		});

		document.querySelector('.login').addEventListener('click', (evt) => {
			navigator.credentials.get({
				password: true,
				unmediated: true
			}).then((cred) => {
				if (cred) {
					login(cred);
				} else {
					navigator.credentials.get({
						password: true,
						unmediated: false
					}).then((cred) => {
						if(cred) {
							login(cred);
						}
					}).catch((e) => { console.error(e) });
				}
			}).catch((e) => console.error(e));

			evt.preventDefault();
		});
	}
})()
```

Passamos para a função `login` o objeto `cred` que será usado no nosso back-end para autenticar os dados do usuário. Fazemos uma requisição AJAX usando a [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch).

Agora que sabemos como salvar e obter os dados salvos com a Credentinal Management API e integrar com um sistema próprio de autenticação, também podemos garantir o *logout* do usuário em nosso sistema. Para isso, vamos usar o metódo `navigator.credentials.requireUserMediation()`. Leia mais [sobre aqui](https://developers.google.com/web/fundamentals/security/credential-management/retrieve-credentials#sign-out).

```javascript
'use strict';

(() => {
	document.querySelector('.logout').addEventListener('click', (evt) => {
		if ('credentials' in navigator) {
			navigator.credentials.requireUserMediation();
		} else {
			window.location = '/auth/logout';
		}

		evt.preventDefault();
	});
});

```

Como isso, garantimos que o usuário não "logará" automaticamente quando este fizer um novo acesso ao sistema.

## Conclusão

A Credential Management API é uma solução que pode melhorar bastante a usabilidade do processo de login dos usuários, agilizando bastante e mantendo as informações de forma segura. Claro que será muito mais interessante quando futuramente outros navegadores também a implementarem.

## Refêrencias

* [A Credential Management API - Google Developer](https://developers.google.com/web/fundamentals/security/credential-management/)
* [Credential Management API - Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/API/Credential_Management_API)
* [Store Credentials](https://developers.google.com/web/fundamentals/security/credential-management/store-credentials)
* [Sign in Users](https://developers.google.com/web/fundamentals/security/credential-management/retrieve-credentials)
