moment = require('moment');

docpadConfig = function() {
    return {
        documentsPaths: ['documents', 'posts', 'assets'],

        plugins: {
            handlebars: {
                helpers: {
                    getCollection: function(name) {
                        return this.getCollection(name).toJSON();
                    },

                    dateAsText: function(date) {
                        return moment(date).utcOffset("00:00").format('DD MMM YYYY');
                    },
                    getCategories: function() {
                        return [
                            { category: "front-end" },
                            { category: "back-end" },
                            { category: "design" },
                            { category: "vagas" },
                            { category: "mobile" },
                            { category: "eventos" }
                        ];
                    }
                }
            },
            cleanurls: {
                static: true
            },
            markit: {
                html: true
            }
        },

        templateData: {
            site: {
                title: "Elo7 Tech",
                url: "http://localhost:9778"
            }
        },

        environments: {
            static: {
                templateData: {
                    site: {
                        url: "https://elo7.github.io/tech-blog",
                        baseUrl: "/tech-blog"
                    }
                }
            }
        },

        collections: function() {
            var collections = {
                posts : function() {
                    return this.getCollection('html')
                                .findAll({layout: 'post'})
                                .setComparator(function(postA, postB) {
                                    var dateA = postA.toJSON().date;
                                    var dateB = postB.toJSON().date;
                                    return moment(dateB).unix() - moment(dateA).unix();
                                });
                },
                frontend : function() {
                    return this.getCollection('html')
                                .findAll({layout: 'post'})
                                .setFilter('isCategory', function(model) {
                                    return model.attributes.category == "front-end";
                                })
                                .setComparator(function(postA, postB) {
                                    var dateA = postA.toJSON().date;
                                    var dateB = postB.toJSON().date;
                                    return moment(dateB).unix() - moment(dateA).unix();
                                });
                },

            }
            return collections;
        }()
    }
}();

module.exports = docpadConfig;
