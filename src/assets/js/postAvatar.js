define(['doc', 'ajax'], function($, ajax) {

  var GITHUB_URI = 'https://api.github.com/users/',
      $author = $('p[itemprop="publisher"]'),
      dataAuthor = $author.data('author'),
      userInfo = {};


  if($author) {
    ajax.get(GITHUB_URI + dataAuthor, {
      'X-RateLimit-Limit': 20
    }, {
      success: function(response) {
        userInfo = {
          avatar: response.avatar_url + '&size=50',
          name: response.name
        };
        $('.avatar').first().src = userInfo.avatar;
        $author.html(userInfo.name);
      },
      error: function(response) {},
      complete: function(xhr) {}
    })
  }
});
