define(['doc', 'github'], function($, github) {

	var $avatar = $('img.avatar'),
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

	if($avatar.isPresent()) {
		$avatar.removeClass('hide');
		github.updateAvatar([{imgElement: $avatar, size:50, userName: $('p.publisher').data('author')}]);
	}
});
