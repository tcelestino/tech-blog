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
</head>
<body>
    <header class="left-pane">
        <nav class='navigation'>
            <a href='{{site.baseUrl}}/' class='logo'>{{site.title}}</a>
            <h2 class='nav-title'>Categorias</h2>
            <ul class='nav-list'>
                {{#each (getCategories)}}
                    <li><a href="/{{category}}">{{category}}</a></li>
                {{/each}}
            </ul>
            <h2 class='nav-title'>Veja também</h2>
            <ul class='nav-list'>
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
