---
title: Mobile
description: Todos os posts da categoria mobile
layout: page
---
<section class="posts-container">
    {{#each (getCollection "mobile")}}
            <article itemprop="blogPost" itemtype="http://schema.org/Blog" class="post-card card-{{category}}">
                <header>
                    <a href="{{../site.baseUrl}}{{url}}" class="link">
                        <h2 class="title">{{title}}</h2>
                    </a>
                </header>
                <div class="post-meta">
                    by <a href="/{{author}}" target="_blank" class="author"><p>@{{author}}</p></a>
                    · <time datetime="{{dateAsText this.date}}" itemprop="datePublished" class="date">{{dateAsText this.date}}</time>
                </div>

                <p class="description">{{description}}</p>
                <a href="/{{category}}" class="category {{category}}">{{category}}</a>
                <a href="{{../site.baseUrl}}{{url}}" class="link post-link">Continue lendo</a>
            </article>
    {{/each}}
</section>
