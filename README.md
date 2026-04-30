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

## Como fazer login (dados do seed)

Após rodar `rails db:seed`, use uma das credenciais abaixo na tela de login do Devise:

- **Email:** `user@example.com` | **Senha:** `123456`
- **Email:** `user2@example.com` | **Senha:** `123456`

## Acesso rápido

- Dashboard: após login, acesse a área principal em `posts_path` (rota "Ir para Dashboard").

## Stack atual do projeto

- **Backend:** Ruby on Rails 8.1.3
- **Banco de dados:** PostgreSQL
- **Servidor web:** Puma
- **Assets:** Propshaft
- **Frontend Rails:** Importmap + Turbo + Stimulus
- **UI:** Tailwind CSS
- **Autenticação:** Devise
- **Infra nativa Rails:** Solid Cache, Solid Queue e Solid Cable
- **Utilitários:** Jbuilder, Image Processing, Kamal, Thruster e Bootsnap

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
