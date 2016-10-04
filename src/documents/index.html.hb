---
title: Home
description: Blog de tecnologia do Elo7, com postagens dos próprios colaboradores mostrando como é o dia a dia de um colaborador fora de série
layout: page
---
<section class="posts-container">
    {{#each (getCollection "posts")}}
            <article itemprop="blogPost" itemtype="http://schema.org/Blog" class="post-card card-{{category}}">
                <header>
                    <a href="{{../site.baseUrl}}{{url}}/" class="link">
                        <h1 class="title">{{title}}</h1>
                    </a>
                </header>
                <div class="post-meta">
                    by <a href="https://github.com/{{author}}" target="_blank" class="author"><p>@{{author}}</p></a>
                    · <time datetime="{{dateAsText this.date}}" itemprop="datePublished" class="date">{{dateAsText this.date}}</time>
                </div>
                <p class="description">{{description}}</p>
                <a href="/{{category}}" class="category {{category}}">{{category}}</a>
                <a href="{{../site.baseUrl}}{{url}}/" class="link post-link">Continue lendo</a>
            </article>
    {{/each}}
</section>
