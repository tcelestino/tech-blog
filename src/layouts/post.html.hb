---
layout: page
---
<article itemprop='blogPost' itemscope itemtype='http://schema.org/BlogPosting' class='post-content'>
  <h1 itemprop='name headline' class='title'>{{document.title}}</h1>
  <div class='post-meta'>
      <p class='date'>
        Publicado em: <time datetime='{{dateAsText document.date}}' itemprop='datePublished'>{{dateAsText document.date}}</time>
      </p>

      <article itemprop='author' itemscope itemtype='http://schema.org/Person'>
        <a rel='author' itemprop='url' href='https://github.com/{{document.author}}' target='_blank' class='author'>
          <img class='hide avatar' width='50px' height='50px'/>
          <p itemprop='publisher' data-author='{{document.author}}' class='publisher'>@{{document.author}}</p>
        </a>

        <meta itemprop='worksFor' content='Elo7 Serviços de Informática SA'>
      </article>

  </div>
  <div itemprop='articleBody'>
    {{{content}}}
    <section class='share'>
      <a href='https://www.facebook.com/dialog/share?app_id=644444999041914&href={{site.url}}{{document.url}}&display=popup' rel='noopener' target='_blank' class='link-share facebook' title='Clique para compartilhar no Facebook'>
        Compartilhar no facebook
      </a>
      <a href='https://twitter.com/intent/tweet?text={{document.title}}&url={{site.url}}{{document.url}}&hashtags=elo7tech' rel='noopener' target='_blank' class='link-share twitter' title='Clique para compartilhar no Twitter'>
        Compartilhar no twitter
      </a>
      <a href='{{site.url}}{{document.url}}' class='link-share hide copy' title='Clique para copiar a url'>
        Copiar URL
      </a>
      <span class='copy-success'>Link copiado</span>
      <input type='url' value='{{site.url}}{{document.url}}' class='link-input'>
    </section>
  </div>
  <div id='disqus_thread'></div>

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
<script async src="/js/post.js"></script>
