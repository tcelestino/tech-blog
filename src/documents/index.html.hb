---
layout: page
referenceOthers: true
---
<section class="posts-container">
    {{#each (getCollection "posts")}}
            <article class="post-card card-{{category}}">
                <header>
                    <a href="{{../site.baseUrl}}{{url}}" class="link">
                        <h1 class="title">{{title}}</h1>
                    </a>
                </header>
                <small class="date">{{dateAsText this.date}}</small>

                <p class="description">{{description}}</p>
                <a href="/{{category}}" class="category {{category}}">{{category}}</a>
                <a href="{{../site.baseUrl}}{{url}}" class="link post-link">Continuar lendo...</a>
            </article>
    {{/each}}
</section>
