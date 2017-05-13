---
layout: page
---

<h1>{{document.author}}</h1>
<h2>{{document.time}}</h2>

<a rel="author" itemprop="url" href="https://github.com/{{document.author}}" target="_blank" class="author">
  <p itemprop="publisher">@{{document.author}}</p>
</a>

<article itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" class="post-content">
  <div itemprop="articleBody">
    {{{content}}}
  </div>
</article>

<section class="posts-container">
  {{#each (getCollection "author")}}
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
  {{/each}}
</section>
