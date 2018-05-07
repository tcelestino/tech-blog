<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<channel>
		<title>Elo7 Tech</title>
		<link>{{site.url}}/feed.xml</link>
		<atom:link href="{{site.url}}/rss.xml" rel="self" type="application/rss+xml" />
		<description>Blog de tecnologia do Elo7, com postagens dos próprios colaboradores mostrando como é o dia a dia de um colaborador fora de série</description>
		<lastBuildDate>{{today}}</lastBuildDate>
		<language>pt-BR</language>
		{{#each (getCollection "posts")}}
			<item>
				<title>{{title}}</title>
				<link>{{../site.url}}{{encodeURI url}}</link>
				<guid>{{../site.url}}{{encodeURI url}}</guid>
				<pubDate>{{dateAsRFC date}}</pubDate>
				<dc:creator><![CDATA[{{#each authors}}{{.}} {{/each}}]]></dc:creator>
				<category><![CDATA[{{category}}]]></category>
				{{#each tags}}
					<category><![CDATA[{{.}}]]></category>
				{{/each}}
				<description><![CDATA[
					{{#if image}}
						<img alt="{{title}}" width="500" src="{{../../site.url}}/images/{{image}}" />
						<br><br>
					{{/if}}
					{{description}}
				]]></description>
			</item>
		{{/each}}
	</channel>
</rss>
