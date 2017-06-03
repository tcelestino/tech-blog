---
title: Vagas
description: Todos os posts da categoria vagas
layout: page
---
<section class="posts-container" itemscope itemtype="http://schema.org/Blog">
	{{#each (getCollection "vagas")}}
			<article itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" class="post-card card-{{category}}">
				<header>
					<a href="{{../site.baseUrl}}{{url}}" class="link">
						<h2 itemprop='name' class="title">{{title}}</h2>
					</a>
				</header>
				<div class="post-meta">
					by 
					<a href="/{{author}}" class="author" itemprop='author' itemscope itemtype="http://schema.org/Person">
						<p itemprop='name'>@{{author}}</p>
					</a>
					· 
					<time datetime="{{dateAsText this.date}}" class="date">
						{{dateAsText this.date}}
						<meta itemprop="datePublished" content='{{this.date}}'/>
					</time>
				</div>

				<p class="description" itemprop='headline'>{{description}}</p>
				<a href="/{{category}}" class="category {{category}}">{{category}}</a>
				<a href="{{../site.baseUrl}}{{url}}" class="link post-link">Continue lendo</a>

				<span itemprop="image" itemscope itemtype="http://schema.org/ImageObject"> <!--Change for a post image-->
					<link href="{{../site.baseUrl}}/images/ico/elo7.png" itemprop="url"/>
					<meta itemprop='width' content='100px'/>
					<meta itemprop='height' content='100px'/>
				</span>
				<meta itemprop='mainEntityOfPage' content='Elo7 Serviços de Informática SA'/>
				<span itemprop='publisher' itemscope itemtype="http://schema.org/Organization">
					<meta itemprop='name' content='Elo7 Tech'/>
					<span itemprop="logo" itemscope itemtype="http://schema.org/ImageObject">
						<link href="https://images.elo7.com.br/assets/v3/desktop/png/logo-elo7.png" itemprop="url"/>
						<meta itemprop='width' content='100px'/>
						<meta itemprop='height' content='100px'/>
					</span>
				</span>
			</article>
	{{/each}}
</section>
