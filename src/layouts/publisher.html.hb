---
layout: page
---
<link rel="stylesheet" href="/publisher.css">

<article class='publisher-info'>
	<section class='info'>
		<h1 class='name' itemprop='publisher' data-author='{{document.publisher}}' class='publisher'>@{{document.publisher}}</h1>
		<a href='https://github.com/{{document.github}}' class='social github' title='Conheça meu github'>{{document.github}}</a>
		<a href='https://twitter.com/{{document.twitter}}' class='social twitter' title='Conheça meu twitter'>{{document.twitter}}</a>
	</section>
	<figure class='hide avatar'>
		<img width='100px' height='100px'/>
	</figure>
	<p class='description'>{{document.description}}</p>
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
<script async src="/js/publisher.js"></script>
