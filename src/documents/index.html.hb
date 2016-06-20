---
layout: page
referenceOthers: true
---
<section>
    <ol>
        {{#each (getCollection "posts")}}
            <li>
                <span >{{dateAsText this.date}}</span>
                <small>{{this.category}}</small>
                <a href="{{../site.baseUrl}}{{this.url}}">{{this.title}}</a>
            </li>
        {{/each}}
    </ol>
</section>
