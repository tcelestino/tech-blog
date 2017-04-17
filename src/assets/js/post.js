define(['doc', 'ajax'], function($, ajax) {

	var GITHUB_URI = 'https://api.github.com/users/',
		$author = $('p[itemprop="publisher"]'),
		dataAuthor = $author.data('author'),
		$avatar = $('.avatar'),
		$copy = $('.copy');

	function supportsCopy() {
		return 'execCommand' in document && document.queryCommandSupported('copy');
	}

	if(supportsCopy() && $copy) {
		$copy.removeClass('hide');

		$copy.on('click', function(evt) {
			evt.preventDefault();

			var $this = $(this);
			$this.closest('.share').find('.link-input').first().select();

			try {
				if (document.execCommand('copy')) {
					console.log('Copiado com sucesso');
				} else {
					console.log('Erro ao copiar');
				}
			} catch(e) {
				console.log('Erro ao copiar');
			}
		});
	}

	if($author) {
		ajax.get(GITHUB_URI + dataAuthor, {}, {
			success: function(response, xhr) {
				var userInfo = {
					avatar: response.avatar_url + '&size=50',
					name: response.name
				};

				$avatar.removeClass('hide').first().src = userInfo.avatar;
				$author.html(userInfo.name);
			},

			error: function(response, xhr) {},
			complete: function(xhr) {}
		})
	}
});
