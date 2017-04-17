<!doctype html>
<html lang="pt-br">
<head>
    <meta charset='UTF-8'>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name='description' content='{{document.description}}'>
    <meta name="google-site-verification" content="NqCILBTY8B8P-r_KF8BSZKH9kUQgQOEbXJvEMaB33vw">
    <meta name="theme-color" content="#FDC24F">
    <meta name="keywords" content="Elo7,tecnologia,post,desenvolvimento,blog,{{document.tags}}">
    <meta name="language" content="pt-br">
    <meta name="title" content="Elo7 Tech - {{document.title}}">
    <meta name="apple-mobile-web-app-title" content="Elo7 Tech - {{document.title}}">
    <meta name="mobile-web-app-capable" content=yes>

    <meta property="fb:app_id" content="644444999041914">
    <meta property="fb:admins" content="100003324447975">

    <meta property="og:site_name" content="Elo7 Tech">
    <meta property="og:image" content="{{site.url}}/images/ico/elo7.png">
    <meta property="og:type" content="website">
    <meta property="og:title" content="Elo7 Tech - {{document.title}}">
    <meta property="og:url" content="{{site.url}}">
    <meta property="og:description" content="{{document.description}}">

    <meta name="twitter:widgets:csp" content="on">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" value="Elo7 Tech - {{document.title}}">

    <meta property="twitter:title" content="Elo7 Tech - {{document.title}}">
    <meta property="twitter:domain" content="{{site.url}}">
    <meta property="twitter:url" content="{{site.url}}">
    <meta property="twitter:description" content="{{document.description}}">
    <meta property="twitter:image" content="{{site.url}}/images/ico/elo7.png">

    <link rel='canonical' href="{{site.url}}">

    <title>Elo7 Tech - {{document.title}}</title>
    <link rel='stylesheet' href='/reset.css'>
    <link rel='stylesheet' href='/main.css'>
    <link rel='stylesheet' href='/posts.css'>
    <link rel='stylesheet' href='/post.css'>
    <link rel="icon" type="image/png" href="/images/favicon.ico">
    <script>window.addEventListener('error', window.__e=function f(e){f.q=f.q||[];f.q.push(e)});</script>
</head>
<body itemscope itemtype="http://schema.org/WebPage" data-env="{{getEnvironment}}">
    <header class="left-pane">
        <div class="logo-container">
            <a rel="home" itemprop="url" href='/' class='logo'>{{site.title}}</a>
        </div>
        <nav aria-label="Navigation" itemscope itemtype="http://schema.org/SiteNavigationElement" class='navigation'>
            <input id="categories-switch" type="checkbox" class="categories-switch">
            <label for="categories-switch" class="selectable">
                <h2 class='nav-title'>Categorias</h2>
            </label>
            <ul class='nav-list nav-category'>
                {{#each (getCategories)}}
                    <li><a itemprop="url" href="/{{category}}">{{category}}</a></li>
                {{/each}}
            </ul>
            <input id="more-switch" type="checkbox" class="more-switch">
            <label for="more-switch" class="selectable">
                <h2 class='nav-title'>Veja também</h2>
            </label>
            <ul class='nav-list nav-more'>
                <li><a itemprop="url" href="http://carreira.elo7.com.br/engenharia/" target="_blank">A engenharia</a></li>
                <li><a itemprop="url" href="http://carreira.elo7.com.br/" target="_blank">Carreiras</a></li>
                <li><a itemprop="url" href="http://eventos.elo7.com.br/" target="_blank">Nossos eventos</a></li>
                <li><a itemprop="url" href="http://elo7.com.br/" target="_blank">Elo7</a></li>
            </ul>
        </nav>
        <a rel="external" itemprop="url" href="https://github.com/elo7/tech-blog" class="social github"></a>
    </header>
    <main aria-label="Main content" itemscope itemtype="http://schema.org/Blog">
        {{{content}}}
    </main>
    <footer>
        <a rel="home" itemprop="url" href="http://engenharia.elo7.com.br/" itemscope itemtype="http://schema.org/Organization">
            <span itemprop="copyrightHolder">engenharia.elo7.com.br © 2016</span>
        </a>
    </footer>
    <script async src="https://www.google-analytics.com/analytics.js"></script>
    <script async src="/js/analytics.js"></script>
            ga('create', 'UA-3692628-29', 'auto');
            ga('send', 'pageview');
        </script>
    {{/if}}
    <script async src='/js/vendor/async-define.js'></script>
    <script async src='/js/vendor/events-amd.js'></script>
    <script async src='/js/vendor/ajax.js'></script>
    <script async src='/js/vendor/doc.js'></script>
    <script async src='/js/post.js'></script>
</body>
</html>
