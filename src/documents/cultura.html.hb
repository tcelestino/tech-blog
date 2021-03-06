---
title: Cultura
description: Confira todos os nossos posts sobre agilidade, ambiente de trabalho, cultura e liderança, escritos pelo time de Engenharia do Elo7, o maior marketplace de produtos criativos da América Latina.
layout: page
---

<section class="posts-container" itemscope itemtype="http://schema.org/Blog">
	<h1 class='title'>Cultura</h1>
    {{#each (getCollection "cultura")}}
		<article itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" class="post-card card-{{category}}">
			<header>
				<a href="{{../site.baseUrl}}{{url}}" class="link">
					<h2 itemprop='name' class="title">{{title}}</h2>
				</a>
			</header>
			<div class="post-meta">
				{{#each authors}}
					<a href="/{{this}}/" class="author" itemprop='author' itemscope itemtype="http://schema.org/Person">
						<p itemprop='name'>@{{this}}</p>
					</a>
				{{/each}}
				<time datetime="{{dateAsText this.date}}" class="date">
					{{dateAsText this.date}}
					<meta itemprop="datePublished" content='{{this.date}}'/>
				</time>
			</div>

			{{#description}}
				<p class="description" itemprop="description">
					{{.}}
				</p>
				<meta itemprop='headline' content='{{ellipsis . 110}}' >
			{{/description}}
			<a href="/{{category}}/" class="category {{category}}">{{category}}</a>
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
					<link href="{{../site.baseUrl}}/images/ico/logo-elo7.png" itemprop="url"/>
					<meta itemprop='width' content='100px'/>
					<meta itemprop='height' content='100px'/>
				</span>
			</span>
		</article>
	{{/each}}
</section>
