# Starter
This project contains an open source starter application that provides Auth and Crud functions. The template can easily be modified and used in (F)OSS projects, and always runs the latest version of each platform

## Why
This starter is created to limit the time between having a good idea and bringing it live. All overhead is removed, so the developer can only focus on the build the app specific feature.

## Features
- Designed with security and performance in mind, careful state management to prevent memory leaks
- Includes data & user management
- Prepared for dynamic data and streams
- Only open-source ingredients
  - [Flutter](https://www.flutter.dev) as the UI framework
  - [Supabase](https://www.supabase.com) for the database and authentication
  - OpenSans fonts
- Fully responsive for mobile, web, desktop (Linux, Mac & Windows), all with one codebase
- Secure storage for secrets like salts
- Includes local authentication (FaceID / Touch)
- Includes deep linking to specific pages in the app
- Includes modular widgets for clean code

## Make the backend work
Create an .env file in the project root to and your Supabase key & url. The starter uses the following schema that needs to be injected in the SQL menu in your Supabase account

```
create table if not exists public.profiles (
    id uuid references auth.users on delete cascade not null primary key,
    fullName varchar(24) not null unique,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null,

    -- fullNames should be 3 to 24 characters long containing alphabets, numbers and underscores
    constraint fullName_validation check (fullName ~* '^[A-Za-z0-9_]{3,24}$')
);
comment on table public.profiles is 'Holds all of users profile information';

create table if not exists public.messages (
    id uuid not null primary key default uuid_generate_v4(),
    profile_id uuid default auth.uid() references public.profiles(id) on delete cascade not null,
    content varchar(500) not null,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null
);
comment on table public.messages is 'Holds individual messages sent on the app.';
```

## Who can use it
Everyone for usage in an open source project

## Support
Please raise an issue of you can't figure something out or create a PR  want to improve the template.