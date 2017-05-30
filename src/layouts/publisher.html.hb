---
layout: page
---
<link rel="stylesheet" href="/publisher.css">

<article class='publisher-info' itemtype='http://schema.org/Person'>
	<section class='info'>
		<h1 class='name' itemprop='name' data-author='{{document.publisher}}' class='publisher'>{{document.publisher}}</h1>
		<a href='https://github.com/{{document.github}}' class='social github' target='_blank' title='Conheça meu github'>{{document.github}}</a>
		{{#document.twitter}}
			<a href='https://twitter.com/{{.}}' class='social twitter' target='_blank' title='Conheça meu twitter'>{{.}}</a>
		{{/document.twitter}}
	</section>
	<figure class='hide avatar'>
		<img itemprop=image' width='100px' height='100px'/>
	</figure>
	{{#document.description}}
		<p class='description' itemprop='description'>{{.}}</p>
	{{/document.description}}
</article>

<section class="posts-container" itemtype="http://schema.org/Blog">
	{{#each (getCollection "posts")}}
		{{#equal author ../document.github}}
			<article itemprop="blogPost" itemtype="http://schema.org/BlogPosting" class="post-card card-{{category}}">
				<header>
						<a href="{{../site.baseUrl}}{{url}}" class="link">
								<h2 class="title">{{title}}</h2>
						</a>
				</header>
				<div class="post-meta" itemprop='author' itemscope itemtype="http://schema.org/Person">
						by <a href="https://github.com/{{author}}" class="author" itemprop='name'><p>@{{author}}</p></a>
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
