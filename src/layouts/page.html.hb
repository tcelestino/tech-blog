<!doctype html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, user-scalable=no'>
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
            <h2 class='categories-title'>Categorias</h2>
            <ul class='categories-list'>
                {{#each (getCategories)}}
                    <li><a href="/{{category}}">{{category}}</a></li>
                {{/each}}
            </ul>
        </nav>
    </header>
    <main>
        {{{content}}}
    </main>
    <footer>
    </footer>
</body>
</html>
