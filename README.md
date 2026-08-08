# Minhas Finanças — passos para colocar no ar

O app já está pronto e testado. Faltam só 3 coisas: criar o banco de dados (Supabase), colar as chaves no arquivo, e publicar (GitHub Pages). Nenhuma delas exige saber programar — é só seguir os passos.

## 1. Criar o banco de dados (Supabase)

1. Acesse [supabase.com](https://supabase.com) e entre com sua conta (ou crie uma, é grátis).
2. Clique em **New project**. Dê um nome (ex: `financas-pessoais`) e uma senha para o banco — guarde essa senha em local seguro, mas você não vai precisar dela no dia a dia.
3. Espere o projeto ficar pronto (leva ~1 minuto).
4. No menu da esquerda, clique em **SQL Editor** → **New query**.
5. Abra o arquivo [`schema.sql`](schema.sql) desta pasta, copie todo o conteúdo, cole no editor e clique em **Run**.
6. Deve aparecer "Success. No rows returned" — pronto, as tabelas foram criadas.

## 2. Pegar as chaves e colar no app

1. No Supabase, vá em **Project Settings** (ícone de engrenagem) → **API**.
2. Copie o valor de **Project URL** (começa com `https://` e termina em `.supabase.co`).
3. Copie o valor de **anon public** (uma chave longa, começa com `sb_publishable_` ou `eyJ...`).
4. Abra o arquivo `index.html` desta pasta em qualquer editor de texto (ou peça para eu fazer essa parte).
5. Perto do topo do arquivo, você vai ver:
   ```js
   window.SUPA_URL = 'COLE_SUA_URL_AQUI';
   window.SUPA_ANON = 'COLE_SUA_CHAVE_AQUI';
   ```
   Troque `COLE_SUA_URL_AQUI` pela Project URL e `COLE_SUA_CHAVE_AQUI` pela chave anon public. Salve o arquivo.

Depois disso, ao abrir o app, vai aparecer uma tela pedindo e-mail e senha — é ali que você cria sua conta.

## 3. Publicar no GitHub Pages

1. Acesse [github.com/new](https://github.com/new). Nome do repositório: `minhas-financas` (pode ser outro nome). **Marque como Private** — os dados continuam protegidos mesmo se o repositório fosse público (porque exigem login e o banco só entrega o que é seu), mas deixando privado ninguém nem acha o link do projeto por acaso.
2. Clique em **Create repository**.
3. Na tela seguinte, clique em **uploading an existing file** e arraste todos os arquivos desta pasta (`index.html`, `manifest.webmanifest`, `sw.js`, `icone.svg`) — não precisa subir o `schema.sql` nem este `README.md`.
4. Clique em **Commit changes**.
5. Vá em **Settings** (do repositório) → **Pages**, na seção **Branch** escolha `main` e `/ (root)`, clique em **Save**.
6. Espere ~1 minuto e atualize a página — vai aparecer o link do site, algo como `https://seu-usuario.github.io/minhas-financas/`.

## 4. Reforçar a segurança no Supabase

Duas configurações do painel do Supabase (não é código, é só marcar umas opções) que fecham brechas que o app sozinho não consegue fechar:

1. Vá em **Authentication** → **Policies** e confira que as 3 tabelas (`fin_lancamentos`, `fin_contas_fixas`, `fin_metas`) aparecem com o cadeado **RLS enabled** — isso já vem pronto do `schema.sql`, é só conferir que não foi desligado sem querer.
2. Vá em **Authentication** → **Sign In / Providers** → **Email**, e ative **"Leaked password protection"** (recusa senha que já vazou em outros sites, checando contra o banco público do Have I Been Pwned).
3. Depois que você já tiver criado a sua conta no app, volte em **Authentication** → **Sign In / Providers** → **Email** e desative **"Allow new users to sign up"**. Assim ninguém mais consegue criar conta nesse projeto — só quem já tem login (você) consegue entrar.

## 5. Instalar no iPhone

1. Abra o link do passo anterior no Safari do iPhone.
2. Toque no ícone de **Compartilhar** (o quadrado com a seta para cima).
3. Toque em **Adicionar à Tela de Início**.
4. Pronto — o app abre em tela cheia, com ícone próprio, como um app de verdade.

## O que já vem protegido de fábrica

- **Cada dado só existe para o dono dele** — o banco (RLS) rejeita, na origem, qualquer tentativa de ler ou gravar um registro que não seja seu, mesmo que alguém tente manipular o app pelo navegador.
- **Toda a comunicação é criptografada** (HTTPS, tanto no GitHub Pages quanto no Supabase).
- **O app só conversa com o Supabase** — adicionei uma trava (Content-Security-Policy) que impede a página de mandar dados pra qualquer outro endereço da internet, mesmo que alguém conseguisse injetar código malicioso nela.
- **Sessão expira sozinha** — se o app ficar aberto sem uso por 30 minutos, ele desloga automaticamente; quem pegar o celular destravado depois disso vai precisar da senha de novo.
- **Senha de pelo menos 8 caracteres** exigida ao criar a conta ou trocar a senha.

## Se precisar de ajuda

Qualquer passo travar, me chama de novo com o que aconteceu (print da tela ajuda) que eu te ajudo a destravar.
