# revenda_Luis

Este projeto consiste em um banco de dados em **PostgreSQL** para uma loja fictícia de **revenda de instrumentos musicais**.  
Ele foi desenvolvido para organizar clientes, produtos, fornecedores, pedidos e pagamentos de forma estruturada e com integridade garantida.

---

## 📑 Estrutura do Banco

O banco chama-se **db_revenda_luis** e possui **6 tabelas**:

1. **cliente** → Armazena dados dos clientes (nome, e-mail, CPF, telefone e data de cadastro).  
2. **produto** → Catálogo de instrumentos e acessórios (nome, categoria, preço, estoque, fabricante).  
3. **fornecedor** → Registro de fornecedores dos produtos (nome, CNPJ, contato e cidade).  
4. **pedido** → Guarda informações de compras feitas pelos clientes (data, valor total, status e observações).  
5. **pedido_produto** → Tabela de ligação que conecta pedidos e produtos (quantidade de cada item).  
6. **pagamento** → Registra informações sobre pagamentos (método, valor, data e confirmação).

---

## 🔑 Regras de Negócio e Restrições

- Todas as tabelas possuem **chave primária (PK)**.  
- Tabelas que dependem de outras possuem **chaves estrangeiras (FK)**.  
- A tabela `pedido_produto` utiliza **chave composta** para relacionar pedidos e produtos.  
- Há uso de:
  - **NOT NULL** em campos obrigatórios.  
  - **UNIQUE** em CPF, CNPJ e e-mails.  
  - **DEFAULT** em campos como datas e status.  
  - **CHECK** para validar condições (ex.: preço > 0, quantidade > 0).  
  - Valores limitados em certos atributos (ex.: status de pedido pode ser apenas *Pendente*, *Pago* ou *Cancelado*).  

---

## 👁️ Views Criadas

Foram criadas duas **views** para facilitar consultas:

- **vw_resumo_pedidos** → mostra os pedidos com informações principais do cliente, data, valor total e status.  
- **vw_itens_pedido** → mostra os itens de cada pedido com nome do produto, quantidade, preço unitário e subtotal calculado.  

Essas views permitem que o sistema recupere dados de forma rápida e organizada sem precisar consultar várias tabelas ao mesmo tempo.

---

## 📥 Dados Inseridos

Foram inseridos **10 registros em cada tabela**, totalizando:  
- 10 clientes cadastrados.  
- 10 produtos no catálogo.  
- 10 fornecedores diferentes.  
- 10 pedidos feitos.  
- 10 relações entre pedidos e produtos.  
- 10 pagamentos associados.  

Esses dados servem como base de teste para validar o funcionamento do banco.

---

## 🔎 Consultas de Teste

- A view **vw_resumo_pedidos** retorna um resumo de todos os pedidos feitos no sistema.  
- A view **vw_itens_pedido** retorna os produtos que compõem cada pedido, com cálculo automático de subtotal.  

---

## 📊 Relacionamentos (DER Simplificado)

- **Cliente** pode fazer vários **Pedidos**.  
- **Pedido** pode ter vários **Produtos** através da tabela de ligação **pedido_produto**.  
- **Produto** pertence a um **Fornecedor**.  
- **Pedido** possui um ou mais **Pagamentos**.  

---

## ✅ Conclusão

O banco de dados **db_revenda_luis** atende a todos os requisitos solicitados:  
- 6 tabelas (incluindo uma de ligação com chave primária composta).  
- Aplicação correta de restrições (PK, FK, UNIQUE, NOT NULL, DEFAULT, CHECK).  
- Duas views criadas com consultas envolvendo múltiplas tabelas.  
- 10 registros de exemplo em cada tabela.  
- Consultas validadas para garantir funcionamento.  

Esse modelo pode ser expandido futuramente para incluir notas fiscais, logística, promoções e relatórios de vendas, mas já está pronto para representar um sistema de revenda de instrumentos musicais.
