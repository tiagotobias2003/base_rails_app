# Base App Rails

Aplicação base pronta para servir como ponto de partida para diferentes tipos de sistema.

O objetivo deste projeto é acelerar novos produtos com uma estrutura reutilizável, organizada e preparada para evolução. Ele pode ser usado para **ERPs, CRMs, sistemas internos, SaaS e dashboards administrativos**.

## Como rodar com Docker
Considerando que você já tenha o docker instalado e rodando na sua máquina, execute os comandos abaixo na ordem:

```bash
docker compose build --no-cache
docker compose run --rm web bundle
docker compose run --rm web bin/rails db:create db:migrate db:seed
docker compose up
```

## Funcionalidades

- **Autenticação web** com Devise (login, registro, confirmação de e-mail, recuperação de senha)
- **API REST** com autenticação JWT via [devise-jwt](https://github.com/waiting-for-dev/devise-jwt), compatível com o mesmo modelo de usuários do Devise
- **Perfil do usuário** com dados pessoais brasileiros, endereço e avatar via Active Storage
- **Postagens** com CRUD completo no dashboard e na API
- **Controle de acesso por roles** com [Rolify](https://github.com/RolifyCommunity/rolify)
  - Novos cadastros recebem automaticamente a role `user`
  - Usuários iniciais do seed são promovidos a `admin`
- **Gerenciamento de usuários** (apenas admins), via web e API
  - Listagem de todos os usuários
  - Promover usuários comuns a administrador
  - Remover a role de administrador (com proteção para o último admin e para auto-remoção)

## Como fazer login (dados do seed)

Após rodar `rails db:seed`, use uma das credenciais abaixo na tela de login do Devise:

| E-mail | Senha | Role |
|--------|-------|------|
| `user@example.com` | `123456` | admin |
| `admin@example.com` | `123456` | admin |

O seed também cria 10 usuários comuns gerados pelo Faker (senha padrão: `12345678`).

## Acesso rápido

- **Dashboard:** após login, acesse a área principal em `/posts`
- **Perfil:** `/profile`
- **Usuários (admin):** `/admin/users` — visível no menu lateral apenas para administradores

## API REST (`/api/v1`)

A API usa JSON e autenticação via header `Authorization: Bearer <token>`. O token JWT é emitido no login e revogado no logout (estratégia JTIMatcher).

### Autenticação

| Método | Rota | Auth | Descrição |
|--------|------|------|-----------|
| `POST` | `/api/v1/login` | — | Login com e-mail e senha; retorna JWT no header `Authorization` |
| `DELETE` | `/api/v1/logout` | JWT | Revoga o token atual |
| `GET` | `/api/v1/me` | JWT | Retorna o usuário autenticado |

### Posts

| Método | Rota | Auth | Descrição |
|--------|------|------|-----------|
| `GET` | `/api/v1/posts` | JWT | Lista todas as postagens |
| `GET` | `/api/v1/posts/:id` | JWT | Detalhe de uma postagem |
| `POST` | `/api/v1/posts` | JWT | Cria postagem (vinculada ao usuário logado) |
| `PATCH` | `/api/v1/posts/:id` | JWT | Atualiza postagem (dono ou admin) |
| `DELETE` | `/api/v1/posts/:id` | JWT | Remove postagem (dono ou admin) |

### Usuários (admin)

| Método | Rota | Auth | Descrição |
|--------|------|------|-----------|
| `GET` | `/api/v1/users` | JWT (admin) | Lista todos os usuários |
| `PATCH` | `/api/v1/users/:id/role` | JWT (admin) | Define a role (`admin` ou `user`) |

### Exemplos com curl

```bash
# Login — o token vem no header Authorization da resposta
curl -i -X POST http://localhost:3000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"user@example.com","password":"123456"}}'

# Salve o token retornado (ex.: Bearer eyJhbGci...)
TOKEN="Bearer <seu_token>"

# Usuário autenticado
curl http://localhost:3000/api/v1/me -H "Authorization: $TOKEN"

# Criar post
curl -X POST http://localhost:3000/api/v1/posts \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"post":{"title":"Meu post","body":"Conteúdo do post"}}'

# Listar posts
curl http://localhost:3000/api/v1/posts -H "Authorization: $TOKEN"

# Listar usuários (admin)
curl http://localhost:3000/api/v1/users -H "Authorization: $TOKEN"

# Promover usuário a admin
curl -X PATCH http://localhost:3000/api/v1/users/1/role \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"role":"admin"}'

# Rebaixar usuário para user
curl -X PATCH http://localhost:3000/api/v1/users/1/role \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"role":"user"}'

# Logout
curl -X DELETE http://localhost:3000/api/v1/logout -H "Authorization: $TOKEN"
```

## Stack atual do projeto

- **Backend:** Ruby on Rails 8.1.3
- **Banco de dados:** PostgreSQL
- **Servidor web:** Puma
- **Assets:** Propshaft
- **Frontend Rails:** Importmap + Turbo + Stimulus
- **UI:** Tailwind CSS (template TailAdmin)
- **Autenticação:** Devise + devise-jwt (API)
- **Roles:** Rolify
- **Infra nativa Rails:** Solid Cache, Solid Queue e Solid Cable
- **Utilitários:** Jbuilder, Image Processing, Faker, Kamal, Thruster e Bootsnap

## Layouts disponíveis

- **Público:** para páginas sem login (`app/views/layouts/public.html.erb`)
- **Devise:** para telas de autenticação (`app/views/layouts/devise.html.erb`)
- **Application:** layout principal do dashboard (`app/views/layouts/application.html.erb`)

### Onde conferir o layout usado nas views

- Definição por controller (ex.: `layout "public"` em `app/controllers/pages_controller.rb`)
- Quando não houver definição explícita, o Rails usa o layout `application` por padrão

## Links de referência do template

- [Visit Website](https://tailadmin.com)
- [Documentation](https://tailadmin.com/docs)
- [Download](https://tailadmin.com/download)
- [Figma Design File (Community Edition)](https://www.figma.com/community/file/1463141366275764364)
