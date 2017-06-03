define(['doc', 'ajax'], function($, ajax) {

	var GITHUB_URI = 'https://api.github.com/users/',
		$author = $('p.publisher'),
		dataAuthor = $author.data('author'),
		$avatar = $('.avatar'),
		$copy = $('.copy'),
		$copySuccess = $('.copy-success');

	function supportsCopy() {
		return 'execCommand' in document && document.queryCommandSupported('copy');
	}

	if(supportsCopy() && $copy.isPresent()) {
		$copy.removeClass('hide');


		$copy.on('click', function(evt) {
			evt.preventDefault();

			$(this).closest('.share').find('.link-input').first().select();

			try {
				if(document.execCommand('copy')) {
					$copySuccess.addClass('active');

					setTimeout(function() {
						$copySuccess.removeClass('active');
					}, 2000);
				}
			} catch(e) {}
		});
	}

	if($author.isPresent()) {
		ajax.get(GITHUB_URI + dataAuthor, {}, {
			success: function(response, xhr) {
				var userInfo = {
					avatar: response.avatar_url + '&size=50',
					name: response.name
				};

				$avatar.removeClass('hide').attr('src', userInfo.avatar);
				$author.html(userInfo.name);
			},

			error: function(response, xhr) {},
			complete: function(xhr) {}
		})
	}
});
