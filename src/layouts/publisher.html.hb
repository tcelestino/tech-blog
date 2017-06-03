---
layout: page
---
<link rel="stylesheet" href="/publisher.css">

<article class='publisher-info' itemscope itemtype='http://schema.org/Person'>
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
		<p class='publisher-description' itemprop='description'>{{.}}</p>
	{{/document.description}}
</article>

<section class="posts-container" itemscope itemtype="http://schema.org/Blog">
	{{#each (getCollection "posts")}}
		{{#equal author ../document.github}}
			<article itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" class="post-card card-{{category}}">
				<header>
						<a href="{{../site.baseUrl}}{{url}}" class="link">
								<h2 itemprop='name' class="title">{{title}}</h2>
						</a>
				</header>
				<div class="post-meta">
					by 
					<a href="https://github.com/{{author}}" class="author" itemprop='author' itemscope itemtype="http://schema.org/Person">
						<p itemprop='name'>@{{author}}</p>
					</a>
					· 
					<time datetime="{{dateAsText this.date}}" class="date">
						{{dateAsText this.date}}
						<span itemprop="datePublished" class='hide'>{{this.date}}</span>
					</time>
				</div>

				<p class="description" itemprop='headline'>{{description}}</p>
				<a href="/{{category}}" class="category {{category}}">{{category}}</a>
				<a href="{{../site.baseUrl}}{{url}}" class="link post-link">Continue lendo</a>
				<span class='hide'>
					<img itemprop='image' width='100px' height='100px' src="{{../site.baseUrl}}/images/ico/elo7.png"/> /*Change for a post image*/
					<p itemprop='mainEntityOfPage'>Elo7</p>
					<span itemprop='publisher' itemscope itemtype="http://schema.org/Organization">
						<p itemprop='name'>Elo7 Tech</p>
						<img itemprop='logo' src="//images.elo7.com.br/assets/v3/desktop/svg/logo-elo7.svg"/>
					</span>
				</span>
			</article>
		{{/equal}}
	{{/each}}
</section>
<script async src="/js/publisher.js"></script>
