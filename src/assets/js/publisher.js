define(['doc', 'github'], function($, github) {

	var $avatar = $('.avatar');

	if($avatar.isPresent()) {
		$avatar.removeClass('hide');
		github.updateAvatar([{imgElement: $avatar.find('img'), size: 100, userName: $('.github').text()}]);
	}
});
