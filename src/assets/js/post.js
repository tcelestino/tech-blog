define(['doc', 'github'], function($, github) {
	'use strict';

	var $sharePost = $('.share > .share-post');

	if(navigator && navigator.share) {
		$sharePost.removeClass('hide');
		$sharePost.on('click', function() {
			var $title = $("meta[property='og:title']"),
				$canonicalURL = $("link[rel='canonical']");
			navigator.share({
				title: $title.isPresent() ? $title.attr('content') : $('.post-content > .title').html(),
				url: $canonicalURL.isPresent() ? canonicalURL.attr('href') : document.location.href
			}).then(() => console.log('Compartilhado com sucesso!')).catch((e) => console.error('Falha ao compartilhar', e));
		});
	}

	var $authors = $('.author'),
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

	if($authors.isPresent()) {
		$authors.each(function(author) {
			var $author = $(author),
				$avatar = $author.find('img.avatar');

			if ($avatar.isPresent()) {
				var $publisher = $author.find('.publisher'),
					userName = $publisher.data('author'),
					listOfInfo = github.getInfoFromUsers('50', [userName]),
					info = listOfInfo[0];

				if (info.avatarUrl) {
					$avatar.removeClass('hide');
					$avatar.attr('src', info.avatarUrl);
				}
			}
		});
	}
});
