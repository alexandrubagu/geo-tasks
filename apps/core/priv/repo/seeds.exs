driver =
  %Core.Accounts.User{
    first_name: "Bagu",
    last_name: "Alex",
    email: "alexandrubagu87@gmail.com",
    type: :driver
  }
  |> Core.Repo.insert!()

%Core.Accounts.Token{user_id: driver.id, value: "random_driver_token"} |> Core.Repo.insert!()

manager =
  %Core.Accounts.User{
    first_name: "Bagu",
    last_name: "Alex",
    email: "alexandrubagu87@gmail.com",
    type: :manager
  }
  |> Core.Repo.insert!()

%Core.Accounts.Token{user_id: manager.id, value: "random_manager_token"} |> Core.Repo.insert!()
