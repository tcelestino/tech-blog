<!doctype html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Elo7 Tech - {{document.title}}</title>
    <meta name='description' content='{{document.description}}'>
    <meta name="google-site-verification" content="NqCILBTY8B8P-r_KF8BSZKH9kUQgQOEbXJvEMaB33vw" />
    <link rel='stylesheet' href='/reset.css'>
    <link rel='stylesheet' href='/main.css'>
    <link rel='stylesheet' href='/posts.css'>
    <link rel='stylesheet' href='/post.css'>
    <link rel="icon" type="image/png" href="/images/favicon.ico">
    <script>addEventListener('error', window.__e=function f(e){f.q=f.q||[];f.q.push(e)});</script>
</head>
<body itemscope itemtype="http://schema.org/WebPage">
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
    {{#if (isProduction)}}
        <script async src="https://www.google-analytics.com/analytics.js"></script>
        <script async src="/js/analytics.js"></script>
    {{/if}}
</body>
</html>
