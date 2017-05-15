---
layout: page
---
<article itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" class="post-content">
  <div itemprop="articleBody">
    {{{content}}}
  </div>
</article>

<article class='publisher-info'>
  <a rel='author' itemprop='url' href='https://github.com/{{document.author}}' target='_blank' class='author'>
    <img class='hide avatar' width='100px' height='100px'/>
    <h1 itemprop='publisher' data-author='{{document.publisher}}' class='publisher'>@{{document.publisher}}</h1>
  </a>
  <h2 class='time'>{{document.time}}</h2>
  <p>{{document.description}}</p>
  <p>Confira os posts escritos por <strong>{{document.publisher}}</strong></p>
</article>

<section class="posts-container">
  {{#each (getCollection "posts")}}
    {{#equal author ../document.publisher}}
      <article itemprop="blogPost" itemtype="http://schema.org/Blog" class="post-card card-{{category}}">
        <header>
            <a href="{{../site.baseUrl}}{{url}}" class="link">
                <h2 class="title">{{title}}</h2>
            </a>
        </header>
        <div class="post-meta">
            by <a href="https://github.com/{{author}}" target="_blank" class="author"><p>@{{author}}</p></a>
            · <time datetime="{{dateAsText this.date}}" itemprop="datePublished" class="date">{{dateAsText this.date}}</time>
        </div>

        <p class="description">{{description}}</p>
        <a href="/{{category}}" class="category {{category}}">{{category}}</a>
        <a href="{{../site.baseUrl}}{{url}}" class="link post-link">Continue lendo</a>
      </article>
    {{/equal}}
  {{/each}}
</section>
<script async src="/js/author.js"></script>
