define(['doc', 'ajax'], function($, ajax) {

	var GITHUB_URI = 'https://api.github.com/users/',
		$author = $('h1[itemprop="publisher"]'),
		dataAuthor = $author.data('author'),
		$avatar = $('.avatar');

	if($author.isPresent()) {
		ajax.get(GITHUB_URI + dataAuthor, {}, {
			success: function(response, xhr) {
				var userInfo = {
					avatar: response.avatar_url + '&size=100',
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
