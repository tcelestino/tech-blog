<!doctype html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Elo7 Tech</title>
    <link rel='stylesheet' href='{{site.baseUrl}}/reset.css'>
    <link rel='stylesheet' href='{{site.baseUrl}}/fonts.css'>
    <link rel='stylesheet' href='{{site.baseUrl}}/main.css'>
    <link rel='stylesheet' href='{{site.baseUrl}}/posts.css'>
    <link rel='stylesheet' href='{{site.baseUrl}}/post.css'>
</head>
<body>
    <header class="left-pane">
        <nav class='navigation'>
            <div class="logo-container">
                <a href='{{site.baseUrl}}/' class='logo'>{{site.title}}</a>
            </div>
            <input id="categories-switch" type="checkbox" class="categories-switch">
            <label for="categories-switch" class="selectable">
                <h2 class='nav-title'>Categorias</h2>
            </label>
            <ul class='nav-list nav-category'>
                {{#each (getCategories)}}
                    <li><a href="/{{category}}">{{category}}</a></li>
                {{/each}}
            </ul>
            <input id="more-switch" type="checkbox" class="more-switch">
            <label for="more-switch" class="selectable">
                <h2 class='nav-title'>Veja também</h2>
            </label>
            <ul class='nav-list nav-more'>
                <li><a href="http://elo7.com.br" target="_blank">Conheça o Elo7</a></li>
                <li><a href="http://carreira.elo7.com.br/" target="_blank">Carreiras</a></li>
                <li><a href="http://eventos.elo7.com.br/" target="_blank">Nossos eventos</a></li>
            </ul>
        </nav>
        <a href="https://github.com/elo7/tech-blog" class="social github"></a>
    </header>
    <main>
        {{{content}}}
    </main>
    <footer>
    </footer>
</body>
</html>
