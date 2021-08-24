// 1 - USE: Selecionamos um banco de dados, ao utilizar pela primeira vez criamos
use newflixDB;

// O MongoDB armazena documentos em coleções, sendo a coleção análoga às tableas de DB relacionais
// Se uma coleção não existir, ela será criada ao adicionar dados pela primeira vez
// Usamos insertMany para inserir vários de uma vez
db.filmes.insertMany([
    {
        titulo: "Titanic",
        lançamento: 1997,
        direcao: "James Cameron",
        genero: ["Drama", "Romance"],
        duracao: 135,
        idioma: "Inglês",
        notas: {
            imprensa: 4.1,
            usuarios: 4.6
        }
    },
    {
        titulo: "O Auto da Compadecida",
        lançamento: 2000,
        direcao: "Guel Arraes",
        genero: ["Comédia", "Aventura"],
        duracao: 95,
        idioma: "Português",
        notas: {
            imprensa: 4.3,
            usuarios: 4.7
        }
    },
    {
        titulo: "Que horas ela volta?",
        lançamento: 2015,
        direcao: "Anna Muylaert",
        genero: ["Drama"],
        duracao: 112,
        idioma: "Português",
        notas: {
            imprensa: 4.2,
            usuarios: 4.5
        }
    }
]);


db.series.insertMany([
    {
        titulo: "Dark",
        lançamento: 2017,
        encerramento: 2020,
        genero: ["Drama", "Ficção científica", "Suspense"],
        idioma: "Alemão",
        notas: {
            imprensa: 4.8,
            usuarios: 4.6
        }
    },
    {
        titulo: "Stranger Things",
        lançamento: 2016,
        genero: ["Drama", "Fantasia", "Suspense"],
        idioma: "Inglês",
        notas: {
            imprensa: 4.7,
            usuarios: 4.6
        }
    }
]);

db.users.insertMany([
    {
        nome: "Millie Bobby Brown",
        nascimento: ISODate("1997-12-19T00:00:00Z")
    },
    {
        nome: "David Harbour",
        nascimento: ISODate("1987-05-01T00:00:00Z")
    }
]);

// 27 - RENAMECOLLECTION : Renomeia uma coleção
db.users.renameCollection("usuarios");

// 26 - SAVE: Atualiza ou insere um novo documento 
// Nesse caso, por não ter o id, está inserindo
db.series.save(
    {
        titulo: "Black Mirror",
        lançamento: 2011,
        genero: ["Drama", "Ficção científica", "Suspense"],
        idioma: "Inglês",
        notas: {
            imprensa: 4.5,
            usuarios: 4.6
        }
    }
);

// Adicionar o filme mais recente visto por Millie
// 25 - UPDATE: Atuaiza um documento
// 21 - SET: Define um novo valor para o campo indicado
db.usuarios.update(
    {
        nome: "Millie Bobby Brown",
    },
    {
        $set: {
            filme_recente: "Titanic"
        }
    }
);

// Retorna informações do filme mais recente
// 4 - AGGREGATE: Calcula valores agregados em grupo
// 29 - LOOKUP: Similar ao LEFT JOIN retorna informações de duas coleções
// 19 - PRETTY: Deixa identado como JSON
db.usuarios.aggregate([
    {
        $lookup: {
            from: "filmes",
            localField: "filme_recente",
            foreignField: "titulo",
            as: "info_filme_recente"
        }
    }
]).pretty();

// Selecionamos o filme recente visto e geramos recomendações e filmes
// 30 - FINDONE: Retorna um documento que satisfaça o criterio definido
var millie_fr = db.usuarios.findOne(
    {
        nome: "Millie Bobby Brown"
    },
    {
        _id: 0,
        filme_recente: 1
    });

// AND: Une condições
// IN: Pesquisa em Array
// NE: Compara diferença
var recomendacao_filme = db.filmes.find({
    $and: [
        {
            genero: {
                $in: db.filmes.distinct("genero", { "titulo": millie_fr.filme_recente })
            }
        },
        {
            titulo: {
                $ne: millie_fr.filme_recente
            }
        }
    ]
});

db.usuarios.update(
    {
        nome: "Millie Bobby Brown",
    },
    {
        $set: {
            recomendacao: recomendacao_filme
        }
    }
);

// Média imprensa dos filmes de Drama
// 5 - MATCH: Filtro para selecionar documentos com uma condição específica
// 8 - GROUP: Agrupa documenos através de uma id específica.
// 10 - COUNT: Contador
// 12 - AVG: Tirar média
db.filmes.aggregate([
    {
        $match: {
            genero: "Drama"
        }
    },
    {
        $group: {
            _id: null,
            media: {
                $avg: "$notas.imprensa"
            },
            quantidade: { $count: {} }
        }
    }
]);

// Pesquisas por gênero
// Filmes classificados com um único gênero
// 3 - SIZE: Critério para array com um número específico de elementos
db.filmes.find({
    genero: {
        $size: 1
    }
}).pretty();

// Séries que são de Drama e Ficção científica
// 20 - ALL: Seleciona os documentos com valor igual a todos especificados em uma matriz
db.series.find({
    genero: {
        $all: ["Drama", "Ficção científica"]
    }
}).pretty();

// Retorna os filmes excluindo o gênero drama
//24 - FILTER: retorna um subset de um array a partir de uma condição especificada. Retorna apenas os elementos do array que atendem à condição.                         
db.filmes.aggregate([
    {
        $project: {
            _id: 0,
            titulo: 1,
            genero: {
                $filter: {
                    input: "$genero",
                    as: "g",
                    cond: { $ne: ["$$g", "Drama"]} 
                }
            }
        }
    }
]);

// Comparação das notas das séries e rankeamento
// 6 - PROJECT: Seleciona os documentos de acordo com os campos solicitados e passa para próxima pipeline
// 7 - GTE: Função de comparação maior que
// 14 - SORT: Ordena os campos (no caso, ordem alfabética)
// 20 - COND: Condição que deverá ser satisfeita
db.series.aggregate([
    {
        $project: {
            _id: 0,
            titulo: 1,
            ranking: {
                $cond: {
                    if: {
                        $and: [
                            { $gte: ["$notas.imprensa", 4.6] },
                            { $gte: ["$notas.usuarios", 4.6] }
                        ]
                    },
                    then: "Muito recomendado",
                    else: "Dentro da normalidade"
                }
            }
        }
    },
    {
        $sort: {
            ranking: -1
        }
    }
]);

// Pesquisas com duração do filme
// Filmes maiores que 2h
db.filmes.find({
    duracao: {
        $gte: 120
    }
});

// Menor filme, maior filme e tempo para maratonar todos os filmes
// 9 - SUM: Soma os valores em um grupo
// 11 - MAX: Retorna o valor máximo em comparação
db.filmes.aggregate([
    {
        $group: {
            _id: null,
            menor_filme: {
                $min: "$duracao"
            },
            maior_filme: {
                $max: "$duracao"
            },
            maratona: {
                $sum: "$duracao"
            }
        }
    }
]);

// Series já encerradas e não encerradas, respectivamente
// 13 - EXISTS: Comparação booleana para ver se um campo existe
db.series.find({
    encerramento: { $exists: true }
}).pretty();

db.series.find({
    encerramento: { $exists: false }
}).pretty();

// Adicionando outro gênero ao filme
// 31 - ADD TO SET: Adiciona valor a um array
db.filmes.update(
    {
        titulo: "Titanic"
    },
    {
        $addToSet: {
            genero: "Histórico"
        }
    }
);

// Pesquisa por filme que tenha volta no título
// 22 - TEXT: define o texto para busca em indice
// 23 - SEARCH: realiza a busca por indice

db.filmes.createIndex({
    titulo: "text"
});

db.filmes.findOne({
    $text: {
        $search: "volta"
    }
});

// Selecione uma serie com mais de 4.5 de nota dos usuarios
// 15 - LIMIT: Limita o número de documentos que será buscado
db.series.find({
    "notas.usuarios": {
        $gte: 4.5
    }
}).limit(1);

// 16 - WHERE: Passa uma faunção JavaScript para comparar strings em uma consulta
// 17 - FUNCTION: Função JavaScript
db.series.find({
    $where: function () {
        return (hex_md5(this.titulo) == "a18366b217ebf811ad1886e4f4f865b2")
    }
}).pretty();

// Quantidade de séries por idioma
// 17 - MAPREDUCE: Função de mapeamento
var mapFunc = function () {
    emit(this.idioma, this.titulo)
};

var reduceFunc = function (key, titulo) {
    return Array.push(titulo)
};

db.series.mapReduce(
    mapFunc, reduceFunc,
    { out: "map_reduce_series" }
);

db.map_reduce_series.find();

// DROP - Apagar dados do DB
db.dropDatabase();