define(['doc', 'github'], function($, github) {

	var $avatar = $('img.avatar'),
		$copy = $('.copy'),
		$copySuccess = $('.copy-success'),
		$user = $('.author [itemprop=name]'),
		userName = $('.author .publisher').data('author'),
		listOfInfo = github.getInfoFromUsers('50', [userName]);

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

	listOfInfo.forEach(function(currentUser) {
		if (currentUser.user == userName) {
			if ($avatar.isPresent()) {
				$avatar.removeClass('hide');
				$avatar.attr('src', currentUser.avatarUrl);
			}

			if ($user.isPresent() && currentUser.name) {
				$user.text(currentUser.name);
			}
		}
	});
});
