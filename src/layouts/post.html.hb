---
layout: page
---
<article itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" class="post-content">
  <h1 itemprop="name headline" class="title">{{document.title}}</h1>
  <div class="post-meta">
      by
      <span itemprop="author" itemscope itemtype="http://schema.org/Person">
        <a rel="author" itemprop="url" href="https://github.com/{{document.author}}" target="_blank" class="author">
          <p itemprop="publisher">@{{document.author}}</p>
        </a>
        <meta itemprop="worksFor" content="Elo7 Serviços de Informática SA">
      </span>
      ·
      <p class="date">
        <time datetime="{{dateAsText document.date}}" itemprop="datePublished">{{dateAsText document.date}}</time>
      </p>
  </div>
  <div itemprop="articleBody">
    {{{content}}}
  </div>
  <div id="disqus_thread"></div>

  <script async>
      var disqus_shortname = 'engenhariaelo7';
      var disqus_identifier = '{{dateAsText document.date}}:{{document.url}}';
      var disqus_url = '{{site.url}}{{document.url}}';

      (function() {
          var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
          dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
          (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
      })();
  </script>
  <noscript>Habilite o JavaScript para ver os comentários</noscript>
</article>
