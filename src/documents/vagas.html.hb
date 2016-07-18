---
title: Vagas
description: Todos os posts da categoria vagas
layout: page
---
<section class="posts-container">
    {{#each (getCollection "vagas")}}
            <article itemprop="blogPost" itemtype="http://schema.org/Blog" class="post-card card-{{category}}">
                <header>
                    <a href="{{../site.baseUrl}}{{url}}" class="link">
                        <h2 class="title">{{title}}</h2>
                    </a>
                </header>
                <a href="https://github.com/{{author}}" target="_blank" class="author"><p>@{{author}}</p></a>
                <time datetime="{{dateAsText this.date}}" itemprop="datePublished" class="date">{{dateAsText this.date}}</time>

                <p class="description">{{description}}</p>
                <a href="/{{category}}" class="category {{category}}">{{category}}</a>
                <a href="{{../site.baseUrl}}{{url}}" class="link post-link">Continuar lendo...</a>
            </article>
    {{/each}}
</section>
