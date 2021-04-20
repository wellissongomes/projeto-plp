<p align="center">
  <a href="" rel="noopener">
  <img width=300px height=200px src="./imagens/logo.png" alt="Logo do Projeto"></a>
</p>

<h3 align="center">Candy Land
</h3>

---

<p align="center"> O nosso sistema a ser desenvolvido consiste em uma doceria, o qual o usuário irá interagir com um chatbot por meios de palavras chaves.
    <br>
</p>

## 📝 Sumário

- [Especificação](#sobre)
- [Iniciando](#inicio)
- [Tecnologias Usadas](#tecnologias-usadas)
- [TODO](./TODO.md)
- [Contribuindo](./CONTRIBUTING.md)
- [Desenvolvedores](#desenvolvedores)

## 🧐 Especificação <a name = "sobre"></a>

**Dono** da loja vai poder:

- Cadastrar um subordinado, cujas funções predefinidas são confeiteiro ou vendedor

- Cada subordinado possui um cpf, nome, profissão e suas funções que serão descritas na seção de funcionários.

- Definir o cardápio dinamicamente, com diversos doces que contém:

- Os doces irão ter id, nome, preço e uma descrição(e.g., calda de chocolate, morango, etc)

- Editar as propriedades do doce
- Listar todas as vendas já feitas
- Visualizar lista de doces
- Visualizar lista da funcionarios

O **funcionário** é encarregado de:

- Cadastrar um cliente

- Ele tem um cpf, nome.

- Cadastrar a vendas

- Finalizar uma venda para um determinado cliente.

- Visualizar a lista de Clientes.
- Visualizar a lista de vendas feitas pelo funcionário.

O **cliente** é permitido:

- Visualizar produtos personalizados ou não, bem avaliados anteriormente, considerar produtos bem avaliados a partir de 4 estrelas.
- Visualizar o cardápio com os produtos e ingredientes disponíveis.
- Personalizar pedido de acordo com os ingredientes do cardápio, o preço vai variar de acordo com os ingredientes escolhidos.

- Pode escolher criar um produto criado aleatoriamente pelo sistema.

- Fazer uma compra
- Visualizar as compras feitas pelo mesmo.
- Avaliar as compras feitas de 0 a 5 estrelas, default é 5, se não reclamou é porque gostou.

## 🏁 Iniciando <a name = "inicio"></a>

Instruções de como reproduzir uma cópia do projeto para desenvolvê-lo ou testá-lo.

### Pré-requisitos

Clone o projeto

```
git clone https://github.com/wellissongomes/projeto-plp.git
```

#### Para Haskell

Entre na pasta clonada e logo após entre na pasta [haskell/](./haskell)

```
cd projeto-plp/haskell
```

Instale as dependências do projeto

```
chmod +x dependencies.sh && ./dependencies.sh
```

Por fim, execute o programa

```
chmod +x run.sh && ./run.sh
```

## ⛏️ Tecnologias Usadas <a name = "tecnologias-usadas"></a>

- [Haskell](https://www.haskell.org/) - Utilizado para programação funcional
- [Prolog](https://www.swi-prolog.org/) - Utilizado para programação lógica

## ✍️ Desenvolvedores <a name = "desenvolvedores"></a>

- [@ericdmg](https://github.com/ericdmg) - Eric Gonçalves
- [@gabrielmbs](https://github.com/gabrielmbs) - Gabriel Souto
- [@victorbrandaoa](https://github.com/victorbrandaoa) - Victor Brandão
- [@wellissongomes](https://github.com/wellissongomes) - Wellisson Gomes
