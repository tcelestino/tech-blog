---
layout: page
referenceOthers: true
---
<section class="posts-container">
    {{#each (getCollection "posts")}}
        <a href="{{../site.baseUrl}}{{url}}">
            <article class="post-card card-{{category}}">
                <header>
                    <h1 class="title">{{title}}</h1>
                </header>
                <small class="date">{{dateAsText this.date}}</small>

                <p class="description">{{description}}</p>
                <small class="category {{category}}">{{category}}</small>
            </article>
        </a>
    {{/each}}
</section>
