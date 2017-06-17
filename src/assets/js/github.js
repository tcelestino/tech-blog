define('github', ['doc', 'ajax'], function($, ajax) {
	var GITHUB_URI = 'https://api.github.com/users/';

	var getUserInfo = function(size, user) {
		var userInfo;
		ajax.get(GITHUB_URI + user, {}, {
			success: function(response, xhr) {
				userInfo = {
					avatar: response.avatar_url + '&size=' + size
				};
			},

			error: function(response, xhr) {},
			complete: function(xhr) {}
		})

		return userInfo;	
	};

	var update = function($avatar, size, user) {
		var userInfo = getUserInfo(size, user);

		if (userInfo && userInfo.avatar) {
			$avatar.attr('src', userInfo.avatar);
		}
	};

	return {
		updateAvatar: function(listOfAvatar) {
			listOfAvatar.forEach( function(currentValue) {
				update(currentValue.imgElement, currentValue.size, currentValue.userName);
			});
		}
	}
});