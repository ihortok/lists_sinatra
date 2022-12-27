# Lists

### Requirements

- Ruby 3.2.0
- Bundler 2.4.1
- SQLite
- Node.js
- Yarn

### Setup

#### 1. Clone the repository

```bash
git clone git@github.com:ihortok/lists_sinatra.git
cd lists_sinatra
```

#### 2. Install dependecies

```bash
bundle && yarn
```

#### 3. Setup the database

```bash
sequel -m db/migrations sqlite://db/lists_database.db
```

#### 4. Start the application

```bash
yarn run dev
rackup
```
