define(['doc', 'ajax'], function($, ajax) {

	var GITHUB_URI = 'https://api.github.com/users/',
		$author = $('h1.name'),
		dataGitHubAuthor = $('.github').text(),
		$avatar = $('.avatar');

	if($author.isPresent()) {
		ajax.get(GITHUB_URI + dataGitHubAuthor, {}, {
			success: function(response, xhr) {
				var userInfo = {
					avatar: response.avatar_url + '&size=100',
					name: response.name
				};

				$avatar.removeClass('hide');
				$avatar.find('img').attr('src', userInfo.avatar);
				$author.html(userInfo.name);
			},

			error: function(response, xhr) {},
			complete: function(xhr) {}
		})
	}
});
