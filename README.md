# GeoTasks

[![Elixir CI](https://github.com/alexandrubagu/geo-tasks/workflows/Elixir%20CI/badge.svg)](https://github.com/alexandrubagu/geo-tasks/actions) [![Coverage Status](https://coveralls.io/repos/github/alexandrubagu/geo-tasks/badge.svg?branch=master)](https://coveralls.io/github/alexandrubagu/geo-tasks?branch=master)


### Setup
```
git clone git@github.com:alexandrubagu/geo-tasks.git
mix deps.get
mix do ecto.drop, ecto.create, ecto.migrate
mix run apps/core/priv/repo/seeds.exs
```

### Running tests
```elixir
mix test
```


### Manual testing example
```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer random_manager_token" \
     --data '{"pickup":{"lat": "-50.2138", "long": "79.0312"},"delivery":{"lat": "-50.55", "long": "80.01"}}' \
     http://localhost:4000/api/tasks
```
