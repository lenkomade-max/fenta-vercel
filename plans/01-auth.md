# 01 - Авторизация (Supabase Auth)

## Цель
Полноценная система авторизации: регистрация, логин, OAuth, защита роутов.

## Что реализовать

### Supabase клиент
- `src/lib/supabase/client.ts` - браузерный клиент (createBrowserClient)
- `src/lib/supabase/server.ts` - серверный клиент (createServerClient)
- `src/lib/supabase/middleware.ts` - refresh токенов

### Middleware
- `src/middleware.ts` - проверка сессии, редирект неавторизованных на /login

### Страницы (auth)
- `src/app/(auth)/login/page.tsx` - email/password + OAuth кнопки
- `src/app/(auth)/register/page.tsx` - регистрация
- `src/app/(auth)/callback/route.ts` - OAuth callback

### Компоненты
- `src/components/auth/login-form.tsx`
- `src/components/auth/register-form.tsx`
- `src/components/auth/oauth-buttons.tsx` (Google, GitHub)

### Хуки
- `src/hooks/use-user.ts` - текущий пользователь
- `src/hooks/use-auth.ts` - signIn, signOut, signUp

### Типы
- `src/types/database.ts` - сгенерировать через supabase gen types

## Зависимости
Нет (первый этап)

## Файлы для изменения
- `src/components/layout/app-sidebar.tsx` - реальный user из сессии
- `src/app/(dashboard)/layout.tsx` - защита + получение user
