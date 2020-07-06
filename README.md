# GeoTasks

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


### Manual testing
```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer random_manager_token" \
     --data '{"pickup":{"lat": "-50.2138", "long": "79.0312"},"delivery":{"lat": "-50.55", "long": "80.01"}}' \
     http://localhost:4000/api/tasks
```
